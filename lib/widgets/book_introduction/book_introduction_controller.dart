import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kaz_reader/custom_navigator.dart';
import 'package:kaz_reader/pages/profile/profile_enum.dart';

import '../../pages/book/book_page.dart';
import 'book_introduction_model.dart';

class BookIntroductionController extends GetxController with StateMixin<BookIntroductionModel?> {
  BookIntroductionController({required BookIntroductionModel book}) {
    change(book, status: RxStatus.success());
  }

  void push(BuildContext context) {
    CustomNavigator.push(
      context: context,
      page: BookPage(
        book: state!,
      ),
    );
  }
}
