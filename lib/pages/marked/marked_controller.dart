import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaz_reader/pages/marked/marked_config.dart';

import '../../widgets/book_introduction/book_introduction_model.dart';
import '../../services/custom_http/custom_request.dart';
import '../../services/custom_http/custom_response.dart';
import '../about_us/about_us_config.dart';

class MarkedController extends GetxController
    with StateMixin<List<BookIntroductionModel>?> {
  late CustomResponse _response;
  late RxInt currentPage;
  late int lastPage;

  MarkedController() {
    currentPage = 1.obs;
  }

  @override
  void onInit() {
    fetch();

    super.onInit();
  }

  Future<void> fetch() async {
    try {
      change(null, status: RxStatus.loading());

      _response = await CustomRequest.get(
        path: MarkedConfig.config.apis.marked,
        body: {'page': currentPage.value.toString()},
      );

      print(_response.statusCode);
      print(_response.body);

      if (_response.statusCode == 200) {
        List<BookIntroductionModel> books = [];

        for (Map<String, dynamic> bookIntroduction in _response.body['data']
            ['data']) {
          books.add(BookIntroductionModel.fromJson(bookIntroduction));
        }

        change(books, status: RxStatus.success());
      } else {
        throw Exception();
      }
    } catch (e) {
      e.printError();

      change(null, status: RxStatus.error());
    }
  }
}
