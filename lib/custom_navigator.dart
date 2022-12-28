
import 'package:flutter/cupertino.dart';

class CustomNavigator {
  static Future<void> push({
    required BuildContext context,
    required Widget page,
  }) async {
    //await Get.to(page, transition: Transition.rightToLeft);
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (BuildContext context) => page,
      ),
    );
  }

  static void pop({
    required BuildContext context,
  }) {
    //Get.back();
    Navigator.pop(context);
  }
}