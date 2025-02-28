import 'package:chapanotify/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String textToDisplay = '';
  String fullText = 'Chapa Notify';
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _animatedText();
  }

  void _animatedText() {
    Future.delayed(Duration(microseconds: 50000), () async {
      if (currentIndex < fullText.length) {
        setState(() {
          textToDisplay += fullText[currentIndex];
          currentIndex++;
        });
        _animatedText();
      } else {
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff7DC400),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset('assets/notification.json'),
            SizedBox(height: 10.h),
            Text(
              textToDisplay,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
