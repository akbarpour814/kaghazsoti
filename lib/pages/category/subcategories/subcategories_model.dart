import 'package:flutter/material.dart';

import '../subcategory/subcategory_model.dart';

class SubcategoriesModel {
  final String title;
  final IconData icon;
  late List<SubcategoryModel> subcategories;

  SubcategoriesModel.fromJson(
      this.title, this.icon, List<dynamic> json) {
    subcategories = [];

    for (Map<String, dynamic> subcategory in json) {
      subcategories.add(SubcategoryModel.fromJson(subcategory['name'], icon, subcategory));
    }
  }
}
