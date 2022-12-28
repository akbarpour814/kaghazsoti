
import 'package:flutter/material.dart';
import 'package:kaz_reader/core/constants/colors.dart';
import 'package:kaz_reader/themes/common_theme.dart';

class DarkTheme {
  static ThemeData darkTheme(BuildContext context) {
    return CommonTheme.commonTheme(context).copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: BaseColors.darkBackgroundColor,
      accentColor: BaseColors.accentColor,
      appBarTheme: CommonTheme.commonTheme(context).appBarTheme.copyWith(
            backgroundColor: BaseColors.darkBackgroundAppBarColor,
          ),
      canvasColor: BaseColors.darkCanvasColor,
    );
  }
}
