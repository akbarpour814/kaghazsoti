import 'package:flutter/material.dart';

class SingInAnimation extends StatelessWidget {
  final Animation<double> controller;
  final Animation<double> buttonSqueezeAnimation;
  final Animation<double> buttonZoomOut;

  SingInAnimation({ required this.controller }) :

      buttonSqueezeAnimation = Tween(
        begin: 280.0,
        end: 60.0
      ).animate(
        CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.150)
        )
      ),

      buttonZoomOut = Tween(
          begin: 70.0,
          end: 1000.0
      ).animate(
          CurvedAnimation(
              parent: controller,
              curve: Interval(0.550, 0.999 , curve: Curves.bounceOut)
          )
      );

  Widget _animationBuilder(BuildContext context , Widget child) {
    return buttonZoomOut.value <= 300
        ?  Container(
              margin: const EdgeInsets.only(bottom: 30),
              width: buttonZoomOut.value == 70
                    ? buttonSqueezeAnimation.value
                    : buttonZoomOut.value,
              height: buttonZoomOut.value == 70
                  ? 60
                  : buttonZoomOut.value,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Color(0xff075E54),
                  borderRadius: buttonZoomOut.value < 400
                    ? BorderRadius.all(const Radius.circular(30))
                    : BorderRadius.all(const Radius.circular(0))
              ),
              child: buttonSqueezeAnimation.value > 75
                  ? Text(
                      "ورود",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          letterSpacing: .3
                      ),
                    )
                  : buttonZoomOut.value < 300.0
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : null
                  ,
            )
        :  Container(
              width: buttonZoomOut.value,
              height: buttonZoomOut.value,
              decoration: BoxDecoration(
                shape: buttonZoomOut.value < 500
                    ? BoxShape.circle
                    : BoxShape.rectangle,
                color : const Color(0xff075E54)
              ),
          );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnimatedBuilder(animation: controller, builder: (BuildContext context, Widget? child) {
      return buttonZoomOut.value <= 300
          ?  Container(
        margin: const EdgeInsets.only(bottom: 30),
        width: buttonZoomOut.value == 70
            ? buttonSqueezeAnimation.value
            : buttonZoomOut.value,
        height: buttonZoomOut.value == 70
            ? 60
            : buttonZoomOut.value,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Color(0xff075E54),
            borderRadius: buttonZoomOut.value < 400
                ? BorderRadius.all(const Radius.circular(30))
                : BorderRadius.all(const Radius.circular(0))
        ),
        child: buttonSqueezeAnimation.value > 75
            ? Text(
          "ورود",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w300,
              letterSpacing: .3
          ),
        )
            : buttonZoomOut.value < 300.0
            ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        )
            : null
        ,
      )
          :  Container(
        width: buttonZoomOut.value,
        height: buttonZoomOut.value,
        decoration: BoxDecoration(
            shape: buttonZoomOut.value < 500
                ? BoxShape.circle
                : BoxShape.rectangle,
            color : const Color(0xff075E54)
        ),
      );
    },

    );
  }

}