

import 'package:flutter/material.dart';

import '../core/constants/colors.dart';
import 'common_theme.dart';

class LightTheme {
  static ThemeData lightTheme(BuildContext context) {
    return CommonTheme.commonTheme(context).copyWith(
      scaffoldBackgroundColor: BaseColors.lightBackgroundColor,
      canvasColor: BaseColors.lightCanvasColor,
    );
  }
}