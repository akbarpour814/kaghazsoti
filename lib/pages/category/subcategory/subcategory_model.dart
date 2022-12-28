import 'package:flutter/material.dart';

import '../../../widgets/book_introduction/book_introduction_model.dart';

class SubcategoryModel {
  final int id;
  final String name;
  final String slug;
  final String title;
  final IconData icon;
  final List<BookIntroductionModel> books;

  SubcategoryModel.fromJson(
    this.title,
    this.icon,
    Map<String, dynamic> json,
  )   : id = json['id'],
        name = json['name'],
        slug = json['slug'],
        books = [];
}
