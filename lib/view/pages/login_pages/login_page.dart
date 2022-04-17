import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaghaze_souti/controller/internet_connection.dart';
import 'package:kaghaze_souti/controller/load_data_from_api.dart';
import '../../../controller/prepare_to_login_app.dart';
import '../../view_models/no_internet_connection.dart';
import '/controller/custom_response.dart';
import '/view/pages/login_pages/password_recovery_page.dart';
import '/view/pages/login_pages/registration_page.dart';
import '/view/pages/login_pages/splash_page.dart';
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

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin, InternetConnection, LoadDataFromAPI {
  late TextEditingController _emailOrPhoneNumberController;
  String? _emailOrPhoneNumberError;
  late TextEditingController _passwordController;
  String? _passwordError;
  late bool _loginPermission;
  late bool _emailOrPhoneNumber;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();

    _emailOrPhoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
    _loginPermission = false;
    _emailOrPhoneNumber = true;
    _obscureText = true;
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _appTitle(),
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

  Padding _emailOrPhoneNumberTextField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: _loginPermission,
        controller: _emailOrPhoneNumberController,
        keyboardType: TextInputType.emailAddress,
        maxLength: _emailOrPhoneNumber ? null : 11,
        decoration: InputDecoration(
          helperText: _emailOrPhoneNumber ? 'ایمیل' : 'تلفن همراه',
          hintText:
              'لطفاً ${_emailOrPhoneNumber ? 'ایمیل' : 'شماره تلفن همراه'} خود را وارد کنید.',
          errorText: _emailOrPhoneNumberError,
          suffixIcon: Icon(
            _emailOrPhoneNumber
                ? Ionicons.mail_outline
                : Ionicons.phone_portrait_outline,
          ),
        ),
        onChanged: (String text) {
          setState(() {
            _emailOrPhoneNumberError =
                UserInformationFormatCheck.checkEmailFormat(
              _emailOrPhoneNumberController,
              null,
            );
            ;
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
        obscureText: _obscureText,
        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          helperText: 'رمز عبور',
          hintText: 'لطفاً رمز عبور را وارد کنید.',
          errorText: _passwordError,
          suffixIcon: InkWell(
            onTap: () {
              setState(() {
                _obscureText = _obscureText ? false : true;
              });
            },
            child: Icon(
                _obscureText ? Ionicons.eye_off_outline : Ionicons.eye_outline),
          ),
        ),
        onChanged: (String text) {
          setState(() {
            _passwordError = UserInformationFormatCheck.checkPasswordFormat(
              _passwordController,
              null,
            );
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
        label: const Text('بررسی اطلاعات برای ورود'),
        icon: const Icon(Ionicons.checkmark_outline),
      ),
    );
  }

  void _informationConfirm() async {
    _emailOrPhoneNumberError = UserInformationFormatCheck.checkEmailFormat(
      _emailOrPhoneNumberController,
      'لطفاً ${_emailOrPhoneNumber ? 'ایمیل' : 'شماره تلفن همراه'} خود را وارد کنید.',
    );
    _passwordError = UserInformationFormatCheck.checkPasswordFormat(
      _passwordController,
      'لطفاً رمز عبور را وارد کنید.',
    );

    if ((_emailOrPhoneNumberError == null) && (_passwordError == null)) {
      try {
        customDio = await Dio().post(
          'https://kaghazsoti.uage.ir/api/login',
          data: {
            'email': _emailOrPhoneNumberController.text,
            'password': _passwordController.text
          },
        );

        if (customDio.statusCode == 200) {
          customResponse = CustomResponse.fromJson(customDio.data);

          _loginPermission = true;

          if (customResponse.success) {
            _emailOrPhoneNumberError = null;
            _passwordError = null;

            await sharedPreferences.setString(
                'tokenLogin', customResponse.data['token']);
            await sharedPreferences.setBool('firstLogin', false);
            setState(() {
              tokenLogin.$ = customResponse.data['token'];

              headers = {
                'Authorization': 'Bearer ${tokenLogin.of(context)}',
                'Accept': 'application/json',
                'client': 'api'
              };
            });

            prepareToLoginApp();

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
            setState(() {
              _emailOrPhoneNumberError = 'کاربری با ${_emailOrPhoneNumber ? 'ایمیل' : 'شماره تلفن همراه'} وارد شده یافت نشد.';
              _passwordError = 'رمز عبور وارد شده درست نمی باشد.';

              _loginPermission = false;
            });
          }
        }
      } catch (e) {
        setState(() {
          _emailOrPhoneNumberError = 'کاربری با ${_emailOrPhoneNumber ? 'ایمیل' : 'شماره تلفن همراه'} وارد شده یافت نشد.';
          _passwordError = 'رمز عبور وارد شده درست نمی باشد.';

          _loginPermission = false;
        });
      }
    }
  }

  SizedBox _forgotPasswordButton() {
    return SizedBox(
      width: 50.0.w,
      child: TextButton(
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
      ),
    );
  }

  SizedBox _registrationButton() {
    return SizedBox(
      width: 50.0.w,
      child: TextButton(
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
      ),
    );
  }
}
