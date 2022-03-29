import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/view/view_models/custom_text_field.dart';
import 'package:sizer/sizer.dart';

import '../../../main.dart';

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({Key? key}) : super(key: key);

  @override
  _PasswordRecoveryPageState createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  final TextEditingController _emailOrPhoneNumberController = TextEditingController();
  final TextEditingController _recoveryCodeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  late bool _sendRecoveryCode;
  late bool _emailOrPhoneNumber;


  @override
  void initState() {
    _sendRecoveryCode = false;
    _emailOrPhoneNumber = true;

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
            if(!_sendRecoveryCode) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Checkbox(
                      onChanged: (bool? value) {
                        setState(() {
                          if(!_sendRecoveryCode) {
                            _emailOrPhoneNumber = _emailOrPhoneNumber ? false : true;
                          }
                        });
                      },
                      value: true,
                      activeColor: _emailOrPhoneNumber ? Theme.of(context).primaryColor : Colors.grey,
                    ),
                  ),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        text: 'ایمیل ',
                        style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: fontFamily,),
                        children: const <TextSpan>[
                          TextSpan(text: 'یا ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),),
                          TextSpan(text: 'تلفن همراه', style: TextStyle(color: Colors.grey,),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0.h),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 0.5.h),
                      child: TextField(
                        readOnly: _sendRecoveryCode,
                        controller: _emailOrPhoneNumberController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          helperText: _emailOrPhoneNumber ? 'ایمیل' : 'تلفن همراه',
                          hintText: 'لطفاً ${_emailOrPhoneNumber ? 'ایمیل' : 'تلفن همراه'} خود را وارد کنید.',
                          errorText: false ? '' : null,
                          suffixIcon: Icon(
                              _emailOrPhoneNumber ? Ionicons.mail_outline : Ionicons.phone_portrait_outline,
                          ),
                        ),
                        onChanged: (String text) {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 0.5.h),
                      child: TextField(
                        readOnly: _sendRecoveryCode,
                        controller: _newPasswordController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          helperText: 'رمز عبور جدید',
                          hintText: 'لطفاً رمز عبور جدید را وارد کنید.',
                          errorText: false ? '' : null,
                          suffixIcon: Icon(
                            Ionicons.key_outline
                          ),
                        ),
                        onChanged: (String text) {},
                      ),
                    ),
                    Visibility(
                      visible: _sendRecoveryCode,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 0.5.h),
                        child: TextField(
                          readOnly: false,
                          controller: _recoveryCodeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            helperText: 'کد بازیابی',
                            hintText: 'لطفاً کد بازیابی را وارد کنید.',
                            errorText: false ? '' : null,
                            suffixIcon: Icon(
                                Ionicons.code_working_outline
                            ),
                          ),
                          onChanged: (String text) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width:  100.0.w - (2 * 5.0.w),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _sendRecoveryCode = _sendRecoveryCode ? false : true;
                    });
                  },
                  label: Text(_sendRecoveryCode ? 'خوش آمدید' : 'ارسال کد بازیابی'),
                  icon: Icon(_sendRecoveryCode ? Ionicons.checkmark_done_outline : Ionicons.checkmark_outline),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
