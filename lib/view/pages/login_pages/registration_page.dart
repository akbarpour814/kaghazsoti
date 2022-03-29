import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:sizer/sizer.dart';
import '../../../controller/custom_response.dart';
import '../../../controller/database.dart';
import '../../../controller/custom_dio.dart';
import '../../view_models/custom_snack_bar.dart';
import '/controller/functions_for_checking_user_information_format.dart';

import '../../../main.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _firstAndLastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repeatPasswordController = TextEditingController();

  String? _firstAndLastNameError;
  String? _emailError;
  String? _phoneNumberError;
  String? _passwordError;
  String? _repeatPasswordError;

  late bool _registeredInformation;
  late bool _obscureText;

  @override
  void initState() {
    _registeredInformation = false;
    _obscureText = true;

    super.initState();
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
      title: const Text('ثبت نام'),
      automaticallyImplyLeading: false,
      leading: const Icon(
        Ionicons.log_in_outline,
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
            if (!_registeredInformation) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  Widget _body() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 5.0.h),
                child: _permissionToObscureText(),
              ),
              _firstAndLastName(),
              _email(),
              _phoneNumber(),
              _password(),
              _repeatPassword(),
              _informationRegistrationButton(),
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
            activeColor:
            _obscureText ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ),
        Flexible(
          child: RichText(
            text: TextSpan(
              text: _obscureText ? 'عدم نمایش رمز' : 'نمایش رمز',
              style: TextStyle(
                color:
                _obscureText ? Theme.of(context).primaryColor : Colors.grey,
                fontFamily: 'Vazir',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding _firstAndLastName() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: _registeredInformation,
        controller: _firstAndLastNameController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          helperText: 'نام و نام خانوادگی',
          hintText: 'لطفاً نام و نام خانوادگی خود را وارد کنید.',
          errorText: _firstAndLastNameError,
          suffixIcon: const Icon(Ionicons.person_outline),
        ),
        onChanged: (String text) {
          setState(() {
            _firstAndLastNameError = UserInformationFormatCheck.checkFirstAndLastNameFormat(_firstAndLastNameController, null);
          });
        },
      ),
    );
  }

  Padding _email() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: _registeredInformation,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          helperText: 'ایمیل',
          hintText: 'لطفاً ایمیل خود را وارد کنید.',
          errorText: _emailError,
          suffixIcon: const Icon(Ionicons.mail_outline),
        ),
        onChanged: (String text) {
          setState(() {
            _emailError = UserInformationFormatCheck.checkEmailFormat(_emailController, null);
          });
        },
      ),
    );
  }

  Padding _phoneNumber() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: _registeredInformation,
        controller: _phoneNumberController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          helperText: 'تلفن همراه',
          hintText: 'لطفاً شماره تلفن همراه خود را وارد کنید.',
          errorText: _phoneNumberError,
          suffixIcon: const Icon(Ionicons.phone_portrait_outline),
        ),
        onChanged: (String text) {
          setState(() {
            _phoneNumberError = UserInformationFormatCheck.checkPhoneNumberFormat(_phoneNumberController, null);
          });
        },
      ),
    );
  }

  Padding _password() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: false,
        obscureText: _obscureText,
        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          helperText: 'رمز عبور',
          hintText: 'لطفاً رمز عبور را وارد کنید.',
          errorText: _passwordError,
          suffixIcon: const Icon(Ionicons.key),
        ),
        onChanged: (String text) {
          setState(() {
             _passwordError = UserInformationFormatCheck.checkPasswordFormat(_passwordController, null);
          });
        },
      ),
    );
  }

  Padding _repeatPassword() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: false,
        obscureText: _obscureText,
        controller: _repeatPasswordController,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          helperText: 'تکرار رمز عبور',
          hintText: 'لطفاً رمز عبور را تکرار کنید.',
          errorText: _repeatPasswordError,
          suffixIcon: const Icon(Ionicons.refresh_outline),
        ),
        onChanged: (String text) {
          setState(() {
             _repeatPasswordError = UserInformationFormatCheck.checkPasswordFormat(_repeatPasswordController, null);
          });
        },
      ),
    );
  }

  Padding _informationRegistrationButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0.h),
      child: SizedBox(
        width: 100.0.w - (2 * 5.0.w),
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              if(_passwordController.text != _repeatPasswordController.text) {
                _repeatPasswordError = 'لطفاً رمز عبور جدید را تکرار کنید.';
              } else {
                _informationRegistration();
              }
            });
          },
          label: const Text('ثبت اطلاعات'),
          icon: const Icon(Ionicons.checkmark_outline),
        ),
      ),
    );
  }

  void _informationRegistration() async {
    _firstAndLastNameError = UserInformationFormatCheck.checkFirstAndLastNameFormat(_firstAndLastNameController, 'لطفاً نام و نام خوانوادگی خود را وارد کنید.',);
    _emailError = UserInformationFormatCheck.checkEmailFormat(_emailController, 'لطفاً ایمیل خود را وارد کنید.',);
    _phoneNumberError= UserInformationFormatCheck.checkPhoneNumberFormat(_phoneNumberController, 'لطفاً تلفن همراه خود را تکرار کنید.',);
    _passwordError = UserInformationFormatCheck.checkPasswordFormat(_passwordController, 'لطفاً رمز عبور را وارد کنید.',);
    _repeatPasswordError = UserInformationFormatCheck.checkPasswordFormat(_repeatPasswordController, 'لطفاً رمز عبور را تکرار کنید.',);

    if(_firstAndLastNameError == null && _emailError == null && _phoneNumberError == null && _passwordError == null && _repeatPasswordError == null) {
      Response<dynamic> httpsResponse = await CustomDio.dio.post(
        'register',
        data: {
          'name': _firstAndLastNameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'confirm_password': _repeatPasswordController.text
        },
        options: Options(headers: headers),
      );

      CustomResponse customResponse = CustomResponse.fromJson(httpsResponse.data);

      setState(() {
        _registeredInformation = customResponse.success;

        if (_registeredInformation) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(context, Ionicons.checkmark_done_outline, 'خوش آمدید.',),
          );
        }

        _firstAndLastNameController = TextEditingController();
        _emailController = TextEditingController();
        _phoneNumberController = TextEditingController();
        _passwordController = TextEditingController();
        _repeatPasswordController = TextEditingController();
      });
    }
  }
}
