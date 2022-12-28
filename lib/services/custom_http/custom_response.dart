import 'dart:typed_data';

import 'package:http/http.dart';

class CustomResponse {
  final int statusCode;
  final dynamic body;

  CustomResponse({required this.statusCode, required this.body});
}
