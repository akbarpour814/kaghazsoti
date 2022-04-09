import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomCircularProgressIndicator extends StatefulWidget {
  late String message;

  CustomCircularProgressIndicator({Key? key, required this.message,}) : super(key: key);

  @override
  _CustomCircularProgressIndicatorState createState() => _CustomCircularProgressIndicatorState();
}

class _CustomCircularProgressIndicatorState extends State<CustomCircularProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: SizedBox(
            width: 5.0.w,
            height: 5.0.w,
            child: const CircularProgressIndicator(),
          ),
        ),
        Text(
          widget.message,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
