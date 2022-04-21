import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaghaze_souti/controller/internet_connection.dart';
import 'package:kaghaze_souti/controller/load_data_from_api.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_value/shared_value.dart';
import '../../../controller/prepare_to_login_app.dart';
import '../../view_models/custom_snack_bar.dart';
import '../../view_models/no_internet_connection.dart';
import '/view/view_models/custom_circular_progress_indicator.dart';
import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '/view/view_models/persistent_bottom_navigation_bar.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '/main.dart';

late Map<String, String> headers;
SharedValue<String> tokenLogin = SharedValue(value: '');

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with InternetConnection, LoadDataFromAPI {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );
  late bool _firstLogin;

  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();

    _initPackageInfo();
    // _x();
  }



  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future _loginStep() async {
    sharedPreferences = await SharedPreferences.getInstance();

    bookCartSlug = sharedPreferences.getStringList('bookCartSlug') ?? [];

    _firstLogin = sharedPreferences.getBool('firstLogin') ?? true;

    customDio = await Dio().post('https://kaghazsoti.uage.ir/api/categories');

    if (!_firstLogin) {
      tokenLogin.$ = await sharedPreferences.getString('tokenLogin') ?? '';

      headers = {
        'Authorization': 'Bearer ${tokenLogin.of(context)}',
        'Accept': 'application/json',
        'client': 'api',
      };

      print(headers);

      prepareToLoginApp();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PersistentBottomNavigationBar(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }

    return customDio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 80.0.w,
                height: 80.0.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _appLogo(),
                    _appSlogan(),
                  ],
                ),
              ),
              _loginStatus(),
            ],
          ),
        ),
      ),
    );
  }

  Image _appLogo() {
    return Image.asset(
      'assets/images/appLogoForOutApp.png',
      height: 45.0.h,
    );
  }

  Text _appSlogan() {
    return Text(
      'بهترین و جدید ترین\nکتاب های صوتی را با ما بشنوید.',
      style: Theme.of(context).textTheme.headline6!.copyWith(
            color: Theme.of(context).primaryColor,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _loginStatus() {
    if (connectionStatus == ConnectivityResult.none) {
      return const Center(
        child: NoInternetConnection(),
      );
    } else {


      if(load) {
        return FutureBuilder(
          future: _x(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.hasData) {
              if(_packageInfo.version == last) {
                return FutureBuilder(
                  future: _loginStep(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                    return Center(child: CustomCircularProgressIndicator());
                  },
                );
              } else {
                return TextButton(onPressed: _y, child: Text('بروزرسانی'));
              }
            } else {
              return Center(child: CustomCircularProgressIndicator());
            }
          },
        );
      } else {
        if(true) {
          return FutureBuilder(
            future: _loginStep(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

              return Center(child: CustomCircularProgressIndicator());
            },
          );
        } else {
          return TextButton(onPressed: _y, child: Text('بروزرسانی'));
        }
      }


      // return FutureBuilder(
      //   future: _x(),
      //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      //     return Center(child: Text('ss'));
      //
      // },);
    }
  }

  late String last;
  late String android;
  late String ios;
  bool load = true;
  Future _x() async {
    customDio = await Dio().get('https://kaghazsoti.uage.ir/api/version/get');

    if(customDio.statusCode == 200) {
      Map<String, dynamic> data = customDio.data;

      setState(() {
        last = data['version'].toString();
        android = data['android_link'];
        ios = data['ios_link'];
        load = false;
      });

      if(_packageInfo.version == last) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            context,
            Ionicons.checkmark_done_outline,
            'رمز عبور جدید ثبت شد.',
            4,
          ),
        );
      } else {
        // _y();

      }
    }

    return customDio;
  }

  void _y() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: AlertDialog(
            title: const Text(
              "بروزرسانی",
              style: TextStyle(color: Colors.redAccent),
            ),
            actions: [
              TextButton(
                child: const Text("اندروید"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("آی.او.اس"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}