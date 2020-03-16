import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {





  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }



  startTime() async {



    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }



  @override
  void initState() {
    super.initState();
    startTime();

  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(

        child: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage('imgs/logo.png'),),
              Image(image: AssetImage('imgs/news5.gif'),)
            ],
          ),

        ),


      ),
    );

  }


}

