// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// class CustomTextField extends StatefulWidget {
//   late String hintText;
//   late String errorText;
//   late bool readOnly;
//   late IconData iconData;
//   late TextEditingController controller;
//   late TextInputType keyboardType;
//   late Function(String) onChanged;
//
//
//   CustomTextField({
//     Key? key,
//     required this.hintText,
//     required this.errorText,
//     required this.readOnly,
//     required this.iconData,
//     required this.controller,
//     required this.keyboardType,
//     required this.onChanged,
//   }) : super(key: key);
//
//   @override
//   State<CustomTextField> createState() => _CustomTextFieldState();
// }
//
// class _CustomTextFieldState extends State<CustomTextField> {
//   late UnderlineInputBorder underlineInputBorder;
//
//   @override
//   Widget build(BuildContext context) {
//     underlineInputBorder = UnderlineInputBorder(
//       borderSide: BorderSide(
//         color: Theme.of(context).primaryColor,
//       ),
//     );
//
//     return Padding(
//       padding: EdgeInsets.only(bottom: 0.5.h),
//       child: TextField(
//         readOnly: widget.readOnly,
//         controller: widget.controller,
//         keyboardType: widget.keyboardType,
//         //cursorColor: Theme.of(context).primaryColor.withOpacity(0.6),
//         //cursorWidth: 1.0,
//         decoration: InputDecoration(
//           helperText: widget.hintText,
//           helperStyle: TextStyle(color: Theme.of(context).primaryColor),
//           errorText: 'false' /*? widget.errorText : null*/,
//           suffixIcon: Icon(
//             widget.iconData,
//             color: Theme.of(context).primaryColor,
//           ),
//           focusColor: Theme.of(context).dividerColor.withOpacity(0.6),
//           border: underlineInputBorder,
//           focusedBorder: underlineInputBorder,
//           disabledBorder: underlineInputBorder,
//           enabledBorder: underlineInputBorder,
//           errorBorder: underlineInputBorder,
//           focusedErrorBorder: underlineInputBorder,
//         ),
//         onChanged: widget.onChanged,
//       ),
//     );
//   }
// }
//
// enum TextFieldType {
//   firstAndLastName,
//   nationalCode,
//   email,
//   phoneNumber,
//   address,
//   giftCode,
//   previousPassword,
//   newPassword,
//   repeatNewPassword,
//   recoveryCode,
// }
//
// extension TextFieldTypeExtension on TextFieldType {
//   static Map<TextFieldType, bool Function(String text)?> onChangedFunctions = {
//   TextFieldType.firstAndLastName : null,
//   TextFieldType.nationalCode : (String text) {return true;},
//   };
//
//   Function(String text)? get onChanged => onChangedFunctions[this];
// }
