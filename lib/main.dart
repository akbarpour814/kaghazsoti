import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


//------/dart and flutter packages
import 'package:flutter/material.dart';

//------/packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kaz_reader/themes/dark_theme.dart';
import 'package:kaz_reader/themes/light_theme.dart';
import 'package:kaz_reader/widgets/persistent_bottom_navigation_bar.dart';
export 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_value/shared_value.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

//------/model
import 'widgets/book_introduction/book_introduction_model.dart';

//------/view/audio_player_models
import 'pages/audiobook/audio_player_handler.dart';

//------/view/pages/library_page
import 'pages/library/library_page.dart';

//------/view/pages/login_pages
import 'pages/splash/splash_page.dart';

//------/view/pages/profile_page
import 'pages/cart/cart_page.dart';
import 'pages/purchase_history/purchase_history_page.dart';

//------/view/view_models
import '/widgets/player_bottom_navigation_bar.dart';
import 'initial_binding.dart';

//-----/global variables
String domain = 'https://kaghazsoti.com/api/';
String storage = 'https://kaghazsoti.com/storage/';
String defaultBanner = 'assets/images/defaultBanner.jpg';
String defaultBookCover = 'assets/images/appLogoForOutApp.png';
String appLogo = 'assets/images/appLogo.jpg';
String appLogoNet = 'https://kaghazsoti.com/img/logo.1e799436.jpeg';
const String fontFamily = 'Vazir';

late SharedPreferences sharedPreferences;
late int resendSms;
late String androidLink;
late String iosLink;
late int userId;
late List<int> libraryId = [];
late List<int> markedBooksId = [];
late List<String> bookCartSlug = [];

PlayerBottomNavigationBar playerBottomNavigationBar =
    const PlayerBottomNavigationBar();

late AudioPlayerHandler audioPlayerHandler;
late AudioPlayer demoPlayer;

int audiobookInPlayId = -1;
int previousAudiobookInPlayId = -1;
SharedValue<bool> audiobookIsPlaying = SharedValue(value: false);
late BookIntroductionModel audiobookInPlay;

int demoInPlayId = -1;
SharedValue<bool> demoOfBookIsPlaying = SharedValue(value: false);

Future<void> main() async {
  // audioPlayerHandler = await AudioService.init(
  //   builder: () => AudioPlayerHandlerImplements(),
  //   config: const AudioServiceConfig(
  //     androidNotificationChannelId: 'com.KazReader.kaz_reader',
  //     androidNotificationChannelName: 'Kaz Reader',
  //     androidNotificationOngoing: true,
  //   ),
  // );

  demoPlayer = AudioPlayer();

  runApp(
    SharedValue.wrapApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  const MyApp({Key? key}) : super(key: key);

  final Color _primaryColor = const Color(0xFF005C6B);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411.0, 866.0),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, widget) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (BuildContext context, value, Widget? child) {
            return GetMaterialApp(
              textDirection: TextDirection.rtl,
              initialBinding: InitialBinding(),

              title: 'Kaghaze souti',
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                Locale('fa', 'IR'),
              ],
              debugShowCheckedModeBanner: false,
              // theme: LightTheme.lightTheme(context),
              // darkTheme: DarkTheme.darkTheme(context),
              theme: _theme(context),
              darkTheme: _darkTheme(context),
              themeMode: value,
              home: const SplashPage(),
              //home: const PersistentBottomNavigationBar(),

            );
          },
        );
      },
    );

   /* return Sizer(
      builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (BuildContext context, value, Widget? child) {
            return GetMaterialApp(
              textDirection: TextDirection.rtl,
              initialBinding: InitialBinding(),

              title: 'Kaghaze souti',
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                Locale('fa', 'IR'),
              ],
              debugShowCheckedModeBanner: false,
              theme: LightTheme.lightTheme(context),
              darkTheme: DarkTheme.darkTheme(context),
              // theme: _theme(context),
              // darkTheme: _darkTheme(context),
              themeMode: value,
              home: const SplashPage(),

            );
          },
        );
      },
    );*/
  }

  ThemeData _theme(BuildContext context) {
    return ThemeData(
      fontFamily: fontFamily,
      primarySwatch: generateMaterialColor(color: _primaryColor),
      primaryColor: _primaryColor,
      scaffoldBackgroundColor: Colors.white,
      dividerColor: _primaryColor,
      appBarTheme: const AppBarTheme(
        toolbarHeight: 56.0,
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
      canvasColor: Colors.white,
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
        toolbarHeight: 56.0,
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
      canvasColor: Colors.grey.shade800,
    );
  }

  CardTheme _cardTheme() {
    return const CardTheme(
      color: Colors.transparent,
      elevation: 0.0,
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
