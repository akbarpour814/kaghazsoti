import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage{

  getData() async{
    var response = await http.post(Uri.parse('http://10.0.2.2/api/home'),headers: { "Host":"kaghazsoti.develop" });
    // var test = json.decode(response.body);
    // print(test['data']['books']);

    return json.decode(response.body);
  }
}