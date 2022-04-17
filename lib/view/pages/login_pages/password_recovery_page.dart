import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaghaze_souti/controller/internet_connection.dart';
import 'package:kaghaze_souti/controller/load_data_from_api.dart';
import 'package:kaghaze_souti/view/pages/login_pages/splash_page.dart';
import '../../../controller/custom_response.dart';
import '../../../controller/functions_for_checking_user_information_format.dart';
import '../../../controller/prepare_to_login_app.dart';
import '../../view_models/custom_snack_bar.dart';
import '../../view_models/no_internet_connection.dart';
import '../../view_models/persistent_bottom_navigation_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../main.dart';

import 'package:http/http.dart' as http;

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({Key? key}) : super(key: key);

  @override
  _PasswordRecoveryPageState createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage>
    with InternetConnection, LoadDataFromAPI {
  late TextEditingController _phoneNumberController;
  String? _phoneNumberError;
  late TextEditingController _recoveryCodeController;
  String? _recoveryCodeError;
  late TextEditingController _newPasswordController;
  String? _newPasswordError;
  late TextEditingController _repeatNewPasswordController;
  String? _repeatNewPasswordError;
  late bool _obscureText;
  late bool _sendRecoveryCode;

  @override
  void initState() {
    super.initState();

    _phoneNumberController = TextEditingController();
    _recoveryCodeController = TextEditingController();
    _newPasswordController = TextEditingController();
    _repeatNewPasswordController = TextEditingController();
    _obscureText = true;
    _sendRecoveryCode = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('بازیابی رمز عبور'),
      automaticallyImplyLeading: false,
      leading: const Icon(
        Ionicons.key_outline,
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
            if (!_sendRecoveryCode) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  Widget _body() {
    if (connectionStatus == ConnectivityResult.none) {
      return const Center(
        child: NoInternetConnection(),
      );
    } else {
      return Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 5.0.h),
                  child: _permissionToObscureText(),
                ),
                _phoneNumber(),
                _recoveryCode(),
                _newPassword(),
                _repeatNewPassword(),
                _receiveRecoveryCodeButton(),
                _sendRecoveryCodeButton(),
              ],
            ),
          ),
        ),
      );
    }
  }

  Visibility _permissionToObscureText() {
    return Visibility(
      visible: !_sendRecoveryCode,
      child: Row(
        children: [
          Flexible(
            child: Checkbox(
              onChanged: (bool? value) {
                setState(() {
                  _obscureText = _obscureText ? false : true;
                });
              },
              value: _obscureText,
              activeColor:
                  _obscureText ? Theme.of(context).primaryColor : Colors.grey,
            ),
          ),
          Flexible(
            child: RichText(
              text: TextSpan(
                text: _obscureText ? 'عدم نمایش رمز' : 'نمایش رمز',
                style: TextStyle(
                  color: _obscureText
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  fontFamily: fontFamily,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Visibility _phoneNumber() {
    return Visibility(
      visible: _sendRecoveryCode,
      child: Padding(
        padding: EdgeInsets.only(bottom: 0.5.h),
        child: TextField(
          controller: _phoneNumberController,
          keyboardType: TextInputType.phone,
          maxLength: 11,
          decoration: InputDecoration(
            helperText: 'تلفن همراه',
            hintText: 'لطفاً شماره تلفن همراه خود را وارد کنید.',
            errorText: _phoneNumberError,
            suffixIcon: const Icon(Ionicons.phone_portrait_outline),
          ),
          onChanged: (String text) {
            setState(() {
              _phoneNumberError =
                  UserInformationFormatCheck.checkPhoneNumberFormat(
                _phoneNumberController,
                null,
              );
            });
          },
        ),
      ),
    );
  }

  Visibility _receiveRecoveryCodeButton() {
    return Visibility(
      visible: _sendRecoveryCode,
      child: Padding(
        padding: EdgeInsets.only(top: 5.0.h),
        child: Center(
          child: SizedBox(
            width: 100.0.w - (2 * 5.0.w),
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _receiveRecoveryCode();
                });
              },
              label: const Text('دریافت کد بازیابی'),
              icon: const Icon(Ionicons.checkmark_outline),
            ),
          ),
        ),
      ),
    );
  }

  void _receiveRecoveryCode() async {
    _phoneNumberError = UserInformationFormatCheck.checkPhoneNumberFormat(
      _phoneNumberController,
      'لطفاً شماره تلفن همراه خود را وارد کنید.',
    );

    if (_phoneNumberError == null) {
      customDio = await Dio().post(
        'https://kaghazsoti.uage.ir/api/forgot/step1',
        data: {'mobile': _phoneNumberController.text},
      );

      if (customDio.statusCode == 200) {
        setState(() {
          _sendRecoveryCode = false;
        });
      }
    }
  }

  Visibility _recoveryCode() {
    return Visibility(
      visible: !_sendRecoveryCode,
      child: Padding(
        padding: EdgeInsets.only(bottom: 0.5.h),
        child: TextField(
          controller: _recoveryCodeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            helperText: 'کد بازیابی',
            hintText: 'لطفاً کد بازیابی را وارد کنید.',
            errorText: _recoveryCodeError,
            suffixIcon: const Icon(Ionicons.code_working_outline),
          ),
          onChanged: (String text) {},
        ),
      ),
    );
  }

  Visibility _sendRecoveryCodeButton() {
    return Visibility(
      visible: !_sendRecoveryCode,
      child: Padding(
        padding: EdgeInsets.only(top: 5.0.h),
        child: Center(
          child: SizedBox(
            width: 100.0.w - (2 * 5.0.w),
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _sendRecoveryCodeOperation();
                });
              },
              label: const Text('ارسال کد بازیابی'),
              icon: const Icon(Ionicons.checkmark_outline),
            ),
          ),
        ),
      ),
    );
  }

  void _sendRecoveryCodeOperation() async {
    _recoveryCodeError = _recoveryCodeController.text.isEmpty
        ? 'لطفاً کد بازیابی را وارد کنید.'
        : null;
    _newPasswordError = UserInformationFormatCheck.checkPasswordFormat(
      _newPasswordController,
      'لطفاً رمز عبور جدید را وارد کنید.',
    );
    _repeatNewPasswordError = UserInformationFormatCheck.checkPasswordFormat(
      _repeatNewPasswordController,
      'لطفاً رمز عبور جدید را تکرار کنید.',
    );

    if ((_recoveryCodeError == null) &&
        (_newPasswordError == null) &&
        (_repeatNewPasswordError == null)) {
      var client = http.Client();
      try {
        http.Response response = await client.post(
          Uri.parse('https://kaghazsoti.uage.ir/api/forgot/step2'),
          body: {
            'mobile': _phoneNumberController.text,
            'code': _recoveryCodeController.text,
            'password': _newPasswordController.text,
            'password_confirmation': _repeatNewPasswordController.text,
          },
        );

        if (response.statusCode == 200) {
          customResponse = CustomResponse.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes))
                  as Map<String, dynamic>);

          Response<dynamic> _customDio = await Dio().post(
            'https://kaghazsoti.uage.ir/api/login',
            data: {
              'email': customResponse.data['email'],
              'password': _newPasswordController.text
            },
          );

          if (_customDio.statusCode == 200) {
            CustomResponse _customResponse =
                CustomResponse.fromJson(_customDio.data);

            tokenLogin.$ = _customResponse.data['token'];
            await sharedPreferences.setString(
                'tokenLogin', _customResponse.data['token']);
            await sharedPreferences.setBool('firstLogin', false);

            headers = {
              'Authorization': 'Bearer ${tokenLogin.of(context)}',
              'Accept': 'application/json',
              'client': 'api'
            };

            prepareToLoginApp();

            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(
                  context,
                  Ionicons.checkmark_done_outline,
                  'به کاغذ صوتی خوش آمدید.',
                  2,
                ),
              );

              Future.delayed(const Duration(seconds: 3), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersistentBottomNavigationBar(),
                  ),
                );
              });

              _recoveryCodeController = TextEditingController();
              _phoneNumberController = TextEditingController();
              _newPasswordController = TextEditingController();
              _repeatNewPasswordController = TextEditingController();
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              Ionicons.refresh_outline,
              'لطفاً دوباره امتحان کنید.',
              2,
            ),
          );
        }
      } finally {
        client.close();
      }
    }
  }

  Visibility _newPassword() {
    return Visibility(
      visible: !_sendRecoveryCode,
      child: Padding(
        padding: EdgeInsets.only(bottom: 0.5.h),
        child: TextField(
          obscureText: _obscureText,
          controller: _newPasswordController,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            helperText: 'رمز عبور جدید',
            hintText: 'لطفاً رمز عبور جدید را وارد کنید.',
            errorText: _newPasswordError,
            suffixIcon: const Icon(Ionicons.key),
          ),
          onChanged: (String text) {
            setState(() {
              _newPasswordError =
                  UserInformationFormatCheck.checkPasswordFormat(
                _newPasswordController,
                null,
              );
            });
          },
        ),
      ),
    );
  }

  Visibility _repeatNewPassword() {
    return Visibility(
      visible: !_sendRecoveryCode,
      child: Padding(
        padding: EdgeInsets.only(bottom: 0.5.h),
        child: TextField(
          obscureText: _obscureText,
          controller: _repeatNewPasswordController,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            helperText: 'تکرار رمز عبور جدید',
            hintText: 'لطفاً رمز عبور جدید را تکرار کنید.',
            errorText: _repeatNewPasswordError,
            suffixIcon: const Icon(Ionicons.refresh_outline),
          ),
          onChanged: (String text) {
            setState(() {
              _repeatNewPasswordError =
                  UserInformationFormatCheck.checkPasswordFormat(
                _repeatNewPasswordController,
                null,
              );
            });
          },
        ),
      ),
    );
  }
}
