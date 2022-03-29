import 'package:zarinpal/zarinpal.dart';

main() {

// Initialize payment request
  PaymentRequest _paymentRequest = PaymentRequest()
    ..setIsSandBox(true) // if your application is in developer mode, then set the sandBox as True otherwise set sandBox as false
    ..setMerchantID("31ef66ef-99ab-4a2e-b599-9b95a25d69e8")
    ..setCallbackURL("Verfication Url callbacl"); //The callback can be an android scheme or a website URL, you and can pass any data with The callback for both scheme and  URL


  String? _paymentUrl = null;

  _paymentRequest.setAmount(10000);
  _paymentRequest.setDescription("Payment Description");
// Call Start payment
  ZarinPal().startPayment(_paymentRequest, (int? status, String? paymentGatewayUri){
    if(status == 100)
      _paymentUrl  = paymentGatewayUri;  // launch URL in browser
  });



  ZarinPal().verificationPayment("Status", "Authority Call back", _paymentRequest, (isPaymentSuccess,refID, paymentRequest){
    if(isPaymentSuccess){
      // Payment Is Success
      print('moafagh');
    }else{
      // Error Print Status
      print('na moafagh');
    }
  });



}