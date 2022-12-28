import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'custom_response.dart';

class CustomRequest {
  static Map<String, String>? _headers;
  static http.Response? _response;

  static void setHeaders({String? token}) {
    _headers = {
      'Authorization':
          'Bearer ${'335|AENcG1qHJHEZs97c1WTq0QB8k3U0KEJdNzutxAke'}',
      'Accept': 'application/json',
      'client': 'api',
    };
  }

  static Future<CustomResponse> get({
    required String path,
    Map<String, String>? body,
  }) async {
    setHeaders();

    _response = await http.get(
      _uri(path: path),
      headers: _headers,
      //body: body,
    );

    // print(_response!.statusCode);
    // print(_response!.body);

    return CustomResponse(
      statusCode: _response!.statusCode,
      body: decode(
        bodyBytes: _response!.bodyBytes,
      ),
    );
  }

  static Future<CustomResponse> post({
    required String path,
    Map<String, String>? body,
  }) async {
    setHeaders();

    _response = await http.post(
      _uri(path: path),
      headers: _headers,
      body: body,
    );

    return CustomResponse(
      statusCode: _response!.statusCode,
      body: decode(
        bodyBytes: _response!.bodyBytes,
      ),
    );
  }

  static Uri _uri({
    required String path,
  }) {
    return Uri.https(
      'kaghazsoti.com',
      path,
    );
  }

  static dynamic decode({
    required Uint8List bodyBytes,
  }) {
    return jsonDecode(utf8.decode(bodyBytes));
  }

  static dynamic encode({
    required dynamic object,
  }) {
    return jsonEncode(object);
  }
}
