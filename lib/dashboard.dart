import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_id/tracking_data.dart';
import 'package:tracking_id/tracking_report.dart';

import 'login.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late double height;
  late double width;

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(() => const Login());
  }

  @override
  Widget build(BuildContext context) {
    /// Define sizes //
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      height = constraints.maxHeight;
      width = constraints.maxWidth;
      if (width <= 450) {
        return _smallBuildLayout();
      } else {
        return const Text("Please make sure Your device is in portrait view");
      }
    },);
  }
  Widget _smallBuildLayout(){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: GoogleFonts.dmSans(
              textStyle: TextStyle(
                  fontSize: 17.sp, fontWeight: FontWeight.w500, color: Colors.white)),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: (){
              _logout();
            },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.logout,color: Colors.white,size: 20,),
              ))
        ],
      ),
      body: SizedBox(
        width: width.w,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Image.asset("assets/dashboard.png"),
              SizedBox(
                height: 10.h,
              ),
              GestureDetector(
                onTap: (){
                  Get.to(const TrackingData());
                },
                child: Container(
                  height: height/8.h,
                  width: width/1.3.w,
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0,left: 74.0,right: 60.0),
                        child: Row(
                          children: [
                            const Icon(Icons.follow_the_signs,color: Colors.white,),
                            SizedBox(width: 10.w,),
                            Text("Tracking ",style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.white)),)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h,),
              GestureDetector(
                onTap: (){
                  Get.to(const TrackingReport());
                },
                child: Container(
                  height: height/8.h,
                  width: width/1.3.w,
                  decoration: BoxDecoration(
                      color: Colors.brown.shade400,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0,left: 74.4,right: 60.0),
                        child: Row(
                          children: [
                            const Icon(Icons.note_alt_sharp,color: Colors.white,),
                            SizedBox(width: 10.w,),
                            Text(" Reports",style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.white)),)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
          
            ],
          ),
        ),
      ),
    );
  }
}
