import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'dashboard.dart';

class TrackingReport extends StatefulWidget {
  const TrackingReport({super.key});

  @override
  State<TrackingReport> createState() => _TrackingReportState();
}

class _TrackingReportState extends State<TrackingReport> {
  late List<Map<String, String>> _dataList = [];
  bool _isDataLoaded = false;
  String? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Load data from shared preferences
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString('trackingData');

    if (storedData != null) {
      List<dynamic> decodedData = jsonDecode(storedData);
      setState(() {
        _dataList = decodedData.map((e) => Map<String, String>.from(e as Map)).toList();
        _isDataLoaded = true;
      });
    } else {
      setState(() {
        _dataList = [];
        _isDataLoaded = true;
      });
    }
  }

  /// Sanitize time input
  String sanitizeTime(String input) {
    return input
        .replaceAll(RegExp(r'[^\x20-\x7E]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Calculate duration between two times
  String calculateDuration(String fromTime, String toTime) {
    try {
      String sanitizedFrom = sanitizeTime(fromTime);
      String sanitizedTo = sanitizeTime(toTime);

      List<String> fromParts = sanitizedFrom.split(':');
      List<String> toParts = sanitizedTo.split(':');

      int fromHours = int.parse(fromParts[0].trim());
      int fromMinutes = int.parse(fromParts[1].substring(0, 2).trim());
      bool fromIsPM = sanitizedFrom.toLowerCase().contains('pm');
      if (fromIsPM && fromHours != 12) fromHours += 12;
      if (!fromIsPM && fromHours == 12) fromHours = 0;

      int toHours = int.parse(toParts[0].trim());
      int toMinutes = int.parse(toParts[1].substring(0, 2).trim());
      bool toIsPM = sanitizedTo.toLowerCase().contains('pm');
      if (toIsPM && toHours != 12) toHours += 12;
      if (!toIsPM && toHours == 12) toHours = 0;

      int fromTotalMinutes = fromHours * 60 + fromMinutes;
      int toTotalMinutes = toHours * 60 + toMinutes;

      if (toTotalMinutes < fromTotalMinutes) {
        toTotalMinutes += 24 * 60;
      }

      int durationMinutes = toTotalMinutes - fromTotalMinutes;
      int hours = durationMinutes ~/ 60;
      int minutes = durationMinutes % 60;

      return "${hours}h ${minutes}m";
    } catch (e) {
      print("Error calculating duration: $e");
      return "Invalid Duration";
    }
  }

  /// Filter data based on selected date
  List<Map<String, String>> _getFilteredData() {
    if (_selectedDate == null) {
      return _dataList;
    }
    return _dataList.where((data) {
      return data["date"] != null &&
          DateFormat('yyyy-MM-dd').format(DateTime.parse(data["date"]!)) ==
              _selectedDate;
    }).toList();
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 30) {
        final status = await Permission.manageExternalStorage.request();
        return status.isGranted;
      } else {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    return false;
  }

  Future<void> _downloadExcelFile() async {
    try {
      bool hasPermission = await _requestStoragePermission();
      if (hasPermission) {
        final xlsio.Workbook workbook = xlsio.Workbook();
        final xlsio.Worksheet sheet = workbook.worksheets[0];

        final List<String> headers = [
          'Date',
          'Location',
          'From Time - To Time',
          'Duration',
          'Remarks'
        ];
        for (int i = 0; i < headers.length; i++) {
          sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
        }

        for (int i = 0; i < _dataList.length; i++) {
          final data = _dataList[i];
          sheet.getRangeByIndex(i + 2, 1).setText(data["date"] ?? "");
          sheet.getRangeByIndex(i + 2, 2).setText(data["location"] ?? "");
          sheet.getRangeByIndex(i + 2, 3)
              .setText("${data["fromTime"] ?? ""} - ${data["toTime"] ?? ""}");
          sheet.getRangeByIndex(i + 2, 4)
              .setText(calculateDuration(data["fromTime"] ?? "", data["toTime"] ?? ""));
          sheet.getRangeByIndex(i + 2, 5).setText(data["remarks"] ?? "");
        }

        final List<int> bytes = workbook.saveAsStream();
        workbook.dispose();

        final directory = Directory('/storage/emulated/0/Download/TrackingReport');
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }
        final String path = '${directory.path}/TrackingReport.xlsx';
        final File file = File(path);
        await file.writeAsBytes(bytes);

        Get.snackbar(
          "Success",
          "File saved in Downloads folder: $path",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Permission Denied",
          "Storage permission is required to save the file.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to save file: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text("Tracking Reports",
            style: GoogleFonts.dmSans(
                textStyle: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white))),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _downloadExcelFile,
            icon: const Icon(Icons.download,color: Colors.white,),
          )
        ],
      ),
      body: _isDataLoaded
          ? Column(
        children: [
          _getFilteredData().isEmpty
              ? const Center(child: Text("No Data Available"))
              : Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text("Date",
                        style: GoogleFonts.dmSans(fontSize: 14.5.sp)),
                  ),
                  DataColumn(
                    label: Text("Location",
                        style: GoogleFonts.dmSans(fontSize: 14.5.sp)),
                  ),
                  DataColumn(
                    label: Text("From Time - To Time",
                        style: GoogleFonts.dmSans(fontSize: 14.5.sp)),
                  ),
                  DataColumn(
                    label: Text("Duration",
                        style: GoogleFonts.dmSans(fontSize: 14.5.sp)),
                  ),
                  DataColumn(
                    label: Text("Remarks",
                        style: GoogleFonts.dmSans(fontSize: 14.5.sp)),
                  ),
                  DataColumn(
                    label: Text("Action",
                        style: GoogleFonts.dmSans(fontSize: 14.5.sp)),
                  ),
                ],
                rows: _getFilteredData().map((data) {
                  return DataRow(cells: [
                    DataCell(Text(
                      DateFormat('dd-MM-yyyy')
                          .format(DateTime.parse(data["date"] ?? "")),
                      style: GoogleFonts.dmSans(fontSize: 12.sp),
                    )),
                    DataCell(Text(data["location"] ?? "",
                        style: GoogleFonts.dmSans(fontSize: 14.sp))),
                    DataCell(Text(
                      "${data["fromTime"] ?? ""} - ${data["toTime"] ?? ""}",
                      style: GoogleFonts.dmSans(fontSize: 14.sp),
                    )),
                    DataCell(Text(
                      calculateDuration(
                          data["fromTime"] ?? "", data["toTime"] ?? ""),
                      style: GoogleFonts.dmSans(fontSize: 14.sp),
                    )),
                    DataCell(Text(data["remarks"] ?? "",
                        style: GoogleFonts.dmSans(fontSize: 14.sp))),
                    DataCell(IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        setState(() {
                          _dataList.remove(data);
                        });
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        prefs.setString(
                            'trackingData', jsonEncode(_dataList));
                      },
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            onPressed: () => Get.offAll(const Dashboard()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Text(
                "Exit",
                style: TextStyle(fontSize: 14.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
