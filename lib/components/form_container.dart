import 'package:flutter/material.dart';
import 'package:kaghazsoti/components/input_fileds.dart';
import 'package:validators/validators.dart';

class FormContainer extends StatelessWidget {
  late final formKey;
  final emailOnSaved;
  final passwordOnSaved;

  FormContainer({ @required this.formKey, required this.emailOnSaved, required this.passwordOnSaved });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Form(
            key: formKey,
            child: Column(
              // key: formKey,
              children: <Widget>[
                InputFieldArea(
                  hint: "ایمیل کاربری",
                  obscure: false,
                  icon : Icons.person_outline,
                  validator: (String? value){
                    if(!isEmail(value!)){
                      return "ایمیل اعتبار ندارد";
                    }
                  },
                  onSave: emailOnSaved,
                ),
                InputFieldArea(
                  hint: "پسورد",
                  obscure: true,
                  icon: Icons.lock_open,
                  validator: (String? value){
                    if(value!.length < 4){
                      return "اعتبار ندارد";
                    }
                  },
                  onSave: passwordOnSaved,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}