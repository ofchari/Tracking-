import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Subhead extends StatefulWidget {
  const Subhead({super.key,required this.text,required this.weight});
  final String text;
  final FontWeight weight;

  @override
  State<Subhead> createState() => _SubheadState();
}

class _SubheadState extends State<Subhead> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.text,style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 17.5.sp,fontWeight: FontWeight.w500)),);
  }
}