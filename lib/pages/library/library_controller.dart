import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../widgets/book_introduction/book_introduction_model.dart';
import '../../services/custom_http/custom_request.dart';
import '../../services/custom_http/custom_response.dart';
import '../about_us/about_us_config.dart';
import 'library_config.dart';



class LibraryController extends GetxController with StateMixin<List<BookIntroductionModel>?> {
  late CustomResponse _response;
  late RxInt currentPage;
  late int lastPage;


  LibraryController() {
    currentPage = 0.obs;
  }

  @override
  void onInit() {
    fetch();

    super.onInit();
  }

  Future<void> fetch() async {
    change(null, status: RxStatus.loading());

    _response = await CustomRequest.get(
      path: LibraryConfig.config.apis.library,
      body: {'page': currentPage.value.toString()},
    );

    if (_response.statusCode == 200) {
      List<BookIntroductionModel> books = [];

      for (Map<String, dynamic> bookIntroduction in _response.body['data']['data']) {
        books.add(BookIntroductionModel.fromJson(bookIntroduction));
      }


      change(books, status: RxStatus.success());
    } else {
      throw Exception();
    }
    try {


    } catch(e) {
      e.printError();

      change(null, status: RxStatus.error());
    }
  }

  Future<void> removeFreeBook(BuildContext context,BookIntroductionModel book) async {
    // customDio = await CustomDio.dio.post(
    //   'dashboard/free/remove',
    //   data: {'id': book.id},
    // );
    //
    // if (customDio.statusCode == 200) {
    //   customResponse = CustomResponse.fromJson(customDio.data);
    //
    //   setState(() {
    //     libraryId.remove(book.id);
    //
    //     dataIsLoadingGlobal = true;
    //   });
    // }
  }

}