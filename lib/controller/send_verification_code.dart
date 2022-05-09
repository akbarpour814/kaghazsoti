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
    duration = Duration(seconds: 59);
  }

  void startTimer() {
    timer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => timer.cancel());
  }

  void setCountDown() {
    final int reduceSecondsBy = 1;

    setState(() {
      final int seconds = duration.inSeconds - reduceSecondsBy;

      if (seconds < 0) {
        timer.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  String remainder() {
    return duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  }
}