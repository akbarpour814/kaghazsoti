import 'package:flutter/material.dart';
import 'package:kaz_reader/pages/category/subcategories/subcategories_model.dart';
import 'package:kaz_reader/pages/category/subcategory/subcategory_model.dart';

import 'category_config.dart';

class CategoryModel {
  final int id;
  final String title;
  final IconData icon;
  final SubcategoriesModel subcategories;

  CategoryModel.fromJson(this.icon, Map<String, dynamic> json)
      : id = json['id'],
        title = json['name'],
        subcategories = SubcategoriesModel.fromJson(
          json['name'],
          icon,
          json['children'],
        );
}

enum CategoryEnum {
  audioBooks,
  voicemails,
  ebooks,
  podcasts,
  childrenAndTeenagersBooks;
}

extension CategoryEnumExtension on CategoryEnum {
  String get title {
    return {
      CategoryEnum.audioBooks: CategoryConfig.config.texts.audioBooks,
      CategoryEnum.voicemails: CategoryConfig.config.texts.voicemails,
      CategoryEnum.ebooks: CategoryConfig.config.texts.ebooks,
      CategoryEnum.podcasts: CategoryConfig.config.texts.podcasts,
      CategoryEnum.childrenAndTeenagersBooks:
          CategoryConfig.config.texts.childrenAndTeenagersBooks,
    }[this]!;
  }

  static IconData icon(String title) {
    return {
      CategoryEnum.audioBooks.title: CategoryConfig.config.icons.audioBooks,
      CategoryEnum.voicemails.title: CategoryConfig.config.icons.voicemails,
      CategoryEnum.ebooks.title: CategoryConfig.config.icons.ebooks,
      CategoryEnum.podcasts.title: CategoryConfig.config.icons.podcasts,
      CategoryEnum.childrenAndTeenagersBooks.title:
          CategoryConfig.config.icons.childrenAndTeenagersBooks,
    }[title]!;
  }
}
