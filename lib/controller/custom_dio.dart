import 'package:dio/dio.dart';
import 'package:shared_value/shared_value.dart';

String tokenLogin = '';

class CustomDio {
  static Dio dio = Dio(BaseOptions(baseUrl: 'https://kaghazsoti.uage.ir/api/', headers: {'Authorization' : 'Bearer $tokenLogin', 'Accept': 'application/json', 'client': 'api'}),);
}