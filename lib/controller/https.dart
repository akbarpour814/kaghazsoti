import 'package:dio/dio.dart';

class Https {
  static Dio dio = Dio(BaseOptions(baseUrl: 'https://kaghazsoti.uage.ir/api/'),);
}