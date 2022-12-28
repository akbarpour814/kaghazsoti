//------/dart and flutter packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//------/packages
export 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

//------/controller
import '../../widgets/first_and_last_name/first_and_last_name_controller.dart';
import '../../widgets/first_and_last_name/first_and_last_name_widget.dart';
import '../../widgets/number_phone/number_phone_widget.dart';
import '/controller/custom_dio.dart';
import '/controller/functions_for_checking_user_information_format.dart';
import '/controller/internet_connection.dart';
import '/controller/load_data_from_api.dart';

//------/view/view_models
import '../../widgets/custom_circular_progress_indicator.dart';
import '/widgets/custom_snack_bar.dart';
import '/widgets/no_internet_connection.dart';

//------/main
import '/main.dart';
import 'edit_profile_controller.dart';

class EditProfilePage extends GetView<EditProfileController> {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context),
      bottomNavigationBar: playerBottomNavigationBar,
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text('حساب کاربری'),
      automaticallyImplyLeading: false,
      leading: const Icon(
        Ionicons.person_outline,
      ),
      actions: [
        InkWell(
          child: const Padding(
            padding: EdgeInsets.all(18.0),
            child: Icon(
              Ionicons.chevron_back_outline,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _body(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.fetch(),
      child: controller.obx(
            (state) => _innerBody(context),
        onError: (e) => const Text('onError'),
        onLoading: const Center(
          child: CustomCircularProgressIndicator(),
        ),
        onEmpty: const Text('onEmpty'),
      ),
    );
  }

  Widget _innerBody(BuildContext context) {
    return Obx(() => Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _permissionToEditCheckbox(context),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0.h),
                child: Column(
                  children: [
                    _firstAndLastName(),
                    _phoneNumber(),
                  ],
                ),
              ),
              _informationRegistrationButton(context),
            ],
          ),
        ),
      ),
    ));

  }

  Row _permissionToEditCheckbox(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Checkbox(
            value: controller.permissionToEditProfile.value,
            onChanged: controller.grantPermissionToEditProfile,
          ),
        ),
        Flexible(
          child: RichText(
            text: TextSpan(
              text: 'ویرایش اطلاعات',
              style: TextStyle(
                color: controller.permissionToEditProfile.value
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                fontFamily: fontFamily,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _firstAndLastName() {
    return FirstAndLastNameWidget(
      controller: controller.firstAndLastNameController,
      readOnly: controller.permissionToEditProfile.isFalse,
    );
  }

  Widget _phoneNumber() {
    return NumberPhoneWidget(
      controller: controller.numberPhoneController,
      readOnly: controller.permissionToEditProfile.isFalse,
    );
  }



  Visibility _informationRegistrationButton(BuildContext context) {
    return Visibility(
      visible: controller.permissionToEditProfile.isTrue,
      child: SizedBox(
        width: 100.0.w - (2 * 5.0.w),
        child: ElevatedButton.icon(
          onPressed: () async {
           await controller.editProfile();
          },
          label: Text(
            controller.permissionToEditProfile.isTrue ? 'ویرایش اطلاعات' : 'لطفاً شکیبا باشید.',
          ),
          icon: Icon(
            controller.permissionToEditProfile.isTrue
                ? Ionicons.checkmark_done_outline
                : Ionicons.checkmark_outline,
          ),
        ),
      ),
    );
  }

/*
  void _informationRegistration(BuildContext context) async {
    _firstAndLastNameError =
        UserInformationFormatCheck.checkFirstAndLastNameFormat(
          _firstAndLastNameController,
          'لطفاً نام و نام خوانوادگی خود را وارد کنید.',
        );
    _phoneNumberError = UserInformationFormatCheck.checkPhoneNumberFormat(
      _phoneNumberController,
      'لطفاً شماره تلفن همراه خود را وارد کنید.',
    );

    if (_firstAndLastNameError == null &&
        _phoneNumberError == null) {
      setState(() {
        _informationRegistrationClick = false;
      });

      _permissionToEdit = false;
      _registeredInformation = false;

      customDio = await CustomDio.dio.post(
        'user',
        data: {
          'name': _firstAndLastNameController.text,
          'email': '',
          'mobile': _phoneNumberController.text,
        },
      );

      setState(() {
        if (customDio.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              Ionicons.checkmark_done_outline,
              'اطلاعات شما با موفقیت به روز رسانی شد.',
              4,
            ),
          );
        } else {
          _informationRegistrationClick = true;

          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              Ionicons.refresh_outline,
              'لطفاً دوباره امتحان کنید.',
              4,
            ),
          );
        }
      });
    }
  }
*/
}

