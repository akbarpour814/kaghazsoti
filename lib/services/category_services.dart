import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaghazsoti/models/category.dart';

class Categories {
  static Future get() async {
    return [
      {
        "id": 1,
        "title": "یک",
        "children": [
          {"id": 2, "title": "دو"},
          {"id": 2, "title": "دو"}
        ]
      },
      {
        "id": 2,
        "title": "دو",
        "children": [
          {"id": 2, "title": "دو"},
          {"id": 2, "title": "دو"}
        ]
      },
      {
        "id": 3,
        "title": "سه",
        "children": [
          {"id": 2, "title": "دو"},
          {"id": 2, "title": "دو"}
        ]
      },
      {
        "id": 4,
        "title": "چهارم",
        "children": [
          {"id": 2, "title": "دو"},
          {"id": 2, "title": "دو"}
        ]
      },
    ];

    // List<Category> categoies = [];
    // responseBody.forEach((item) {
    //   print(responseBody[0]['id']);
    //   categoies.add(Category.fromJson(item));
    // });

    // return categoies;
  }
}
