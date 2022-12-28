import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaz_reader/rx_string_extension.dart';
import 'package:kaz_reader/widgets/password/password_config.dart';
import 'package:kaz_reader/widgets/password/password_controller.dart';

class PasswordWidget extends StatelessWidget {
  final PasswordController controller;
  final bool readOnly;

  const PasswordWidget({
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
        obscureText: !controller.isVisible.value,
        keyboardType:TextInputType.visiblePassword,
        decoration: InputDecoration(
          helperText: PasswordConfig.config.texts.helperText,
          hintText: PasswordConfig.config.texts.hintText,
          errorText: controller.errorText.error,
          suffixIcon: InkWell(
            onTap: () => controller.visibility(),
            child: Icon(
              controller.isVisible.value
                  ? PasswordConfig.config.icons.visible
                  : PasswordConfig.config.icons.invisible,
            ),
          ),
        ),
        onChanged: controller.onChanged,
      ),
    );
  }
}
