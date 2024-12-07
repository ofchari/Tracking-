import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_id/view/screens/dashboard.dart';

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
      backgroundColor: Colors.blue,
      body: SizedBox(
        width: width.w,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/login.png"),
              SizedBox(height: 10.h),
              Padding(
                padding:  const EdgeInsets.only(right: 180.0),
                child: Text("Login Now",style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w500,color: Colors.yellow)),),
              ),
              SizedBox(height: 30.h,),
              SizedBox(
                height: 60.h,
                width: 370.w,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                    controller: _usernameController,
                    style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.white)),
                    decoration: InputDecoration(
                      labelText: "   Username",
                      labelStyle: GoogleFonts.sora(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 20,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white
                        ),
                        borderRadius: BorderRadius.circular(23)
                      )
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              SizedBox(
                height: 60.h,
                width: 370.w,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.white)),
                    decoration: InputDecoration(
                      labelText: "   Password",
                      labelStyle: GoogleFonts.sora(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(23)
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.black,
                        size: 20,
                      ),
                      // border: OutlineInputBorder(
                      //   borderSide: BorderSide(
                      //     color: Colors.white
                      //   ),
                      //   borderRadius: BorderRadius.circular(23),
                      // ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _handleLogin,
                child: Container(
                  height: 40.h,
                  width: 270.w,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(27),
                  ),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: GoogleFonts.sora(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
