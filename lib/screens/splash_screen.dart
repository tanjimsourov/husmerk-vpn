import 'dart:async';
import 'package:flutter/material.dart';

import 'home_screen.dart';


class mySplashScreen extends StatefulWidget {
  const mySplashScreen({Key? key}) : super(key: key);

  @override
  _mySplashScreenState createState() => _mySplashScreenState();
}

class _mySplashScreenState extends State<mySplashScreen> {
  bool exit = false ;

  startTimer(){
    Timer(const Duration(seconds: 3), ()async{
      Navigator.push(context, MaterialPageRoute(builder: (c)=>HomeScreen()));
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Material(
      child: Container(
        color: Colors.grey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/logo.png",
                  width: screenWidth * .5,
                  height: screenHeight* .5,
                  fit:BoxFit.fill ),
            ],



          ),

        ),
      ),

    );
  }
}
