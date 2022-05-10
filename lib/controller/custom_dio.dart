import 'package:dio/dio.dart';
import 'package:kaghaze_souti/main.dart';
import '/view/pages/login_pages/splash_page.dart';

class CustomDio {
  static Dio dio = Dio(BaseOptions(baseUrl: domain, headers: headers),);
}