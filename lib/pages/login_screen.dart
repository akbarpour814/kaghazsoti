import 'package:flutter/material.dart';
import 'package:kaghazsoti/animations/singin_animation.dart';
import 'package:kaghazsoti/components/form_container.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:kaghazsoti/models/auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();

}

class LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _loginButtonController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late String _emailValue;
  late String _passwordValue;

  emailOnSaved(String? value) {
    _emailValue = value!;
  }

  passwordOnSaved(String? value) {
    _passwordValue = value!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginButtonController = AnimationController(vsync: this , duration: Duration(milliseconds: 3000));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _loginButtonController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    timeDilation = .4;
    var page = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient:  LinearGradient(
              colors: <Color>[
                Color(0xff2c5364),
                Color(0xff0f2027)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Opacity(
              opacity: .1,
              child: Container(
                width: page.width,
                height: page.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/icon-background.png"),
                        repeat: ImageRepeat.repeat
                    )
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FormContainer(formKey: _formKey, passwordOnSaved: passwordOnSaved, emailOnSaved: emailOnSaved,),
                FlatButton(
                  onPressed: null,
                  child: Text(
                    "آیا هیچ اکانتی ندارید؟ عضویت",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                      color: Colors.white,
                      fontSize: 14
                    ),
                  ))
              ],
            ),
            GestureDetector(
              onTap: () async {
                if(_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  sendDataToServer();
                }
              },
              child: SingInAnimation(
                controller: _loginButtonController.view,
              ),
            )
          ],
        ),
      ) ,
    );
  }

  sendDataToServer() async{
    await _loginButtonController.animateTo(0.150);
    var response = await (new Auth()).login({"email": _emailValue, "password":_passwordValue});
    print(response['message']);
    if( response['success'] == true ) {
      //
      await _loginButtonController.forward();
      Navigator.pushReplacementNamed(context, "/");
    } else {
      await _loginButtonController.reverse();
      _scaffoldKey.currentState?.showSnackBar(
          SnackBar(
              content: Text(
                response['message'],
                style: TextStyle(fontFamily: 'Vazir'),
              )
          )
      );
    }
  }

}