import 'package:flutter/material.dart';
import 'package:kaghazsoti/pages/login_screen.dart';
import 'package:kaghazsoti/pages/splash_screen.dart';
import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "کاغذ صوتی",
      debugShowCheckedModeBanner: false,
      initialRoute: "/splash_screen",
      routes: {
        "/" : (context) => Directionality(textDirection: TextDirection.rtl,child: MyHomePage(),),
        "/login" : (context) => Directionality(textDirection: TextDirection.rtl, child: LoginScreen()),
        "/splash_screen" : (context) => Directionality(textDirection: TextDirection.rtl, child: SplashScreen()),
      },
      theme: ThemeData(
          fontFamily: "Vazir",
          primaryColor: Colors.black,
          primaryIconTheme: IconThemeData(color: Colors.black),
          primaryTextTheme: TextTheme(subtitle1: TextStyle(color: Colors.black))
      ),
    );
    throw UnimplementedError();
  }
}
