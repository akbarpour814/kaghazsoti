import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late bool _firstLogin;
  late Widget _firstPage;

  @override
  void initState() {
    _loginStep();

    super.initState();
  }

  void _loginStep() async {
    sharedPreferences = await SharedPreferences.getInstance();

    _firstLogin = sharedPreferences.getBool('firstLogin') ?? true;

    if (_firstLogin) {
      _firstPage = const SafeArea(child: LoginPage());
    } else {
      _firstPage = SafeArea(
        child: PersistentTabView(
          context,
          controller: persistentTabController,
          screens: pages,
          items: items,
          navBarStyle: NavBarStyle.style18,
        ),
      );
    }

    Future.delayed(
      const Duration(seconds: 6),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => (_firstPage),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _appLogo(),
                    _appSlogan(),
                  ],
                ),
                SizedBox(
                  height: 20.0.h,
                ),
                _websiteAddress(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Flexible _appLogo() {
    return Flexible(
      child: Image.asset(
        'assets/images/logo.1e799436.jpg',
        // width: 70.0.w,
      ),
    );
  }

  Flexible _appSlogan() {
    return Flexible(
      child: Text(
        'بهترین\nو\nجدید ترین\nکتاب های صوتی را\nبا ما بشنوید.',
        style: TextStyle(
          color: const Color(0xFF005C6B),
          fontSize: 15.0.sp,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Text _websiteAddress() {
    return Text(
      'www.kaghazsoti.com',
      style: TextStyle(
        color: const Color(0xFF005C6B),
        fontSize: 15.0.sp,
      ),
      textAlign: TextAlign.justify,
    );
  }
}
