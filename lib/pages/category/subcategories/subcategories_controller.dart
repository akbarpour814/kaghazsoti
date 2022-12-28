import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaz_reader/pages/category/subcategories/subcategories_model.dart';

class SubcategoriesController extends GetxController
    with StateMixin<SubcategoriesModel?> {
  SubcategoriesController({required SubcategoriesModel subcategories}) {
    change(subcategories, status: RxStatus.success());
  }
}
