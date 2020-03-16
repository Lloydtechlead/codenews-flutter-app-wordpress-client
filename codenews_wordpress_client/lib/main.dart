
import 'package:codenewswordpressclient/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:codenewswordpressclient/pages/home.dart';


void main() {




  runApp(


    new  MaterialApp(

      debugShowCheckedModeBanner: false,

      title: "CodeNews",

      theme: ThemeData(fontFamily: 'Kufi',),

      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/HomeScreen': (BuildContext context) => new MyApp( )
      },
    ),


  )
  ;


}


