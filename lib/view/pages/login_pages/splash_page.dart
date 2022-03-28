import 'package:flutter/material.dart';
import 'package:takfood_seller/view/view_models/custom_circular_progress_indicator.dart';
import '/view/view_models/persistent_bottom_navigation_bar.dart';
import '/controller/database.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '/main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late bool _firstLogin;

  @override
  void initState() {
    _loginStep();

    super.initState();
  }

  void _loginStep() async {
    sharedPreferences = await SharedPreferences.getInstance();

    _firstLogin = sharedPreferences.getBool('firstLogin') ?? false;

    if (true) {
      Future.delayed(const Duration(seconds: 6), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => (_firstLogin
                ? const LoginPage()
                : const PersistentBottomNavigationBar()),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
            const CustomCircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Image _appLogo() {
    return Image.asset(
      'assets/images/logo.1e799436.jpg',
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
}
