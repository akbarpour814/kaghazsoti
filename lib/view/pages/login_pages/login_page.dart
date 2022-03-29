import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/controller/custom_dio.dart';
import 'package:takfood_seller/controller/custom_response.dart';
import 'package:takfood_seller/view/pages/login_pages/password_recovery_page.dart';
import 'package:takfood_seller/view/pages/login_pages/registration_page.dart';
import 'package:takfood_seller/view/view_models/custom_text_field.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/functions_for_checking_user_information_format.dart';
import '../../../main.dart';
import '../../view_models/custom_snack_bar.dart';
import '../../view_models/persistent_bottom_navigation_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late  bool _internetConnectionChecker;
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  final TextEditingController _emailOrPhoneNumberController = TextEditingController();
  String? _emailOrPhoneNumberError;
  final TextEditingController _passwordController = TextEditingController();
  String? _passwordError;

  late bool _loginPermission;
  late bool _emailOrPhoneNumber;

  late CustomResponse _informationConfirmResponse;

  @override
  void initState() {
    _loginPermission = false;
    _emailOrPhoneNumber = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _appTitle(),
              //_emailOrPhoneNumberSelect(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0.h),
                child: Column(
                  children: [
                    _emailOrPhoneNumberTextField(),
                    _password(),
                  ],
                ),
              ),
              _informationConfirmButton(),
              Container(
                margin: EdgeInsets.only(top: 15.0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _forgotPasswordButton(),
                    _registrationButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _appTitle() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0.h),
      child: Center(
        child: Text(
          'ورود به کاغذ صوتی',
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  Row _emailOrPhoneNumberSelect() {
    return Row(
      children: [
        Flexible(
          child: Checkbox(
            onChanged: (bool? value) {
              setState(() {
                if (!_loginPermission) {
                  _emailOrPhoneNumber = _emailOrPhoneNumber ? false : true;
                }
              });
            },
            value: true,
            activeColor: _emailOrPhoneNumber
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
        ),
        Flexible(
          child: RichText(
            text: TextSpan(
              text: 'ایمیل ',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: fontFamily,
              ),
              children: const <TextSpan>[
                TextSpan(
                  text: 'یا ',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'تلفن همراه',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding _emailOrPhoneNumberTextField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: _loginPermission,
        controller: _emailOrPhoneNumberController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          helperText: _emailOrPhoneNumber ? 'ایمیل' : 'تلفن همراه',
          hintText: 'لطفاً ${_emailOrPhoneNumber ? 'ایمیل' : 'شماره تلفن همراه'} خود را وارد کنید.',
          errorText: _emailOrPhoneNumberError,
          suffixIcon: Icon(
            _emailOrPhoneNumber
                ? Ionicons.mail_outline
                : Ionicons.phone_portrait_outline,
          ),
        ),
        onChanged: (String text) {
          setState(() {
            _emailOrPhoneNumberError = null;
          });
        },
      ),
    );
  }

  Padding _password() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: _loginPermission,
        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          helperText: 'رمز عبور',
          hintText: 'لطفاً رمز عبور را وارد کنید.',
          errorText: _passwordError,
          suffixIcon: const Icon(Ionicons.key_outline),
        ),
        onChanged: (String text) {
          setState(() {
            _passwordError = null;
          });
        },
      ),
    );
  }

  SizedBox _informationConfirmButton() {
    return SizedBox(
      width: 100.0.w - (2 * 5.0.w),
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _informationConfirm();
          });
        },
        label: Text(_loginPermission ? _informationConfirmResponse.success ? 'خوش آمدید' : '' : 'بررسی اطلاعات برای ورود'),
        icon: Icon(_loginPermission
            ? Ionicons.checkmark_done_outline
            : Ionicons.checkmark_outline),
      ),
    );
  }

  void _informationConfirm() async {
    _emailOrPhoneNumberError = UserInformationFormatCheck.checkEmailFormat(
      _emailOrPhoneNumberController,
        'لطفاً ${_emailOrPhoneNumber ? 'ایمیل' : 'شماره تلفن همراه'} خود را وارد کنید.',
    );

    _passwordError = UserInformationFormatCheck.checkPasswordFormat(_passwordController, 'لطفاً رمز عبور را وارد کنید.',);

    if((_emailOrPhoneNumberError == null) && (_passwordError == null)) {
      _customDio = await CustomDio.dio.post('login', data: {'email' : _emailOrPhoneNumberController.text, 'password' : _passwordController.text},);

      if(_customDio.statusCode == 200) {
        _customResponse = CustomResponse.fromJson(_customDio.data);

        _loginPermission = true;

        if(_customResponse.success) {
          _emailOrPhoneNumberError = null;
          _passwordError = null;

          tokenLogin = _customResponse.data['token'];
          await sharedPreferences.setString('tokenLogin', _customResponse.data['token']);
          await sharedPreferences.setBool('firstLogin', false);

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

        } else {
          _emailOrPhoneNumberError = 'کاربری با ایمیل وارد شده یافت نشد.';
          _passwordError = 'رمز عبور وارد شده درست نمی باشد.';

          _loginPermission = false;
        }
      }
    }


    

  }

  TextButton _forgotPasswordButton() {
    return TextButton(
      onPressed: () {
        if (!_loginPermission) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const PasswordRecoveryPage();
              },
            ),
          );
        }
      },
      child: Text(
        'رمز عبورم را فراموش کرده ام.',
        style: Theme.of(context)
            .textTheme
            .caption!
            .copyWith(color: Theme.of(context).primaryColor),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  TextButton _registrationButton() {
    return TextButton(
      onPressed: () {
        if (!_loginPermission) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const RegistrationPage();
              },
            ),
          );
        }
      },
      child: Text(
        'ثبت نام نکرده ام.',
        style: Theme.of(context)
            .textTheme
            .caption!
            .copyWith(color: Theme.of(context).primaryColor),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
