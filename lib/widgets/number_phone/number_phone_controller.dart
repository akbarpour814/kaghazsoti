import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:kaz_reader/rx_string_extension.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import 'number_phone_config.dart';


class NumberPhoneController extends GetxController {
  late TextEditingController textEditingController;
  late RxString errorText;

  NumberPhoneController({String? numberPhone}) {
    textEditingController = TextEditingController(text: numberPhone);
    errorText = ''.obs;
  }

  void onChanged(String value) {
    checkFormat();
  }

  void checkFormat() {
    if (textEditingController.text.isEmpty) {
      if (errorText.error == null) {
        errorText.value = NumberPhoneConfig.config.texts.noNumberPhoneError;
      } else {
        errorText.value = '';
      }
    } else {
      if (textEditingController.text.toEnglishDigit().isValidIranianMobileNumber()) {
        errorText.value = '';
      } else {
        errorText.value = NumberPhoneConfig.config.texts.invalidNumberPhoneError;
      }
    }
  }
}