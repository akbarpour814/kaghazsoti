import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaz_reader/rx_string_extension.dart';

import '../../custom_navigator.dart';
import '../../services/custom_http/custom_request.dart';
import '../../services/custom_http/custom_response.dart';
import '../../widgets/first_and_last_name/first_and_last_name_controller.dart';
import '../../widgets/number_phone/number_phone_controller.dart';
import 'edit_profile_config.dart';
import 'edit_profile_model.dart';


class EditProfileController extends GetxController with StateMixin<EditProfileModel?> {
  late CustomResponse _response;
  late RxBool permissionToEditProfile;
  late RxBool isEditingProfile;
  late FirstAndLastNameController firstAndLastNameController;
  late NumberPhoneController numberPhoneController;

  EditProfileController() {
    permissionToEditProfile = false.obs;
    isEditingProfile = false.obs;
  }

  @override
  void onInit() {
    fetch();

    super.onInit();
  }

  Future<void> fetch() async {
    try {
      change(null, status: RxStatus.loading());

      _response = await CustomRequest.post(
        path: EditProfileConfig.config.apis.profile,
      );

      if (_response.statusCode == 200) {
        EditProfileModel editProfileModel = EditProfileModel.fromJson(
          _response.body,
        );

        firstAndLastNameController = Get.put<FirstAndLastNameController>(
          FirstAndLastNameController(
            firstAndLastName: editProfileModel.firstAndLastName,
          ),
        );

        numberPhoneController = Get.put<NumberPhoneController>(
          NumberPhoneController(
            numberPhone: editProfileModel.numberPhone,
          ),
        );

        change(editProfileModel, status: RxStatus.success());
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

  void grantPermissionToEditProfile(bool? value) {
    permissionToEditProfile.value = (value ?? false) && isEditingProfile.isFalse;
  }

  Future<void> editProfile() async {
    firstAndLastNameController.checkFormat();
    numberPhoneController.checkFormat();

    if ((!firstAndLastNameController.errorText.hasError) &&
        (!numberPhoneController.errorText.hasError)) {
      permissionToEditProfile.value = false;
      isEditingProfile.value = true;

      try {
        _response = await CustomRequest.post(
          path: EditProfileConfig.config.apis.editProfile,
          body: {
            'name': firstAndLastNameController.textEditingController.text,
            'mobile': numberPhoneController.textEditingController.text,
            'email': '',
          },
        );

        if (_response.statusCode == 200) {
          isEditingProfile.value = false;

          Get.showSnackbar(GetSnackBar(title: 'ggg', /*duration: Duration(seconds: 2),*/ icon: Icon(Icons.add),));
        } else {
          throw Exception();
        }
      } catch (e) {
        e.printError();
      }
    }
  }
}
