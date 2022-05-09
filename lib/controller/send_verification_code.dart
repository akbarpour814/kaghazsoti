import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaghaze_souti/view/pages/login_pages/splash_page.dart';
import 'package:sizer/sizer.dart';

import '../view/view_models/custom_snack_bar.dart';

mixin SendVerificationCode<T extends StatefulWidget> on State<T> {
  late TextEditingController codeController;
  String? codeError;
  late int numberOfSend;
  late bool sendCode;
  late Timer timer;
  late Duration duration;
  late bool resendCodePermission;

  @override
  void initState() {
    super.initState();

    codeController = TextEditingController();
    numberOfSend = 0;
    sendCode = true;
    duration = Duration(seconds: 59);
    resendCodePermission = false;
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

        numberOfSend++;

        sendCode = true;

        if((numberOfSend >= 1) && (numberOfSend < 5)) {
          resendCodePermission = true;
        } else {
          resendCodePermission = false;

          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              Ionicons.refresh_outline,
              'بعد از اجرای دوباره برنامه امتحان کنید.',
              3,
            ),
          );

          Future.delayed(const Duration(seconds: 4), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const SplashPage(),
              ),
            );
          });
        }
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  String remainder() {
    return duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  }

  Visibility codeTextField() {
    return Visibility(
      visible: !sendCode,
      child: Padding(
        padding: EdgeInsets.only(bottom: 0.5.h),
        child: TextField(
          controller: codeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            helperText: '${remainder()} ثانیه تا دریافت مجدد کد',
            hintText: 'لطفاً کد تأیید را وارد کنید.',
            errorText: codeError,
            suffixIcon: Icon(Ionicons.code_working_outline),
          ),
        ),
      ),
    );
  }

  Visibility resendCodeButton(String phoneNumber) {
    return Visibility(
      visible: resendCodePermission && sendCode && (numberOfSend < 5),
      child: Padding(
        padding: EdgeInsets.only(top: 5.0.h),
        child: Center(
          child: SizedBox(
            width: 100.0.w - (2 * 5.0.w),
            child: ElevatedButton.icon(
              onPressed: () {
                resendCode(phoneNumber);
              },
              label: const Text('دریافت مجدد کد تأیید'),
              icon: const Icon(Ionicons.checkmark_outline),
            ),
          ),
        ),
      ),
    );
  }

  void resendCode(String phoneNumber) async {
    Response<dynamic> customDio = await Dio().post(
      'https://kaghazsoti.uage.ir/api/register/resend',
      data: {'mobile': phoneNumber},
    );

    if (customDio.statusCode == 200) {
      print(customDio.data);
      setState(() {
        sendCode = false;

        resetTimer();
        startTimer();
      });
    }
  }

  void resetTimer() {
    stopTimer();

    setState(() => duration = Duration(seconds: 59));
  }

}