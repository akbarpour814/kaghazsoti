import 'package:url_launcher/url_launcher.dart';
import 'package:zarinpal/zarinpal.dart';

class Payment {
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
  }

  // void verificationPayment() {
  //   paymentRequest.
  // }
}