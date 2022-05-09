import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaghaze_souti/controller/load_data_from_api.dart';
import '../../../controller/internet_connection.dart';
import '../../view_models/no_internet_connection.dart';
import '/view/view_models/custom_circular_progress_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/custom_dio.dart';
import '../../../controller/functions_for_checking_user_information_format.dart';
import '../../../main.dart';
import '../../view_models/custom_snack_bar.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with InternetConnection, LoadDataFromAPI {
  late TextEditingController _firstAndLastNameController;
  String? _firstAndLastNameError;
  late TextEditingController _emailController;
  String? _emailError;
  late TextEditingController _phoneNumberController;
  String? _phoneNumberError;
  late bool _permissionToEdit;
  late bool _registeredInformation;

  @override
  void initState() {
    super.initState();

    _permissionToEdit = false;
    _registeredInformation = false;
  }

  Future _initUserInformation() async {
    customDio = await CustomDio.dio.get('user');

    if (customDio.statusCode == 200) {
      setState(() {
        _firstAndLastNameController =
            TextEditingController(text: customDio.data['name']);
        _emailController =
            TextEditingController(text: customDio.data['email']);
        _phoneNumberController =
            TextEditingController(text: customDio.data['username']);

        dataIsLoading = false;
      });
    }

    return customDio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: playerBottomNavigationBar,
    );
  }

  AppBar _appBar() {
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
            print(MediaQuery.of(context).size.height);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _body() {
    if (dataIsLoading) {
      return FutureBuilder(
        future: _initUserInformation(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return _innerBody();
          } else {
            return Center(
              child: CustomCircularProgressIndicator(

              ),
            );
          }
        },
      );
    } else {
      return _innerBody();
    }
  }

  Widget _innerBody() {
    if (connectionStatus == ConnectivityResult.none) {
      setState(() {
        dataIsLoading = true;
      });

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
              children: [
                _permissionToEditCheckbox(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0.h),
                  child: Column(
                    children: [
                      _firstAndLastName(),
                      _email(),
                      _phoneNumber(),
                    ],
                  ),
                ),
                _informationRegistrationButton(),
              ],
            ),
          ),
        ),
      );
    }
  }

  Row _permissionToEditCheckbox() {
    return Row(
      children: [
        Flexible(
          child: Checkbox(
            onChanged: (bool? value) {
              setState(() {
                if (!_registeredInformation) {
                  _permissionToEdit = _permissionToEdit ? false : true;

                  dataIsLoading = false;
                }
              });
            },
            value: _permissionToEdit,
            activeColor: _permissionToEdit
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
        ),
        Flexible(
          child: RichText(
            text: TextSpan(
              text: 'ویرایش اطلاعات',
              style: TextStyle(
                color: _permissionToEdit
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

  Padding _firstAndLastName() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: !(_permissionToEdit ^ _registeredInformation),
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
            _firstAndLastNameError =
                UserInformationFormatCheck.checkFirstAndLastNameFormat(
              _firstAndLastNameController,
              null,
            );
          });
        },
      ),
    );
  }

  Padding _email() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: !(_permissionToEdit ^ _registeredInformation),
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
            _emailError = UserInformationFormatCheck.checkEmailFormat(
              _emailController,
              null,
            );
          });
        },
      ),
    );
  }

  Padding _phoneNumber() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: !(_permissionToEdit ^ _registeredInformation),
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
    );
  }

  Visibility _informationRegistrationButton() {
    return Visibility(
      visible: _permissionToEdit,
      child: SizedBox(
        width: 100.0.w - (2 * 5.0.w),
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _informationRegistration();
            });
          },
          label: Text(
            _registeredInformation ? 'اطلاعات ویرایش شد' : 'ویرایش اطلاعات',
          ),
          icon: Icon(
            _registeredInformation
                ? Ionicons.checkmark_done_outline
                : Ionicons.checkmark_outline,
          ),
        ),
      ),
    );
  }

  void _informationRegistration() async {
    _firstAndLastNameError =
        UserInformationFormatCheck.checkFirstAndLastNameFormat(
      _firstAndLastNameController,
      'لطفاً نام و نام خوانوادگی خود را وارد کنید.',
    );
    _emailError = UserInformationFormatCheck.checkEmailFormat(
      _emailController,
      'لطفاً ایمیل خود را وارد کنید.',
    );
    _phoneNumberError = UserInformationFormatCheck.checkPhoneNumberFormat(
      _phoneNumberController,
      'لطفاً شماره تلفن همراه خود را وارد کنید.',
    );

    if (_firstAndLastNameError == null &&
        _emailError == null &&
        _phoneNumberError == null) {
      _permissionToEdit = false;
      _registeredInformation = false;

      customDio = await CustomDio.dio.post(
        'user',
        data: {
          'name': _firstAndLastNameController.text,
          'email': _emailController.text,
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
}
