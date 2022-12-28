import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kaz_reader/custom_navigator.dart';
import 'package:kaz_reader/pages/profile/profile_enum.dart';

import '../../../widgets/book_introduction/book_introduction_model.dart';
import '../../../widgets/books_page.dart';
import '../../book/book_page.dart';
import 'category_model.dart';

class CategoryController extends GetxController
    with StateMixin<CategoryModel?> {
  CategoryController({required CategoryModel category}) {
    change(category, status: RxStatus.success());
  }

  void push(
    BuildContext context,
    String title,
    List<BookIntroductionModel> books,
  ) {
    CustomNavigator.push(
      context: context,
      page: BooksPage(
        title: title,
        books: books,
      ),
    );
  }
}
