import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaz_reader/pages/book/book_model.dart';

import '../../services/custom_http/custom_request.dart';
import '../../services/custom_http/custom_response.dart';
import '../about_us/about_us_config.dart';



class BookController extends GetxController with StateMixin<BookModel?> {
  late CustomResponse _response;
  late String slug;

  BookController(this.slug);

  @override
  void onInit() {
    fetch();

    super.onInit();
  }

  Future<void> fetch() async {
    try {
      // change(null, status: RxStatus.loading());
      //
      // _response = await CustomRequest.post(
      //   path: CategoryConfig.config.apis.category,
      // );
      //
      // if (_response.statusCode == 200) {
      //   List<CategoryModel> categoryModels = [];
      //
      //   Map<String, IconData> categoriesIcon = {
      //     'کتاب صوتی': Ionicons.musical_notes_outline,
      //     'نامه صوتی': Ionicons.mail_open_outline,
      //     'کتاب الکترونیکی': Ionicons.laptop_outline,
      //     'پادکست': Ionicons.volume_medium_outline,
      //     'کتاب کودک و نوجوان': Ionicons.happy_outline,
      //   };
      //
      //   for (Map<String, dynamic> category in _response.body['data']) {
      //     categoryModels.add(
      //       CategoryModel.fromJson(
      //         categoriesIcon[category['name']] ?? Ionicons.albums_outline,
      //         category,
      //       ),
      //     );
      //   }
      //
      //   change(categoryModels, status: RxStatus.success());
      // } else {
      //   throw Exception();
      // }
    } catch(e) {
      e.printError();

      change(null, status: RxStatus.error());
    }
  }
}