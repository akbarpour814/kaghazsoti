import 'package:dio/dio.dart';
import '/view/pages/login_pages/splash_page.dart';


class CustomDio {
  static Dio dio = Dio(BaseOptions(baseUrl: 'https://kaghazsoti.uage.ir/api/', headers: headers),);
}