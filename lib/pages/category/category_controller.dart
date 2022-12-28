import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../services/custom_http/custom_request.dart';
import '../../services/custom_http/custom_response.dart';
import '../about_us/about_us_config.dart';
import 'category_config.dart';
import 'category_model.dart';

class CategoryController extends GetxController
    with StateMixin<List<CategoryModel>?> {
  late CustomResponse _response;

  @override
  void onInit() {
    fetch();

    super.onInit();
  }

  Future<void> fetch() async {
    try {
      change(null, status: RxStatus.loading());

      _response = await CustomRequest.post(
        path: CategoryConfig.config.apis.category,
      );

      if (_response.statusCode == 200) {
        List<CategoryModel> state = [];

        for (Map<String, dynamic> category in _response.body['data']) {
          state.add(
            CategoryModel.fromJson(
              CategoryEnumExtension.icon(category['name']),
              category,
            ),
          );
        }

        change(state, status: RxStatus.success());
      } else {
        throw Exception();
      }
    } catch (e) {
      e.printError();

      change(null, status: RxStatus.error());
    }
  }
}
