import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/controller/database.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/view/view_models/custom_text_field.dart';
import 'package:takfood_seller/view/view_models/player_bottom_navigation_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/custom_response.dart';
import '../../../controller/https.dart';

class PasswordSettingPage extends StatefulWidget {
  const PasswordSettingPage({Key? key}) : super(key: key);

  @override
  _PasswordSettingPageState createState() => _PasswordSettingPageState();
}

class _PasswordSettingPageState extends State<PasswordSettingPage> {
  TextEditingController _previousPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _repeatNewPasswordController = TextEditingController();

  late bool _newPasswordRegistered;
  late bool _obscureText;

  String? _previousPasswordError;
  String? _newPasswordError;
  String? _repeatNewPasswordError;

  @override
  void initState() {
    _newPasswordRegistered = false;
    _obscureText = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: const PlayerBottomNavigationBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('تغییر رمز'),
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
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _body() {
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
              _previousPassword(),
              _newPassword(),
              _repeatNewPassword(),
              _newPasswordRegistrationButton(),
            ],
          ),
        ),
      ),
    );
  }

  Row _permissionToObscureText() {
    return Row(
      children: [
        Flexible(
          child: Checkbox(
            onChanged: (bool? value) {
              setState(() {
                _obscureText = _obscureText ? false : true;
              });
            },
            value: _obscureText,
            activeColor: _obscureText
                ? Theme.of(context).primaryColor
                : Colors.grey,
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
                fontFamily: 'Vazir',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding _previousPassword() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: false,
        obscureText: _obscureText,
        controller: _previousPasswordController,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          helperText: 'رمز عبور قبلی',
          errorText: _previousPasswordError,
          suffixIcon: const Icon(Ionicons.key_outline),
        ),
        onChanged: (String text) {
          setState(() {
            _previousPasswordError = _checkPasswordFormat(_previousPasswordController);
          });
        },
      ),
    );
  }

  Padding _newPassword() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: false,
        obscureText: _obscureText,
        controller: _newPasswordController,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          helperText: 'رمز عبور جدید',
          errorText: _newPasswordError,
          suffixIcon: const Icon(Ionicons.key),
        ),
        onChanged: (String text) {
          setState(() {
            _newPasswordError = _checkPasswordFormat(_newPasswordController);
          });
        },
      ),
    );
  }

  Padding _repeatNewPassword() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: false,
        obscureText: _obscureText,
        controller: _repeatNewPasswordController,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          helperText: 'تکرار رمز عبور جدید',
          errorText: _repeatNewPasswordError,
          suffixIcon: const Icon(Ionicons.refresh_outline),
        ),
        onChanged: (String text) {
          setState(() {
            _repeatNewPasswordError = _checkPasswordFormat(_repeatNewPasswordController);
          });
        },
      ),
    );
  }

  Padding _newPasswordRegistrationButton() {
    return Padding(
      padding: EdgeInsets.only(top: 5.0.h),
      child: Center(
        child: SizedBox(
          width: 100.0.w - (2 * 5.0.w),
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                if(_newPasswordController.text != _repeatNewPasswordController.text) {
                  _repeatNewPasswordError = 'لطفاً رمز عبور جدید را تکرار کنید.';
                } else {
                  _newPasswordRegistration();
                }
              });
            },
            label: Text(_newPasswordRegistered
                ? 'رمز عبور جدید ثبت شد'
                : 'ثبت رمز عبور جدید'),
            icon: Icon(_newPasswordRegistered
                ? Ionicons.checkmark_done_outline
                : Ionicons.checkmark_outline),
          ),
        ),
      ),
    );
  }

  void _newPasswordRegistration() async {
    Response<dynamic> httpsResponse = await Https.dio.post(
      'dashboard/user/password',
      data: {
        'old_password': _previousPasswordController.text,
        'password': _newPasswordController.text,
        'password_confirmation': _repeatNewPasswordController.text
      },
      options: Options(headers: headers),
    );

    print(1);
    CustomResponse customResponse = CustomResponse.fromJson(httpsResponse.data);
    print(customResponse.message);


    setState(() {
      // if() {
      //
      // } else {
      //   _newPasswordRegistered = customResponse.success;
      //
      //   _previousPasswordController = TextEditingController();
      //   _newPasswordController = TextEditingController();
      //   _repeatNewPasswordController = TextEditingController();
      // }
    });
  }

  String? _checkPasswordFormat(TextEditingController textEditingController) {
    String? _errorText;
    if((textEditingController.text.isEmpty) || (textEditingController.text.length == 9)) {
      _errorText = null;
    } else if(textEditingController.text.length < 10) {
      _errorText = 'رمز عبور نباید کمتر از 9 کاراکتر باشد.';
    } else if(textEditingController.text.contains(' ')) {
      _errorText = 'رمز عبور نباید شامل جای خالی باشد.';
    }

    return _errorText;
  }
}
