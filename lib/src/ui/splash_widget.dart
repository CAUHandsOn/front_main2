import 'dart:async';

import 'package:flutter/material.dart';
import 'package:handson/src/ui/home.dart';

class SplashWidget extends StatefulWidget {
  SplashWidget({Key? key}) : super(key: key);

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), () {
      print("timer called");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
    });
    Timer(const Duration(milliseconds: 300),(){
      setState(() {
        _visible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const String imageLogoName = 'assets/images/CAU_emblem.png';
    return Scaffold(

      body: Container(
        child: Padding(
          padding: EdgeInsets.all(60),
          child: Image.asset(imageLogoName),
        ),
      )
    );
  }
}
