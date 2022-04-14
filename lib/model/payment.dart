import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zarinpal/zarinpal.dart';

class Payment extends State {
  static String merchantID = '31ef66ef-99ab-4a2e-b599-9b95a25d69e8';

  late PaymentRequest paymentRequest;
  late int amount;
  late String callbackURL;
  late String description;

  Payment({required this.amount, required this.callbackURL, required this.description}) {
    paymentRequest = PaymentRequest();

    paymentRequest.setIsSandBox(true);
    paymentRequest.setMerchantID(merchantID);
    paymentRequest.setAmount(amount);
    paymentRequest.setCallbackURL('kaghaze-souti-version-flutter:/$callbackURL');
    paymentRequest.setDescription(description);
  }

  void startPayment() {
    String paymentUrl;

    ZarinPal().startPayment(paymentRequest,
            (int? status, String? paymentGatewayUri) async {
          if (status == 100) {
            paymentUrl = paymentGatewayUri!;
            await launch(paymentUrl);
          }
        });

    _handleIncomingLinks();
    _handleInitialUri();
  }


  PaymentStatus? status;
  StreamSubscription? _sub;
  bool _initialUriIsHandled = false;

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _sub = uriLinkStream.listen((Uri? uri) {
        ZarinPal().verificationPayment(
            "OK", paymentRequest.authority!, paymentRequest, (
            isPaymentSuccess,
            refID,
            paymentRequest,
            ) {
              print('isPaymentSuccess');
              print(isPaymentSuccess);
              //print(paymentRequest.authority);
          if (isPaymentSuccess) {
            status = PaymentStatus.OK;

          } else {
            status = PaymentStatus.NOK;
          }
        });
      });
    }
  }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
        } else {
          print('got initial uri: $uri');
        }
        if (!mounted) return;
      } on PlatformException {
        print('failed to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        print('malformed initial uri, $err');
      }
    }
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