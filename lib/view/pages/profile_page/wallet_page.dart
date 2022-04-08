// import 'package:flutter/material.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:takfood_seller/model/user.dart';
// import 'package:takfood_seller/view/view_models/player_bottom_navigation_bar.dart';
// import 'package:takfood_seller/view/view_models/property.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../../controller/database.dart';
//
// class WalletPage extends StatefulWidget {
//   const WalletPage({Key? key}) : super(key: key);
//
//   @override
//   _WalletPageState createState() => _WalletPageState();
// }
//
// class _WalletPageState extends State<WalletPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _appBar(),
//       body: _body(),
//       bottomNavigationBar: const PlayerBottomNavigationBar(),
//     );
//   }
//
//   AppBar _appBar() {
//     return AppBar(
//       title: const Text('اعتبار من'),
//       automaticallyImplyLeading: false,
//       leading: const Icon(
//         Ionicons.wallet_outline,
//       ),
//       actions: [
//         InkWell(
//           child: const Padding(
//             padding: EdgeInsets.all(18.0),
//             child: Icon(
//               Ionicons.chevron_back_outline,
//             ),
//           ),
//           onTap: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ],
//     );
//   }
//
//   SingleChildScrollView _body() {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0.w,),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(bottom: 16.0),
//               child: Container(
//                 padding: const EdgeInsets.all(18.0),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Theme.of(context).primaryColor),
//                   borderRadius: const BorderRadius.all(Radius.circular(5.0)),
//                 ),
//                 child: Property(
//                   property: 'اعتبار فعلی شما',
//                   value: '${database.user.walletBalance} تومان',
//                   valueInTheEnd: true,
//                   lastProperty: true,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 8.0),
//               child: _financialCredit(
//                 'برنزی',
//                 0,
//                 25000,
//                 25000,
//                 [const Color(0xFF6E3A06), const Color(0xFF864B11), const Color(0xFF9E5D1C), const Color(0xFFB56E26), const Color(0xFFCD7F31),],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 8.0),
//               child: _financialCredit(
//                 'نقره ای',
//                 0,
//                 50000,
//                 50000,
//                 [const Color(0xFF8B8681), const Color(0xFF9A948F), const Color(0xFFA8A39F), const Color(0xFFB8B3AE), const Color(0xFFC5C1BC),],
//               ),
//             ),
//             _financialCredit(
//               'طلایی',
//               0,
//               100000,
//               100000,
//                 [const Color(0xFFB8860B), const Color(0xFFDAA520), const Color(0xFFEABA3D), const Color(0xFFF1C84C), const Color(0xFFEAA221),],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Container _financialCredit(String typeOfFinancialCredit, double discount, int financialCreditValue, int financialCreditPrice, List<Color> colors) {
//     return Container(
//       padding: const EdgeInsets.all(18.0),
//       decoration: BoxDecoration(
//         color: Theme.of(context).appBarTheme.backgroundColor,
//         borderRadius: const BorderRadius.all(Radius.circular(5.0)),
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: colors,
//         )
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Flexible(
//                 child: Text(
//                   typeOfFinancialCredit,
//                   style: Theme.of(context).appBarTheme.titleTextStyle,
//                 ),
//               ),
//               Flexible(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   decoration: const BoxDecoration(
//                     color: Colors.pinkAccent,
//                     borderRadius: BorderRadius.horizontal(
//                       right: Radius.circular(30.0),
//                     ),
//                   ),
//                   child: Text('$discount%'),
//                 ),
//               ),
//             ],
//           ),
//           Divider(
//             height: 4.0.h,
//             thickness: 1.0,
//           ),
//           Property(
//             property: 'مقدار اعتبار',
//             value: '$financialCreditValue تومان',
//             valueInTheEnd: true,
//             lastProperty: false,
//           ),
//           Property(
//             property: 'قیمت',
//             value: '$financialCreditPrice تومان',
//             valueInTheEnd: true,
//             lastProperty: true,
//           ),
//           Divider(
//             height: 4.0.h,
//             thickness: 1.0,
//           ),
//           Center(
//             child: SizedBox(
//               width: 100.0.w - (2 * 5.0.w),
//               child: ElevatedButton(
//                 onPressed: () {},
//                 child: const Text('خرید'),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
