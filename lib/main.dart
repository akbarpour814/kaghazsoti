import 'package:flutter/material.dart';
import 'package:kaghazsoti/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "کاغذ صوتی",
      debugShowCheckedModeBanner: false,
      initialRoute: "/splash_screen",
      routes: routes(),
      builder: (context, widget) => Directionality(
        textDirection: TextDirection.rtl,
        child: widget as Widget,
      ),
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
