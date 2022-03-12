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
  final TextEditingController _previousPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _repeatNewPasswordController =
      TextEditingController();

  late bool _newPasswordRegistered;

  @override
  void initState() {
    _newPasswordRegistered = false;

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

  Padding _previousPassword() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: false,
        controller: _previousPasswordController,
        keyboardType: TextInputType.visiblePassword,
        decoration: const InputDecoration(
          helperText: 'رمز عبور قبلی',
          errorText: false ? '' : null,
          suffixIcon: Icon(Ionicons.key_outline),
        ),
        onChanged: (String text) {},
      ),
    );
  }

  Padding _newPassword() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: false,
        controller: _newPasswordController,
        keyboardType: TextInputType.visiblePassword,
        decoration: const InputDecoration(
          helperText: 'رمز عبور جدید',
          errorText: false ? '' : null,
          suffixIcon: Icon(Ionicons.key),
        ),
        onChanged: (String text) {},
      ),
    );
  }

  Padding _repeatNewPassword() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: false,
        controller: _repeatNewPasswordController,
        keyboardType: TextInputType.visiblePassword,
        decoration: const InputDecoration(
          helperText: 'تکرار رمز عبور جدید',
          errorText: false ? '' : null,
          suffixIcon: Icon(Ionicons.refresh_outline),
        ),
        onChanged: (String text) {},
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
                _newPasswordRegistration();
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
      queryParameters: {
        'old_password': _previousPasswordController.text,
        'password': _newPasswordController.text,
        'password_confirmation': _repeatNewPasswordController.text
      },
      options: Options(headers: headers),
    );
    print(httpsResponse.data);
    CustomResponse customResponse = CustomResponse.fromJson(httpsResponse.data);

    setState(() {
      _newPasswordRegistered = customResponse.success;
    });
  }
}
