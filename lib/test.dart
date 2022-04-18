import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TextPreferences {
  static late SharedPreferences _preferences;

  static const _keyText = 'text';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setText(String text) async =>
      await _preferences.setString(_keyText, text);

  static String getText() => _preferences.getString(_keyText) ?? '';
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await TextPreferences.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Detect Background & App Closed';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.indigo),
    home: MainPage(title: title),
  );
}

class MainPage extends StatefulWidget {
  late String title;

  MainPage({
    required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  late TextEditingController controller;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    final text = TextPreferences.getText();
    controller = TextEditingController(text: text);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      TextPreferences.setText(controller.text);
    }

    /* if (isBackground) {
      // service.stop();
    } else {
      // service.start();
    }*/
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      title: Text(widget.title),
    ),
    body: Container(
      padding: EdgeInsets.all(32),
      child: Center(child: buildTextField()),
    ),
  );

  Widget buildTextField() => TextField(
    controller: controller,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: 'Text',
      hintText: 'Enter Text',
      labelStyle: TextStyle(color: Colors.white),
      hintStyle: TextStyle(color: Colors.white),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
  );
}




// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:kaghaze_souti/controller/load_data_from_api.dart';
// import 'package:kaghaze_souti/view/pages/login_pages/splash_page.dart';
// import 'package:zarinpal/zarinpal.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:uni_links/uni_links.dart';
// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
//
// import 'controller/custom_dio.dart';
//
// bool _initialUriIsHandled = false;
// PaymentRequest _paymentRequest = PaymentRequest();
//
// void main() {
//   headers = {
//     'Authorization' : 'Bearer 106|aF8aWGhal8EDHk9sBBdW2tMo8DcaV13vJKfqG5Lj',
//     'Accept': 'application/json',
//     'client': 'api',
//   };
//   runApp(const AppRoot());
// }
//
// class AppRoot extends StatelessWidget {
//   const AppRoot({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: HomePage(),
//     );
//   }
// }
//
// class Payment {
//   const Payment(this.paymentRequest);
//   final PaymentRequest paymentRequest;
//   void start(num amount) async {}
// }
//
//
//
// enum PaymentStatus {
//   OK,
//   NOK,
// }
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> with LoadDataFromAPI{
//   PaymentStatus? status;
//   StreamSubscription? _sub;
//
//   void payment(num amount) {
//     var callback = "kaghaze-souti-version-flutter://callback";
//
//     _paymentRequest.setIsSandBox(false);
//     _paymentRequest.setMerchantID("31ef66ef-99ab-4a2e-b599-9b95a25d69e8");
//     _paymentRequest.setAmount(amount);
//     _paymentRequest.setCallbackURL(callback);
//     _paymentRequest.setDescription("Payment");
//     String _paymentUrl;
//
//
//     ZarinPal().startPayment(_paymentRequest,
//             (int? status, String? paymentGatewayUri) async {
//           if (status == 100) {
//             _paymentUrl = paymentGatewayUri!;
//
//             customDio = await CustomDio.dio.post(
//               'dashboard/invoice_and_pay/pay',
//               data: {'transaction_id' : _paymentRequest.authority!, 'id': '39'},
//             );
//
//             print('1 ${customDio.data}');
//             print('1 ${_paymentRequest.authority}');
//
//             await launch(_paymentUrl);
//           }
//         });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _handleIncomingLinks();
//     _handleInitialUri();
//   }
//
//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }
//
//   void _handleIncomingLinks() {
//     if (!kIsWeb) {
//       _sub = uriLinkStream.listen((Uri? uri) {
//         print(uri!.queryParameters);
//         Tyayd(uri.queryParameters);
//
//       });
//     }
//   }
//
//   void Tyayd(Map<String, String> status) async {
//     customDio = await CustomDio.dio.get(
//       'dashboard/invoice_and_pay/callback',
//       queryParameters: status,
//     );
//   }
//
//   Future<void> _handleInitialUri() async {
//     if (!_initialUriIsHandled) {
//       _initialUriIsHandled = true;
//       try {
//         final uri = await getInitialUri();
//         if (uri == null) {
//           print('no initial uri');
//         } else {
//           print('got initial uri: $uri');
//         }
//         if (!mounted) return;
//       } on PlatformException {
//         print('failed to get initial uri');
//       } on FormatException catch (err) {
//         if (!mounted) return;
//         print('malformed initial uri, $err');
//       }
//     }
//   }
//
//   late String amount;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: TextField(
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(hintText: "Enter amount"),
//                 onChanged: (value) {
//                   setState(() {
//                     amount = value;
//                   });
//                 },
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () => payment(num.parse(amount)),
//               child: const Text(
//                 "Pay",
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             Text(
//               status == null
//                   ? "Payment is not started"
//                   : status == PaymentStatus.OK
//                   ? customDio.data.toString()
//                   : "Pay is not success",
//               style: const TextStyle(
//                 fontSize: 30,
//               ),
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
