//------/packages
import 'package:dio/dio.dart';

//------/view/pages/login_pages
import '../pages/splash/splash_page.dart';

//------/main
import '/main.dart';

class CustomDio {
  static Dio dio = Dio(
    BaseOptions(baseUrl: domain, headers: headers),
  );
}
