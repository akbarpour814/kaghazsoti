import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin SendVerificationCode<T extends StatefulWidget> on State<T> {
  late TextEditingController codeController;
  String? codeError;
  late int numberOfSend;
  late bool sendCode;
  late Timer timer;
  late Duration duration;

  @override
  void initState() {
    super.initState();

    codeController = TextEditingController();
    numberOfSend = 0;
    sendCode = true;
    duration = Duration(seconds: 0);
  }
}