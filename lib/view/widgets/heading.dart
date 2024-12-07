import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Heading extends StatefulWidget {
  const Heading({super.key,required this.text,required this.weight});
  final String text;
  final FontWeight weight;

  @override
  State<Heading> createState() => _HeadingState();
}

class _HeadingState extends State<Heading> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.text,style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 20.5.sp,fontWeight: FontWeight.w500)),);
  }
}
