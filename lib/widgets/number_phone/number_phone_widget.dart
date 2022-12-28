
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kaz_reader/rx_string_extension.dart';

import 'number_phone_config.dart';
import 'number_phone_controller.dart';

class NumberPhoneWidget extends StatelessWidget {
  final NumberPhoneController controller;
  final bool readOnly;

  const NumberPhoneWidget({
    Key? key,
    required this.controller,
    required this.readOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextField(
        controller: controller.textEditingController,
        readOnly: readOnly,
        keyboardType: TextInputType.name,
        maxLength: 11,
        decoration: InputDecoration(
          helperText: NumberPhoneConfig.config.texts.helperText,
          hintText: NumberPhoneConfig.config.texts.hintText,
          errorText: controller.errorText.error,
          suffixIcon: Icon(NumberPhoneConfig.config.icons.suffixIcon),
        ),
        onChanged: controller.onChanged,
      ),
    );
  }
}
