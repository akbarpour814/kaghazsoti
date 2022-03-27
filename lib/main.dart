import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:takfood_seller/test.dart';
import 'package:takfood_seller/view/pages/login_pages/login_page.dart';
import 'package:takfood_seller/view/pages/login_pages/registration_page.dart';
import 'controller/custom_response.dart';
import 'controller/database.dart';
import 'controller/custom_dio.dart';
import 'view/pages/login_pages/splash_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_value/shared_value.dart';

import 'package:sizer/sizer.dart';

import 'model/book.dart';
import 'view/pages/library_page/library_page.dart';
import 'view/pages/category_page/category_page.dart';
import 'view/pages/home_page/home_page.dart';
import 'view/pages/search_page/search_page.dart';
import 'view/pages/profile_page/profile_page.dart';

SharedValue<bool> audioIsPlaying = SharedValue(value: false);
SharedValue<bool> demoIsPlaying = SharedValue(value: false);

AudioPlayer audioPlayer = AudioPlayer();

late Book audiobookInPlay;

late SharedPreferences sharedPreferences;

String defaultBanner = 'assets/images/InShot_۲۰۲۲۰۳۲۳_۱۴۳۱۱۲۶۲۴.jpg';
String defaultBookCover = 'assets/images/defaultBookCover.jpg';

late List<int> markedBooksId = [];

void main() async {
  Response<dynamic> httpsResponse = await CustomDio.dio.get('dashboard/users/wish');
  CustomResponse customResponse = CustomResponse.fromJson(httpsResponse.data);

  for(Map<String, dynamic> book in customResponse.data['data']) {
    markedBooksId.add(book['id']);
  }

  runApp(
    SharedValue.wrapApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
  final MaterialColor _primarySwatch = const MaterialColor(
    0xFF005C6B,
    {
      50: Color(0xFFD9E2E4),
      100: Color(0xFFC2D4D7),
      200: Color(0xFFA9C5C9),
      300: Color(0xFF91B6BC),
      400: Color(0xFF79A7AF),
      500: Color(0xFF6198A1),
      600: Color(0xFF488993),
      700: Color(0xFF307A86),
      800: Color(0xFF186B79),
      900: Color(0xFF005C6B),
    },
  );
  final Color _primaryColor = const Color(0xFF005C6B);

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (_, ThemeMode currentMode, __) {
            return MaterialApp(
              title: 'Kaghaze souti',
              debugShowCheckedModeBanner: false,
              theme: _theme(),
              darkTheme: _darkTheme(),
              themeMode: currentMode,
              builder: (context, child) => Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              ),
              home: const SplashPage(),
            );
          },
        );
      },
    );
  }

  ThemeData _theme() {
    return ThemeData(
        fontFamily: 'Vazir',
        primarySwatch: generateMaterialColor(color: _primaryColor),
        primaryColor: _primaryColor,
        scaffoldBackgroundColor: Colors.white,
        dividerColor: _primaryColor,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Vazir',
          ),
        ),
        cardTheme: _cardTheme(),
        floatingActionButtonTheme: _floatingActionButtonTheme(),
        inputDecorationTheme: _inputDecorationTheme(),
        textSelectionTheme: _textSelectionTheme(),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Vazir',
      primarySwatch: generateMaterialColor(color: _primaryColor),
      primaryColor: _primaryColor,
      scaffoldBackgroundColor: Colors.black,
      dividerColor: _primaryColor,
      accentColor: _primaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'Vazir',
        ),
      ),
      cardTheme: _cardTheme(),
      floatingActionButtonTheme: _floatingActionButtonTheme(),
      inputDecorationTheme: _inputDecorationTheme(),
      textSelectionTheme: _textSelectionTheme(),
    );
  }

  CardTheme _cardTheme() {
    return const CardTheme(
      shape: Border(
        bottom: BorderSide(
          color: Colors.grey,
          width: 0.4,
        ),
      ),
    );
  }

  FloatingActionButtonThemeData _floatingActionButtonTheme() {
    return FloatingActionButtonThemeData(
      backgroundColor: _primaryColor,
    );
  }

  InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      helperStyle: TextStyle(color: _primaryColor),
      suffixIconColor: _primaryColor,
      focusColor: _primaryColor.withOpacity(0.6),
      border: _underlineInputBorder(),
      focusedBorder: _underlineInputBorder(),
      disabledBorder: _underlineInputBorder(),
      enabledBorder: _underlineInputBorder(),
      errorBorder: _underlineInputBorder(),
      focusedErrorBorder: _underlineInputBorder(),
    );
  }

  UnderlineInputBorder _underlineInputBorder() {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: _primaryColor,
      ),
    );
  }

  TextSelectionThemeData _textSelectionTheme() {
    return TextSelectionThemeData(
      cursorColor: _primaryColor,
      selectionColor: _primaryColor.withOpacity(0.6),
      selectionHandleColor: _primaryColor,
    );
  }
}