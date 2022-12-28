import 'package:flutter/material.dart';

class Config {
  late String title;
  late IconData icon;
  late String route;
  late Widget page;
  late GlobalKey<NavigatorState> globalKey;

  Config() {
    globalKey = GlobalKey<NavigatorState>();
  }
}
