import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../custom_navigator.dart';
import '../../services/custom_http/custom_request.dart';
import '../../services/custom_http/custom_response.dart';
import '../about_us/about_us_config.dart';
import 'faq_config.dart';
import 'faq_model.dart';


class FAQController extends GetxController with StateMixin<List<FAQModel>?> {
  late CustomResponse _response;
  late RxInt currentIndex;

  FAQController() {
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
        path: FAQConfig.config.apis.faq,
      );

      if (_response.statusCode == 200) {
        List<FAQModel> faqModels = [];

        for (Map<String, dynamic> faq in _response.body['data']) {
          faqModels.add(FAQModel.fromJson(faq));
        }

        change(faqModels, status: RxStatus.success());
      } else {
        throw Exception();
      }
    } catch (e) {
      e.printError();

      change(null, status: RxStatus.error());
    }
  }

  dynamic back(BuildContext context) {
    CustomNavigator.pop(context: context);
  }

  void show(int index) {
    if (index == currentIndex.value) {
      currentIndex.value = -1;
    } else {
      currentIndex.value = index;
    }
  }
}