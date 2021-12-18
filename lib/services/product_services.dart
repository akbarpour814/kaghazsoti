import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaghazsoti/models/product.dart';

class Products {
  static Future get(page) async {
    var response = await http.post(Uri.parse('http://10.0.2.2/api/books?page=$page'),
        headers: {"Host": "kaghazsoti.develop"});

    if(response.statusCode == 200){
      var responseBody = json.decode(response.body)['data'];

      List<Product> products = [];
      responseBody['data'].forEach((item){
        products.add(Product.fromJson(item));
      });

      return {
        "current_page" : responseBody['current_page'],
        "products" : products
      };
    }
  }
  static Future home() async {
    var response = await http.post(Uri.parse('https://kaghazsoti.uage.ir/api/home'));

    if(response.statusCode == 200){
      var responseBody = json.decode(response.body)['data'];
      responseBody = responseBody['books']['کتاب-صوتی']['new'];

      List<Product> products = [];
      responseBody.forEach((item){
        products.add(Product.fromJson(item));
      });

      return {
        "products" : products
      };
    }
  }
}