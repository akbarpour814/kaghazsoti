//------/dart and flutter packages
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

//------/packages
export 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_value/shared_value.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

//------/controller
import '/controller/internet_connection.dart';
import '/controller/load_data_from_api.dart';
import '/controller/prepare_to_login_app.dart';

//------/view/pages/login_pages
import '../login/login_page.dart';

//------/view/view_models
import '../../widgets/custom_circular_progress_indicator.dart';
import '/widgets/no_internet_connection.dart';
import '/widgets/persistent_bottom_navigation_bar.dart';

//------/main
import '/main.dart';

late Map<String, String> headers;
SharedValue<String> tokenLogin = SharedValue(value: '');

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with InternetConnection, LoadDataFromAPI {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );
  bool _versionIsLoading = true;
  late String _version;
  late bool _firstLogin;

  @override
  void initState() {
    super.initState();

    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future _getVersion() async {
    customDio = await Dio().get('${domain}version/get');

    if (customDio.statusCode == 200) {
      Map<String, dynamic> data = customDio.data;

      setState(() {
        _version = data['version'].toString();
        androidLink = data['android_link'];
        iosLink = data['ios_link'];
        resendSms = data['resend_sms'] ?? 100;
        _versionIsLoading = false;
      });

      if (_packageInfo.version != _version) {
        _update();
      }
    }

    return customDio;
  }

  Future _loginStep() async {
    sharedPreferences = await SharedPreferences.getInstance();

    bookCartSlug = sharedPreferences.getStringList('bookCartSlug') ?? [];

    _firstLogin = sharedPreferences.getBool('firstLogin') ?? true;

    if (!_firstLogin) {
      tokenLogin.$ = await sharedPreferences.getString('tokenLogin') ?? '';

      headers = {
        'Authorization': 'Bearer ${tokenLogin.of(context)}',
        'Accept': 'application/json',
        'client': 'api',
      };

      dataIsLoading = false;

      prepareToLoginApp();

      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const PersistentBottomNavigationBar(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }

    return customDio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Center _body() {
    return Center(
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
    );
  }

  Widget _appLogo() {
    return Image.asset(
      'assets/images/appLogo.jpg',
      height: 45.0.h,
    );
  }

  Text _appSlogan() {
    return Text(
      '???????????? ?? ???????? ????????\n???????? ?????? ???????? ???? ???? ???? ????????????.',
      style: Theme.of(context)
          .textTheme
          .headline6!
          .copyWith(color: Theme.of(context).primaryColor),
      textAlign: TextAlign.center,
    );
  }

  Widget _loginStatus() {
    if (connectionStatus == ConnectivityResult.none) {
      return const Center(
        child: NoInternetConnection(),
      );
    } else {
      if (_versionIsLoading) {
        return FutureBuilder(
          future: _getVersion(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              if (_packageInfo.version == _version) {
                return FutureBuilder(
                  future: _loginStep(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    return Center(child: CustomCircularProgressIndicator());
                  },
                );
              } else {
                return TextButton.icon(
                  onPressed: _update,
                  label: Text('?????????????????? ????????????'),
                  icon: Icon(Icons.update_rounded),
                );
              }
            } else {
              return Center(child: CustomCircularProgressIndicator());
            }
          },
        );
      } else {
        if (_packageInfo.version == _version) {
          if (dataIsLoading) {
            return FutureBuilder(
              future: _loginStep(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return Center(child: CustomCircularProgressIndicator());
              },
            );
          } else {
            return Center(child: CustomCircularProgressIndicator());
          }
        } else {
          return TextButton.icon(
            onPressed: _update,
            label: Text('?????????????????? ????????????'),
            icon: Icon(Icons.update_rounded),
          );
        }
      }
    }
  }

  void _update() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: AlertDialog(
            title: Text(
              '?????????? ???????????? ???? ???? ?????????? ???????? ?????????????????? ????????.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
              Platform.isAndroid
                  ? _platformUpdateButton(androidLink)
                  : _platformUpdateButton(iosLink),
            ],
          ),
        );
      },
    );
  }

  TextButton _platformUpdateButton(String link) {
    return TextButton.icon(
      onPressed: () {
        launch(link);
      },
      label: Text('?????????????????? ????????????'),
      icon: Icon(Icons.update_rounded),
    );
  }
}
