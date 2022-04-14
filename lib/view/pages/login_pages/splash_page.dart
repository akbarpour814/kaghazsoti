import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_value/shared_value.dart';
import '/view/view_models/custom_circular_progress_indicator.dart';
import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '/view/view_models/persistent_bottom_navigation_bar.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '/main.dart';

late Map<String, String> headers;

SharedValue<String> tokenLogin = SharedValue(value: '73|OfDRVAaeA7KgE0uhZyrO83qaMkGP73lW6E2xdVTR');

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

late bool firstLogin;
late Response<dynamic> customDio;
late CustomResponse customResponse;
class _SplashPageState extends State<SplashPage> {

  late bool _dataIsLoading;



  @override
  void initState() {
    _dataIsLoading = true;


    super.initState();
  }


  Future _loginStep() async {

    sharedPreferences = await SharedPreferences.getInstance();

    bookCartSlug = sharedPreferences.getStringList('bookCartSlug') ?? [];
    print(bookCartSlug);

    firstLogin = sharedPreferences.getBool('firstLogin') ?? true;
    print(firstLogin);

    customDio = await Dio().post('https://kaghazsoti.uage.ir/api/categories');
    print(customDio.statusCode);

    if(!firstLogin) {

      tokenLogin.$ = await sharedPreferences.getString('tokenLogin') ?? '73|OfDRVAaeA7KgE0uhZyrO83qaMkGP73lW6E2xdVTR';

      headers = {
        'Authorization' : 'Bearer ${tokenLogin.of(context)}',
        'Accept': 'application/json',
        'client': 'api',
      };

      print(headers);

      if(tokenLogin.of(context).isNotEmpty && !firstLogin) {
        preparation();


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PersistentBottomNavigationBar(),
          ),
        );
      }
      ///////////////////////////////////////////////////////////////////////////////////////////

      // Future.delayed(const Duration(seconds: 6), () {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const PersistentBottomNavigationBar(),
      //     ),
      //   );
      // });

    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),),
      );
    }

    return customDio;
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
            FutureBuilder(builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { return Center(child: CustomCircularProgressIndicator()); }, future: _loginStep(),),
          ],
        ),
      ),
    );
  }

  Image _appLogo() {
    return Image.asset(
      appLogo,
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

void preparation() async {




  //tokenLogin = '60|34pLDO4mZP84GtKq1aNFczvGFKZl07GnXoTCSTjI';

  customDio = await CustomDio.dio.get('dashboard/users/wish');

  print(customDio.statusCode);

  if(customDio.statusCode == 200) {

    customResponse = CustomResponse.fromJson(customDio.data);

    int lastPage = customResponse.data['last_page'];

    for(Map<String, dynamic> bookIntroduction in customResponse.data['data']) {
      markedBooksId.add(bookIntroduction['id']);
    }

    for(int i = 2; i <= lastPage; ++i) {
      customDio = await CustomDio.dio.get('dashboard/users/wish', queryParameters: {'page': i},);

      if(customDio.statusCode == 200) {
        customResponse = CustomResponse.fromJson(customDio.data);

        for(Map<String, dynamic> bookIntroduction in customResponse.data['data']) {
          markedBooksId.add(bookIntroduction['id']);
        }
      }
    }
  }


  customDio = await CustomDio.dio.get('dashboard/my_books');

  if(customDio.statusCode == 200) {
    Map<String, dynamic> data = customDio.data;

    int lastPage = data['last_page'];

    for(Map<String, dynamic> bookIntroduction in data['data']) {
      libraryId.add(bookIntroduction['id']);
    }

    for(int i = 2; i <= lastPage; ++i) {
      customDio = await CustomDio.dio.get('dashboard/my_books', queryParameters: {'page': i},);

      if(customDio.statusCode == 200) {
        data = customDio.data;

        for(Map<String, dynamic> bookIntroduction in data['data']) {
          libraryId.add(bookIntroduction['id']);
        }
      }
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////////
  customDio = await CustomDio.dio.get('user');
  if(customDio.statusCode == 200) {
    userId = customDio.data['id'];
  }
}
