import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:takfood_seller/controller/database.dart';

import '../controller/custom_response.dart';
import '../controller/https.dart';
import 'book.dart';

class Category {
  late int id;
  late String title;
  late IconData iconData;
  late List<Subcategory> subcategories = [];

  Category({required this.title, required this.iconData, required this.subcategories});

  Category.fromJson(this.iconData, Map<String, dynamic> json) {
    id = json['id'];
    title = json['name'];

    for(Map<String, dynamic> subcategory in json['children']) {
      subcategories.add(Subcategory.fromJson(title, iconData, subcategory));
    }
  }
}

class Subcategory {
  late int id;
  late String title;
  late String categoryTitle;
  late IconData iconData;
  late List<Book> books = [];

  Subcategory({required this.title, required this.categoryTitle, required this.iconData, required this.books});

  Subcategory.fromJson(this.categoryTitle, this.iconData, Map<String, dynamic> json) {
    id = json['id'];
    title = json['name'];

    _initBooks(json);
  }

  void _initBooks(Map<String, dynamic> json) async {
    for(Map<String, dynamic> book in json['new']) {
      Response<dynamic> httpsResponse = await Https.dio.post('books/${book['slug']}');

      CustomResponse customResponse = CustomResponse.fromJson(httpsResponse.data);

      books.add(Book.fromJson(book: customResponse.data, existingInUserMarkedBooks: false, userMarkedBooks: database.user.markedBooks));
    }
  }
}