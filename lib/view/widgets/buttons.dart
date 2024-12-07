import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracking_id/main.dart';

class Buttons extends StatefulWidget {
  const Buttons({super.key,required this.height,required this.width,required this.color,required this.radius,required this.text});
  final String text;
  final double height;
  final double width;
  final Color color;
  final BorderRadius radius;

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height.h,
      width: widget.width.w,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: widget.radius
      ),
      child: Text(widget.text,style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Colors.white)),),
    );
  }
}
