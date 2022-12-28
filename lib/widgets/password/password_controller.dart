
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaz_reader/rx_string_extension.dart';
import 'package:kaz_reader/widgets/password/password_config.dart';


class PasswordController extends GetxController {
  late TextEditingController textEditingController;
  late RxString errorText;
  late RxBool isVisible;

  PasswordController() {
    textEditingController = TextEditingController();
    errorText = ''.obs;
    isVisible = false.obs;
  }

  void onChanged(String value) {
    checkFormat();
  }

  void checkFormat() {
    if (textEditingController.text.isEmpty) {
      if (errorText.error == null) {
        errorText.value = PasswordConfig.config.texts.noNumberPhoneError;
      } else {
        errorText.value = '';
      }
    } else {
      if (textEditingController.text.length > 10) {
        errorText.value = '';
      } else {
        errorText.value = PasswordConfig.config.texts.invalidNumberPhoneError;
      }
    }
  }

  void visibility() {
    isVisible.value = !isVisible.value;
  }
}