import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:tracking_id/tracking_report.dart';

class TrackingData extends StatefulWidget {
  const TrackingData({super.key});

  @override
  State<TrackingData> createState() => _TrackingDataState();
}

class _TrackingDataState extends State<TrackingData> {
  late double height;
  late double width;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        if (width <= 450) {
          return _smallBuildLayout();
        } else {
          return const Text("Please make sure Your device is in portrait view");
        }
      },
    );
  }

  Widget _smallBuildLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tracking Id",
          style: GoogleFonts.dmSans(
            textStyle: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SizedBox(
        width: width.w,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              _buildTextField("   Date", Icons.calendar_month_outlined, _dateController, isReadOnly: true, onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                }
              }),
              SizedBox(height: 20.h),
              _buildTextField("   Location", Icons.location_on_outlined, _locationController),
              SizedBox(height: 20.h),
              _buildTextField("   From Time", Icons.alarm, _fromTimeController, isReadOnly: true, onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                if (pickedTime != null) {
                  _fromTimeController.text = pickedTime.format(context);
                }
              }),
              SizedBox(height: 20.h),
              _buildTextField("   To Time", Icons.alarm, _toTimeController, isReadOnly: true, onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                if (pickedTime != null) {
                  _toTimeController.text = pickedTime.format(context);
                }
              }),
              SizedBox(height: 20.h),
              _buildTextField("   Remarks", Icons.mark_chat_read, _remarksController),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () async {
                  var newData = {
                    "date": _dateController.text,
                    "location": _locationController.text,
                    "fromTime": _fromTimeController.text,
                    "toTime": _toTimeController.text,
                    "remarks": _remarksController.text,
                  };

                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String? storedData = prefs.getString('trackingData');
                  List<dynamic> dataList = storedData != null ? jsonDecode(storedData) : [];

                  dataList.add(newData);

                  prefs.setString('trackingData', jsonEncode(dataList));

                  Get.offAll(() => const TrackingReport());
                },
                child: Container(
                  height: 45.h,
                  width: 250.w,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text('Submit', style: GoogleFonts.sora(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller,
      {bool isReadOnly = false, void Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        readOnly: isReadOnly,
        onTap: onTap,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.dmSans(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          prefixIcon: Icon(icon, color: Colors.black, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
