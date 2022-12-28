import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kaz_reader/rx_string_extension.dart';

import 'first_and_last_name_config.dart';
import 'first_and_last_name_controller.dart';


class FirstAndLastNameWidget extends StatelessWidget {
  final FirstAndLastNameController controller;
  final bool readOnly;

  const FirstAndLastNameWidget({
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
        maxLength: 30,
        decoration: InputDecoration(
          helperText: FirstAndLastNameConfig.config.texts.helperText,
          hintText: FirstAndLastNameConfig.config.texts.hintText,
          errorText: controller.errorText.error,
          suffixIcon: Icon(FirstAndLastNameConfig.config.icons.suffixIcon),
        ),
        onChanged: controller.onChanged,
      ),
    );
  }
}
