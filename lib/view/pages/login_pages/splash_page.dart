import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:takfood_seller/view/view_models/custom_circular_progress_indicator.dart';
import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
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
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  late bool _dataIsLoading;
  late bool _firstLogin;


  @override
  void initState() {
    _dataIsLoading = true;


    super.initState();
  }


  Future _loginStep() async {
    sharedPreferences = await SharedPreferences.getInstance();

    _customDio = await CustomDio.dio.get('dashboard/users/wish');

    if(_customDio.statusCode == 200) {
      _customResponse = CustomResponse.fromJson(_customDio.data);

      for(Map<String, dynamic> book in _customResponse.data['data']) {
        markedBooksId.add(book['id']);
      }
    }


    _customDio = await CustomDio.dio.get('dashboard/my_books');

    if(_customDio.statusCode == 200) {

      Map<String, dynamic> data = _customDio.data;

      int lastPage = data['last_page'];

      for(Map<String, dynamic> bookIntroduction in data['data']) {
        markedBooksId.add(bookIntroduction['id']);
      }

      for(int i = 2; i <= lastPage; ++i) {
        _customDio = await CustomDio.dio.get('dashboard/my_books', queryParameters: {'page': i},);

        if(_customDio.statusCode == 200) {
          data = _customDio.data;

          for(Map<String, dynamic> bookIntroduction in data['data']) {
            markedBooksId.add(bookIntroduction['id']);
          }
        }
      }
    }

    /////////////////////////////////////////////////////////////////////////////////////////////
    _customDio = await CustomDio.dio.get('user');
    if(_customDio.statusCode == 200) {
      userId = _customDio.data['id'];
    }
    ///////////////////////////////////////////////////////////////////////////////////////////
    cartSlug = sharedPreferences.getStringList('cartSlug') ?? [];

    _firstLogin = sharedPreferences.getBool('firstLogin') ?? false;

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

    return _customDio;
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
            FutureBuilder(builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { return const CustomCircularProgressIndicator(); }, future: _loginStep(),),
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
