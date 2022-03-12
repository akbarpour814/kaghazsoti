import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/view/view_models/custom_text_field.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _firstAndLastNameController = TextEditingController();
  final TextEditingController _nationalCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  late bool _login;

  @override
  void initState() {
    _login = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
            if(!_login) {
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
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: TextField(
                  readOnly: _login,
                  controller: _firstAndLastNameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    helperText: 'نام و نام خانوادگی',
                    errorText: false ? '' : null,
                    suffixIcon: Icon(
                        Ionicons.person_outline
                    ),
                  ),
                  onChanged: (String text) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: TextField(
                  readOnly: _login,
                  controller: _nationalCodeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    helperText: 'کد ملی',
                    errorText: false ? '' : null,
                    suffixIcon: Icon(
                        Ionicons.person
                    ),
                  ),
                  onChanged: (String text) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: TextField(
                  readOnly: _login,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    helperText: 'ایمیل',
                    errorText: false ? '' : null,
                    suffixIcon: Icon(
                        Ionicons.mail_outline
                    ),
                  ),
                  onChanged: (String text) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: TextField(
                  readOnly: _login,
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    helperText: 'تلفن همراه',
                    errorText: false ? '' : null,
                    suffixIcon: Icon(
                        Ionicons.phone_portrait_outline
                    ),
                  ),
                  onChanged: (String text) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: TextField(
                  readOnly: _login,
                  controller: _addressController,
                  keyboardType: TextInputType.streetAddress,
                  decoration: const InputDecoration(
                    helperText: 'آدرس',
                    errorText: false ? '' : null,
                    suffixIcon: Icon(
                        Ionicons.location_outline
                    ),
                  ),
                  onChanged: (String text) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0.h),
                child: SizedBox(
                  width:  100.0.w - (2 * 5.0.w),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      setState(() {
                        _login = _login ? false : true;
                      });

                      await sharedPreferences.setBool('firstLogin', false);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return SafeArea(
                              child: PersistentTabView(
                                context,
                                controller: persistentTabController,
                                screens: pages,
                                items: items,
                                navBarStyle: NavBarStyle.style18,
                              ),
                            );
                          },
                        ),
                      );
                    },
                    label: Text(_login ? 'خوش آمدید' : 'ثبت اطلاعات'),
                    icon: Icon(_login ? Ionicons.checkmark_done_outline : Ionicons.checkmark_outline),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
