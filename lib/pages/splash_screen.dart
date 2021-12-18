import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  startTime() {
    var _duration = Duration(seconds: 2);
    return Timer(_duration , navigationPage );
  }

  navigationPage() {
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xff075E54),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 125,
                height : 125,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/whatsapp_start_icon.png")
                  )
                ),

              ),
              Text("واتساپ" , style: TextStyle(fontSize: 20 , color : Colors.white , fontWeight: FontWeight.bold))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CircularProgressIndicator(),
            ),
          )
        ],
      )
    );
  }
}