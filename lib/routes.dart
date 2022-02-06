import 'package:flutter/material.dart';
import 'package:kaghazsoti/pages/login_screen.dart';
import 'package:kaghazsoti/pages/search.dart';
import 'package:kaghazsoti/pages/splash_screen.dart';
import 'home_page.dart';

Map<String, Widget Function(BuildContext)> routes() {
  return {
    "/" : (context) => MyHomePage(),
    "/login" : (context) => LoginScreen(),
    "/splash_screen" : (context) => SplashScreen(),
    "/search": (context) => Search()
  };
}
