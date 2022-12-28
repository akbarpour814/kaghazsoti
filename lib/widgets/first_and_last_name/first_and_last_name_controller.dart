import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:kaz_reader/rx_string_extension.dart';

import 'first_and_last_name_config.dart';


class FirstAndLastNameController extends GetxController {
  late TextEditingController textEditingController;
  late RxString errorText;

  FirstAndLastNameController({String? firstAndLastName}) {
    textEditingController = TextEditingController(text: firstAndLastName);
    errorText = ''.obs;
  }

  void onChanged(String value) {
    checkFormat();
  }

  void checkFormat() {
    if (textEditingController.text.isEmpty) {
      if (errorText.error == null) {
        errorText.value = FirstAndLastNameConfig.config.texts.noFirstAndLastNameError;
      } else {
        errorText.value = '';
      }
    } else {
      if (textEditingController.text.length > 4) {
        errorText.value = '';
      } else {
        errorText.value = FirstAndLastNameConfig.config.texts.invalidFirstAndLastNameError;
      }
    }
  }
}
