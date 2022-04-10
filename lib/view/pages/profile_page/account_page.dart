import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import '../../view_models/no_internet_connection.dart';
import '/view/view_models/custom_circular_progress_indicator.dart';
import '/view/view_models/custom_text_field.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../controller/functions_for_checking_user_information_format.dart';
import '../../../main.dart';
import '../../view_models/custom_snack_bar.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late  bool _internetConnectionChecker;
  late Response<dynamic> _customDio;
  late TextEditingController _firstAndLastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;

  String? _firstAndLastNameError;
  String? _emailError;
  String? _phoneNumberError;

  late bool _dataIsLoading;
  late bool _permissionToEdit;
  late bool _registeredInformation;


  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    _dataIsLoading = true;
    _permissionToEdit = false;
    _registeredInformation = false;

    super.initState();

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future _initUserInformation() async {
    _customDio =
        await CustomDio.dio.get('user');

    if (_customDio.statusCode == 200) {
      _firstAndLastNameController =
          TextEditingController(text: _customDio.data['name']);
      _emailController = TextEditingController(text: _customDio.data['email']);
      _phoneNumberController =
          TextEditingController(text: _customDio.data['mobile']);
    }

    return _customDio;
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
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _body() {
    return _dataIsLoading
        ? FutureBuilder(
      builder:
          (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? _innerBody()
            : Center(child: CustomCircularProgressIndicator(message: 'لطفاً شکیبا باشید.'));
      },
      future: _initUserInformation(),
    )
        : _innerBody();
  }

  Widget _innerBody() {

    if(_connectionStatus == ConnectivityResult.none) {
      // setState(() {
      //   _dataIsLoading = true;
      // });

      return const Center(child: NoInternetConnection(),);
    } else {

      return Padding(
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

                  _dataIsLoading = false;
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
                    _firstAndLastNameController, null,);
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
                _emailController, null,);
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
              _registeredInformation ? 'اطلاعات ویرایش شد' : 'ویرایش اطلاعات'),
          icon: Icon(_registeredInformation
              ? Ionicons.checkmark_done_outline
              : Ionicons.checkmark_outline),
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

      _customDio = await CustomDio.dio.post(
        'user',
        data: {
          'name': _firstAndLastNameController.text,
          'email': _emailController.text,
          'mobile': _phoneNumberController.text,
        },
      );

      setState(() {
        if (_customDio.statusCode == 200) {
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
