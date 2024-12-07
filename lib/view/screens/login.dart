import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_id/view/screens/dashboard.dart';
import 'package:tracking_id/view/widgets/heading.dart';
import 'package:tracking_id/view/widgets/text.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late double height;
  late double width;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  /// Check if the user is already logged in
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      Get.offAll(() => const Dashboard());
    }
  }

  /// Handle login validation
  Future<void> _handleLogin() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username == 'admin' && password == 'abc@123') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      Get.offAll(() => const Dashboard());
    } else {
      Get.snackbar(
        "Error",
        "Invalid username or password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Define sizes //
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
      // backgroundColor: Colors.blue,
      body: SizedBox(
        width: width.w,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 70.h,),
              Container(
                height: height/3.h,
                width: width/1.7.w,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/lock1.png"),fit: BoxFit.cover)
                ),
              ),
              SizedBox(height: 30.h,),
              const Heading(text: "Welcome Back!!", weight: FontWeight.w600, color: Colors.black,),
              SizedBox(height: 6.5.h),
              const MyText(text: "Enter Your details to access your account", weight: FontWeight.w500, color: Colors.grey,),
              SizedBox(height: 30.h,),
              Container(
                height: height/12.h,
                width: width/1.09.w,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6.r)
                ),
                child: TextFormField(
                  controller: _usernameController,
                        style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.black)),
                        decoration: InputDecoration(
                          labelText: "   Username",
                          labelStyle: GoogleFonts.sora(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.black,
                            size: 20,
                          ),
                          border: InputBorder.none
                        ),
                      ),
                ),
              SizedBox(height: 17.h,),
              Container(
                height: height/12.h,
                width: width/1.09.w,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6.r)
                ),
                child: TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.black)),
                  decoration: InputDecoration(
                      labelText: "   Password",
                      labelStyle: GoogleFonts.sora(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_open,
                        color: Colors.black,
                        size: 20,
                      ),
                      border: InputBorder.none
                  ),
                ),
              ),
              SizedBox(height: 26.h,),
              GestureDetector(
                onTap: _handleLogin,
                child: Container(
                  height: 40.h,
                  width: 200.w,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      'Login',
                      style: GoogleFonts.sora(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // SizedBox(
              //   height: 60.h,
              //   width: 370.w,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              //     child: TextFormField(
              //       controller: _usernameController,
              //       style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.white)),
              //       decoration: InputDecoration(
              //         labelText: "   Username",
              //         labelStyle: GoogleFonts.sora(
              //           fontSize: 13.sp,
              //           fontWeight: FontWeight.w500,
              //           color: Colors.black,
              //         ),
              //         prefixIcon: const Icon(
              //           Icons.person,
              //           color: Colors.black,
              //           size: 20,
              //         ),
              //         enabledBorder: OutlineInputBorder(
              //           borderSide: const BorderSide(
              //             color: Colors.black
              //           ),
              //           borderRadius: BorderRadius.circular(23)
              //         )
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 15.h),
              // SizedBox(
              //   height: 60.h,
              //   width: 370.w,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              //     child: TextFormField(
              //       controller: _passwordController,
              //       obscureText: true,
              //       style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.white)),
              //       decoration: InputDecoration(
              //         labelText: "   Password",
              //         labelStyle: GoogleFonts.sora(
              //           fontSize: 13.sp,
              //           fontWeight: FontWeight.w500,
              //           color: Colors.black,
              //         ),
              //         enabledBorder: OutlineInputBorder(
              //           borderSide: const BorderSide(
              //             color: Colors.black,
              //           ),
              //           borderRadius: BorderRadius.circular(23)
              //         ),
              //         prefixIcon: const Icon(
              //           Icons.lock,
              //           color: Colors.black,
              //           size: 20,
              //         ),
              //         // border: OutlineInputBorder(
              //         //   borderSide: BorderSide(
              //         //     color: Colors.white
              //         //   ),
              //         //   borderRadius: BorderRadius.circular(23),
              //         // ),
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 20),
              // GestureDetector(
              //   onTap: _handleLogin,
              //   child: Container(
              //     height: 40.h,
              //     width: 270.w,
              //     decoration: BoxDecoration(
              //       color: Colors.blueAccent,
              //       borderRadius: BorderRadius.circular(27),
              //     ),
              //     child: Center(
              //       child: Text(
              //         'Submit',
              //         style: GoogleFonts.sora(
              //           fontSize: 13.sp,
              //           fontWeight: FontWeight.w500,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
