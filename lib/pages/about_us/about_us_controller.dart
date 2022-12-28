
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaz_reader/custom_navigator.dart';

import '../../services/custom_http/custom_request.dart';
import '../../services/custom_http/custom_response.dart';
import 'about_us_config.dart';
import 'about_us_model.dart';

class AboutUsController extends GetxController with StateMixin<AboutUsModel> {
  late CustomResponse _response;

  @override
  void onInit() {
    fetch();

    super.onInit();
  }

  Future<void> fetch() async {
    try {
      change(null, status: RxStatus.loading());

      _response = await CustomRequest.get(
        path: AboutUsConfig.config.apis.aboutUs,
      );

      if (_response.statusCode == 200) {
        Map<String, dynamic> json = _response.body['data'][0];

        _response = await CustomRequest.post(
          path: AboutUsConfig.config.apis.adminInfo,
        );

        if (_response.statusCode == 200) {
          json.addAll(_response.body['data']);

          AboutUsModel aboutUsModel = AboutUsModel.fromJson(json);

          change(aboutUsModel, status: RxStatus.success());
        } else {
          throw Exception();
        }
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
}
