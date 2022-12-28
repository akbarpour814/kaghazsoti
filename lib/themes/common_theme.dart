

import 'package:flutter/material.dart';
import 'package:material_color_generator/material_color_generator.dart';

import '../core/constants/colors.dart';

class CommonTheme {
  static const fontFamily = 'Vazir'/*FontFamily.vazir*/;

  static ThemeData commonTheme(BuildContext context) {
    return ThemeData(
      fontFamily: fontFamily,
      primarySwatch: generateMaterialColor(color: BaseColors.primaryColor),
      primaryColor: BaseColors.primaryColor,
      dividerColor: BaseColors.primaryColor,
      inputDecorationTheme: _inputDecorationTheme(),
      appBarTheme: const AppBarTheme(
        toolbarHeight: 56.0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
        ),
      ),
      cardTheme: _cardTheme(),
      listTileTheme: _listTileTheme(),
      textSelectionTheme: _textSelectionTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(context),
      dividerTheme: _dividerTheme(),




      // textTheme:
      // Theme.of(context).textTheme.apply(
      //   fontFamily: FontFamily.vazir,
      //   displayColor:  BaseColors.white,
      //   bodyColor:  BaseColors.white,
      // ),
    );
  }

  static CardTheme _cardTheme() {
    return const CardTheme(
      color: Colors.transparent,
      elevation: 0.0,
      margin: EdgeInsets.zero,
      shape: Border(
        bottom: BorderSide(
          color: BaseColors.cardBorderColor,
          width: 0.4,
        ),
      ),
    );
  }

  static ListTileThemeData _listTileTheme() {
    return const ListTileThemeData(
      iconColor: BaseColors.iconColor,
    );
  }

  static InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      helperStyle: const TextStyle(color: BaseColors.primaryColor),
      suffixIconColor: BaseColors.primaryColor,
      focusColor: BaseColors.focusColor,
      border: _underlineInputBorder(),
      focusedBorder: _underlineInputBorder(),
      disabledBorder: _underlineInputBorder(),
      enabledBorder: _underlineInputBorder(),
      errorBorder: _underlineInputBorder(),
      focusedErrorBorder: _underlineInputBorder(),
    );
  }

  static UnderlineInputBorder _underlineInputBorder() {
    return const UnderlineInputBorder(
      borderSide: BorderSide(
        color: BaseColors.primaryColor,
      ),
    );
  }

  static TextSelectionThemeData _textSelectionTheme() {
    return TextSelectionThemeData(
      cursorColor: BaseColors.primaryColor,
      selectionColor: BaseColors.selectionColor,
      selectionHandleColor: BaseColors.primaryColor,
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(BuildContext context) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          Theme.of(context).textTheme.caption!.copyWith(fontFamily: fontFamily),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              18.0,
            ),
            side: const BorderSide(
              color: BaseColors.primaryColor,
            ),
          ),
        ),
        side: MaterialStateProperty.all(
          const BorderSide(color: BaseColors.primaryColor),
        ),
      ),
    );
  }

  static DividerThemeData _dividerTheme() {
    return const DividerThemeData(thickness: 1.0);
  }
}
