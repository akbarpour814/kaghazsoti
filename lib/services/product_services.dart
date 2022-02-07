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
    var response = await http.post(Uri.parse('http://10.0.2.2/api/home'),
        headers: {"Host": "kaghazsoti.develop"});

    if(response.statusCode == 200){
      var responseBody = json.decode(response.body)['data'];
      responseBody = responseBody['books'];

      List<Product> newAudio = [];
      responseBody['کتاب-صوتی']['new'].forEach((item){
        newAudio.add(Product.fromJson(item));
      });

      List<Product> saleAudio = [];
      responseBody['کتاب-صوتی']['sell'].forEach((item){
        saleAudio.add(Product.fromJson(item));
      });

      List<Product> newChild = [];
      responseBody['کتاب-کودک-و-نوجوان']['new'].forEach((item){
        newChild.add(Product.fromJson(item));
      });

      List<Product> saleChild = [];
      responseBody['کتاب-کودک-و-نوجوان']['sell'].forEach((item){
        saleChild.add(Product.fromJson(item));
      });

      List<Product> newLetter = [];
      responseBody['نامه-صوتی']['new'].forEach((item){
        newLetter.add(Product.fromJson(item));
      });

      List<Product> saleLetter = [];
      responseBody['نامه-صوتی']['sell'].forEach((item){
        saleLetter.add(Product.fromJson(item));
      });

      return {
        "newAudio" : newAudio,
        "saleAudio" : saleAudio.reversed,
        "newChild" : newChild,
        "saleChild" : saleChild.reversed,
        "newLetter" : newLetter,
        "saleLetter" : saleLetter.reversed,
      };
    }
  }
  static Future search({query = ''}) async {
    print('http://10.0.2.2/api/books?q=$query');
    var response = await http.post(Uri.parse('http://10.0.2.2/api/books?q=$query'),
        headers: {"Host": "kaghazsoti.develop"});
    print(response);

    if(response.statusCode == 200){
      var responseBody = json.decode(response.body)['data'];
      if (responseBody.length == 0) return <Product>[];
      responseBody = responseBody['books'];


      List<Product> results = [];
      responseBody.forEach((item){
        item['full_image'] = item['full_image'].replaceAll('http://kaghazsoti.develop','http://10.0.2.2');
        results.add(Product.fromJson(item));
      });

      return results;
    }
  }
}