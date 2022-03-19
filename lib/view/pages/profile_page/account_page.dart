import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/model/user.dart';
import 'package:takfood_seller/view/view_models/custom_text_field.dart';
import 'package:takfood_seller/view/view_models/player_bottom_navigation_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/database.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController _firstAndLastNameController =
      TextEditingController(text: database.user.firstAndLastName);
  final TextEditingController _nationalCodeController =
      TextEditingController(text: database.user.nationalCode.toString());
  final TextEditingController _emailController =
      TextEditingController(text: database.user.email);
  final TextEditingController _phoneNumberController =
      TextEditingController(text: database.user.phoneNumber.toString());
  final TextEditingController _addressController =
      TextEditingController(text: database.user.address);

  late bool _permissionToEdit;
  late bool _recordNewInformation;

  @override
  void initState() {
    _permissionToEdit = false;
    _recordNewInformation = false;

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
                    _nationalCode(),
                    _email(),
                    _phoneNumber(),
                    _address(),
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

  Row _permissionToEditCheckbox() {
    return Row(
      children: [
        Flexible(
          child: Checkbox(
            onChanged: (bool? value) {
              setState(() {
                if (!_recordNewInformation) {
                  _permissionToEdit = _permissionToEdit ? false : true;
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
        readOnly: !(_permissionToEdit ^ _recordNewInformation),
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
    );
  }

  Padding _nationalCode() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: !(_permissionToEdit ^ _recordNewInformation),
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
    );
  }

  Padding _email() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: !(_permissionToEdit ^ _recordNewInformation),
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
    );
  }

  Padding _phoneNumber() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: !(_permissionToEdit ^ _recordNewInformation),
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
    );
  }

  Padding _address() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: !(_permissionToEdit ^ _recordNewInformation),
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
              _recordNewInformation = _recordNewInformation ? false : true;
            });
          },
          label: Text(
              _recordNewInformation ? 'اطلاعات ویرایش شد' : 'ویرایش اطلاعات'),
          icon: Icon(_recordNewInformation
              ? Ionicons.checkmark_done_outline
              : Ionicons.checkmark_outline),
        ),
      ),
    );
  }


}
