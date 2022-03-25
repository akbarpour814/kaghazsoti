import 'package:dio/dio.dart';

class CustomDio {
  static Dio dio = Dio(BaseOptions(baseUrl: 'https://kaghazsoti.uage.ir/api/', headers: {'Authorization' : 'Bearer 50|IEyWoGaAYripoLugW6mcaVN69n2gpjjNv0vNPYmA', 'Accept': 'application/json', 'client': 'api'}),);
}