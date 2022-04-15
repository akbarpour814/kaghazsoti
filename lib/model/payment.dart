import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaghaze_souti/controller/load_data_from_api.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zarinpal/zarinpal.dart';

import 'package:http/http.dart' as http;

import '../controller/custom_dio.dart';
import '../view/pages/login_pages/splash_page.dart';

PaymentRequest paymentRequest = PaymentRequest();
bool initialUriIsHandled = false;
class Payment extends State with LoadDataFromAPI {
  static String merchantID = '31ef66ef-99ab-4a2e-b599-9b95a25d69e8';

  late int amount;
  late String callbackURL;
  late String description;


  Payment({required this.amount, required this.callbackURL, required this.description}) {
    paymentRequest.setIsSandBox(false);
    paymentRequest.setMerchantID(merchantID);
    paymentRequest.setAmount(amount);
    paymentRequest.setCallbackURL('kaghaze-souti-version-flutter:/$callbackURL');
    paymentRequest.setDescription(description);
  }

  int? statuss;
  void startPayment(String idFactor) {
    String paymentUrl;

    ZarinPal().startPayment(paymentRequest,
            (int? status, String? paymentGatewayUri) async {
          if (status == 100) {


            customDio = await CustomDio.dio.post(
              'dashboard/invoice_and_pay/pay',
              data: {'transaction_id' : paymentRequest.authority!, 'id': idFactor},
            );

            statuss = status;
            print('1 ${customDio.data}');
            print('1 ${paymentRequest.authority}');


            paymentUrl = paymentGatewayUri!;

            await launch(paymentUrl);
          }
        });
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }


}

enum PaymentStatus {
  OK,
  NOK,
}