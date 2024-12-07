import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Ensure intl package is imported
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';

class TrackingReport extends StatefulWidget {
  const TrackingReport({super.key});

  @override
  State<TrackingReport> createState() => _TrackingReportState();
}

class _TrackingReportState extends State<TrackingReport> {
  late List<Map<String, String>> _dataList;
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
        _isDataLoaded = true; // No data found, still mark as loaded
      });
    }
  }

  /// Parse and calculate duration between two times
  String sanitizeTime(String input) {
    return input
        .replaceAll(RegExp(r'[^\x20-\x7E]'), '') // Remove non-ASCII characters
        .replaceAll(RegExp(r'\s+'), ' ') // Replace multiple spaces with a single space
        .trim(); // Trim leading and trailing whitespace

  }


  String calculateDuration(String fromTime, String toTime) {
    try {
      // Sanitize the time inputs
      String sanitizedFrom = sanitizeTime(fromTime);
      String sanitizedTo = sanitizeTime(toTime);

      // Split the sanitized time strings into hours and minutes
      List<String> fromParts = sanitizedFrom.split(':');
      List<String> toParts = sanitizedTo.split(':');

      // Extract hours and minutes
      int fromHours = int.parse(fromParts[0].trim());
      int fromMinutes = int.parse(fromParts[1].substring(0, 2).trim());
      bool fromIsPM = sanitizedFrom.toLowerCase().contains('pm');
      if (fromIsPM && fromHours != 12) fromHours += 12; // Convert PM hours
      if (!fromIsPM && fromHours == 12) fromHours = 0; // Convert 12 AM to 0

      int toHours = int.parse(toParts[0].trim());
      int toMinutes = int.parse(toParts[1].substring(0, 2).trim());
      bool toIsPM = sanitizedTo.toLowerCase().contains('pm');
      if (toIsPM && toHours != 12) toHours += 12; // Convert PM hours
      if (!toIsPM && toHours == 12) toHours = 0; // Convert 12 AM to 0

      // Convert everything to minutes since midnight
      int fromTotalMinutes = fromHours * 60 + fromMinutes;
      int toTotalMinutes = toHours * 60 + toMinutes;


      // Handle crossover at midnight
      if (toTotalMinutes < fromTotalMinutes) {
        toTotalMinutes += 24 * 60;
      }

      // Calculate duration
      int durationMinutes = toTotalMinutes - fromTotalMinutes;
      int hours = durationMinutes ~/ 60;
      int minutes = durationMinutes % 60;

      return "${hours}h ${minutes}m";
    } catch (e) {
      print("Error calculating duration manually: $e");
      return "Invalid Duration";
    }
  }


  /// Filter data based on selected date
  List<Map<String, String>> _getFilteredData() {
    if (_selectedDate == null) {
      return _dataList;
    }
    return _dataList
        .where((data) =>
    data["date"] != null &&
        DateFormat('yyyy-MM-dd').format(DateTime.parse(data["date"]!)) == _selectedDate)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
            child: const Icon(Icons.arrow_back,color: Colors.white,)),
        title: Text("Tracking Reports",
            style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500, color: Colors.white))),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _isDataLoaded
              ? Column(
            children: [
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text(
                  //   "Filter by Date:",
                  //   style: GoogleFonts.dmSans(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  // ),
                  SizedBox(width: 10.w),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      _selectedDate == null ? "Filter Date" : "Filter Date",
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              _getFilteredData().isEmpty
                  ? const Center(child: Text("No Data Available"))
                  : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text("Date", style: GoogleFonts.dmSans(fontSize: 14.5.sp))),
                    DataColumn(label: Text("Location", style: GoogleFonts.dmSans(fontSize: 14.5.sp))),
                    DataColumn(label: Text("From Time - To Time", style: GoogleFonts.dmSans(fontSize: 14.5.sp))),
                    DataColumn(label: Text("Duration", style: GoogleFonts.dmSans(fontSize: 14.5.sp))),
                    DataColumn(label: Text("Remarks", style: GoogleFonts.dmSans(fontSize: 14.5.sp))),
                    DataColumn(label: Text("Action", style: GoogleFonts.dmSans(fontSize: 14.5.sp))),
                  ],
                  rows: _getFilteredData().map((data) {
                    return DataRow(cells: [
                      DataCell(Text(
                        DateFormat('dd-MM-yyyy').format(DateTime.parse(data["date"] ?? "")),
                        style: GoogleFonts.dmSans(fontSize: 12.sp),
                      )),
                      DataCell(Text(data["location"] ?? "", style: GoogleFonts.dmSans(fontSize: 14.sp))),
                      DataCell(Text("${data["fromTime"] ?? ""} - ${data["toTime"] ?? ""}", style: GoogleFonts.dmSans(fontSize: 14.sp))),
                      DataCell(Text(
                        calculateDuration(data["fromTime"] ?? "", data["toTime"] ?? ""),
                        style: GoogleFonts.dmSans(fontSize: 14.sp),
                      )),
                      DataCell(Text(data["remarks"] ?? "", style: GoogleFonts.dmSans(fontSize: 14.sp))),
                      DataCell(IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          setState(() {
                            _dataList.remove(data);
                          });
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('trackingData', jsonEncode(_dataList));
                        },
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          )
              : const Center(child: CircularProgressIndicator()),
          SizedBox(height: 10.h),
          ElevatedButton(
            onPressed: () {
              // Navigate back to the Dashboard screen
              Get.offAll(const Dashboard());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Text(
                "Exit",
                style: TextStyle(fontSize: 14.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
