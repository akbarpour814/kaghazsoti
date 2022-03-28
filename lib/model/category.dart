import 'package:flutter/material.dart';

import '/model/book_introduction.dart';

class Category {
  late int id;
  late String name;
  late IconData iconData;
  late List<Subcategory> subcategories = [];

  Category.fromJson(this.iconData, Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];

    for(Map<String, dynamic> subcategory in json['children']) {
      subcategories.add(Subcategory.fromJson(name, iconData, subcategory));
    }
  }
}

class Subcategory {
  late int id;
  late String name;
  late String slug;
  late String categoryTitle;
  late IconData iconData;
  late List<BookIntroduction> books;

  Subcategory.fromJson(this.categoryTitle, this.iconData, Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    books = [];
  }
}