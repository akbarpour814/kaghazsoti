import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaz_reader/pages/marked/marked_config.dart';
import 'package:kaz_reader/pages/purchase_history/purchase_history_config.dart';
import 'package:kaz_reader/pages/purchase_history/purchase_history_model.dart';

import '../../widgets/book_introduction/book_introduction_model.dart';
import '../../services/custom_http/custom_request.dart';
import '../../services/custom_http/custom_response.dart';
import '../about_us/about_us_config.dart';

class PurchaseHistoryController extends GetxController
    with StateMixin<List<PurchaseHistoryModel>?> {
  late CustomResponse _response;
  late RxInt currentPage;
  late int lastPage;
  late RxInt currentIndex;

  PurchaseHistoryController() {
    currentPage = 0.obs;
    currentIndex = (-1).obs;
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
        path: PurchaseHistoryConfig.config.apis.purchaseHistory,
        body: {'page': currentPage.value.toString()},
      );

      print(_response.statusCode);
      print(_response.body);

      if (_response.statusCode == 200) {
        List<PurchaseHistoryModel> purchaseHistoryModels = [];

        for (Map<String, dynamic> bookIntroduction in _response.body['data']
        ['data']) {
          purchaseHistoryModels.add(PurchaseHistoryModel.fromJson(bookIntroduction));
        }

        change(purchaseHistoryModels, status: RxStatus.success());
      } else {
        throw Exception();
      }
    } catch (e) {
      e.printError();

      change(null, status: RxStatus.error());
    }
  }

  void show(int index) {
    if (index == currentIndex.value) {
      currentIndex.value = -1;
    } else {
      currentIndex.value = index;
    }
  }
}
