import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './pages/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/sp.png"),
          Text(
            '\nCovid Tracker App',
            style: TextStyle(
              color: Color.fromRGBO(39, 105, 171, 1),
              fontSize: MediaQuery.of(context).size.width / 12,
              decoration: TextDecoration.none,
              fontFamily: 'Nunito',
            ),
          ),
          Text(
            '\n\n\n\n\n\n\nVIT Pune',
            style: TextStyle(
              color: Color.fromRGBO(39, 105, 171, 1),
              fontSize: MediaQuery.of(context).size.width / 20,
              decoration: TextDecoration.none,
              fontFamily: 'Nunito',
            ),
          ),
        ],
      ),
    );
  }
}
