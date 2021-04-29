import 'package:seedlingai/home.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: Home(),
      title: Text(
        'Seedling AI',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Color(0xFF415301),
        ),
      ),
      image: Image.asset('assets/logo.png'),
      backgroundColor: Colors.white,
      photoSize: 60.0,
      loaderColor: Colors.white,
    );
  }
}
