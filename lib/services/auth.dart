import 'dart:convert';
import 'package:http/http.dart' as http;

class Auth {
  login(body) async {
    var response = await http.post(Uri.parse('http://10.0.2.2/api/login'),
        headers: {"Host": "kaghazsoti.develop"}, body: body);
    return json.decode(response.body);
  }

  static Future<bool> checkApiToken(token) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2/api/dashboard'),
        headers: {
          "Host": "kaghazsoti.develop",
          "Accept": "application/json",
          "authorization": "Bearer $token",
        });

    return response.statusCode == 200;
  }
}