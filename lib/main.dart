import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kaghaze_souti/view/audio_player_models/audio_player_handler.dart';
import 'package:kaghaze_souti/view/pages/login_pages/login_page.dart';
import 'package:kaghaze_souti/view/pages/login_pages/password_recovery_page.dart';
import 'package:kaghaze_souti/view/pages/profile_page/cart_page.dart';
import 'package:kaghaze_souti/view/pages/profile_page/marked_page.dart';
import 'package:kaghaze_souti/view/pages/profile_page/purchase_history_page.dart';
import 'package:material_color_generator/material_color_generator.dart';

import '/view/view_models/player_bottom_navigation_bar.dart';
import 'controller/custom_response.dart';
import 'controller/custom_dio.dart';
import 'model/book_introduction.dart';
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



PlayerBottomNavigationBar playerBottomNavigationBar = const PlayerBottomNavigationBar();

late AudioPlayer demoPlayer;



late SharedPreferences sharedPreferences;

String defaultBanner = 'assets/images/defaultBanner.jpg';
String defaultBookCover = 'assets/images/defaultBookCover.jpg';
String appLogo = 'assets/images/appLogo.jpg';
String appLogoNet = 'https://kaghazsoti.com/img/logo.1e799436.jpeg';

late List<int> markedBooksId = [];
late List<int> libraryId = [];
late List<String> bookCartSlug = [];
late int userId;



int previousAudiobookInPlayId = -1;


int audiobookInPlayId = -1;
SharedValue<bool> audioIsPlaying = SharedValue(value: false);
late BookIntroduction audiobookInPlay;
late AudioPlayerHandler audioPlayerHandler;


SharedValue<bool> demoIsPlaying = SharedValue(value: false);
int demoInPlayId = -1;


Future<void> main() async {
  audioPlayerHandler = await AudioService.init(
    builder: () => AudioPlayerHandlerImplements(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
  );

  demoPlayer = AudioPlayer();


  runApp(
    SharedValue.wrapApp(
      const MyApp(),
    ),
  );
}
const String fontFamily = 'Vazir';


class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
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
              routes: {
                CartPage.routeName: (context) => const CartPage(),
                PurchaseHistoryPage.routeName: (context) => const PurchaseHistoryPage(),
              },
              theme: _theme(context),
              darkTheme: _darkTheme(context),
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

  ThemeData _theme(BuildContext context) {
    return ThemeData(
      fontFamily: fontFamily,
      primarySwatch: generateMaterialColor(color: _primaryColor),
      primaryColor: _primaryColor,
      scaffoldBackgroundColor: Colors.white,
      dividerColor: _primaryColor,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
        ),
      ),
      cardTheme: _cardTheme(),
      inputDecorationTheme: _inputDecorationTheme(),
      textSelectionTheme: _textSelectionTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(context),
      dividerTheme: _dividerTheme(),
    );
  }

  ThemeData _darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: fontFamily,
      primarySwatch: generateMaterialColor(color: _primaryColor),
      primaryColor: _primaryColor,
      scaffoldBackgroundColor: const Color(0xFF171E26),
      dividerColor: _primaryColor,
      accentColor: _primaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: fontFamily,
        ),
      ),
      cardTheme: _cardTheme(),
      inputDecorationTheme: _inputDecorationTheme(),
      textSelectionTheme: _textSelectionTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(context),
      dividerTheme: _dividerTheme(),
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

  OutlinedButtonThemeData _outlinedButtonTheme(BuildContext context) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(Theme.of(context)
            .textTheme
            .caption!
            .copyWith(fontFamily: fontFamily)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              18.0,
            ),
            side: BorderSide(
              color: _primaryColor,
            ),
          ),
        ),
        side: MaterialStateProperty.all(
          BorderSide(color: _primaryColor),
        ),
      ),
    );
  }

  DividerThemeData _dividerTheme() {
    return const DividerThemeData(thickness: 1.0);
  }
}

