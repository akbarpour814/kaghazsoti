import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaghaze_souti/controller/internet_connection.dart';
import 'package:kaghaze_souti/controller/load_data_from_api.dart';
import 'package:kaghaze_souti/view/view_models/display_of_details.dart';
import 'package:sizer/sizer.dart';
import 'package:uni_links/uni_links.dart';
import 'package:zarinpal/zarinpal.dart';
import '../../../model/payment.dart';
import '../../view_models/custom_smart_refresher.dart';
import '../../view_models/custom_snack_bar.dart';
import '../../view_models/no_internet_connection.dart';
import '../login_pages/splash_page.dart';
import '/model/purchase.dart';
import '/view/view_models/property.dart';

import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../main.dart';
import '../../view_models/book_introduction_page.dart';
import '../../view_models/custom_circular_progress_indicator.dart';

import 'package:http/http.dart' as http;


class PurchaseHistoryPage extends StatefulWidget {
  static const routeName = '/purchaseHistoryPage';

  const PurchaseHistoryPage({Key? key}) : super(key: key);

  @override
  _PurchaseHistoryPageState createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage>
    with InternetConnection, LoadDataFromAPI, Refresher, DisplayOfDetails {
  late List<Purchase> _purchaseHistory;
  late List<Purchase> _purchaseHistoryTemp;
  late bool _paymentGateway;

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    _handleInitialUri();


    _purchaseHistory = [];
    _purchaseHistoryTemp = [];
    _paymentGateway = false;


  }


  Future _initPurchaseHistory() async {
    customDio = await CustomDio.dio.post(
      'dashboard/invoices',
      queryParameters: {'page': currentPage},
    );

    if (customDio.statusCode == 200) {
      customResponse = CustomResponse.fromJson(customDio.data);

      lastPage = customResponse.data['last_page'];

      if (currentPage == 1) {
        _purchaseHistoryTemp.clear();
      }

      for (Map<String, dynamic> purchase in customResponse.data['data']) {
        _purchaseHistoryTemp.add(Purchase.fromJson(purchase));
      }

      setState(() {
        dataIsLoading = false;

        refresh = false;
        loading = false;

        _purchaseHistory.clear();
        _purchaseHistory.addAll(_purchaseHistoryTemp);

        displayOfDetails = List<bool>.generate(
          _purchaseHistory.length,
          (index) => false,
        );
      });
    }

    return customDio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: playerBottomNavigationBar,
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('تاریخچه خرید'),
      automaticallyImplyLeading: false,
      leading: const Icon(
        Ionicons.calendar_outline,
      ),
      actions: [
        InkWell(
          child: const Padding(
            padding: EdgeInsets.all(18.0),
            child: Icon(
              Ionicons.chevron_back_outline,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _body() {
    if (dataIsLoading) {
      return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return _innerBody();
          } else {
            return const Center(
              child: CustomCircularProgressIndicator(),
            );
          }
        },
        future: _initPurchaseHistory(),
      );
    } else if(_paymentGateway) {
      return const Center(
        child: CustomCircularProgressIndicator(),
      );
    } else {
      return _innerBody();
    }
  }

  Widget _innerBody() {
    if (connectionStatus == ConnectivityResult.none) {
      setState(() {
        dataIsLoading = true;
      });

      return const Center(
        child: NoInternetConnection(),
      );
    } else {
      if (_purchaseHistory.isEmpty) {
        return const Center(
          child: Text('تا کنون برای شما فاکتور خریدی صادر نشده است.'),
        );
      } else {
        return CustomSmartRefresher(
          refreshController: refreshController,
          onRefresh: () => onRefresh(() => _initPurchaseHistory()),
          onLoading: () => onLoading(() => _initPurchaseHistory()),
          list: List.generate(
            _purchaseHistory.length,
            (index) => _purchaseInvoice(index),
          ),
          listType: 'فاکتور خرید',
          refresh: refresh,
          loading: loading,
          lastPage: lastPage,
          currentPage: currentPage,
          dataIsLoading: dataIsLoading,
        );
      }
    }
  }

  Padding _purchaseInvoice(int index) {
    return Padding(
      padding: EdgeInsets.only(
        left: 5.0.w,
        top: index == 0 ? 16.0 : 0.0,
        right: 5.0.w,
        bottom: index == _purchaseHistory.length - 1 ? 16.0 : 8.0,
      ),
      child: Container(
        padding: const EdgeInsets.only(
          left: 18.0,
          top: 18.0,
          right: 18.0,
          bottom: 8.0,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Column(
          children: [
            _purchaseId(index),
            _purchasePrice(index),
            _purchaseDate(index),
            _purchaseStatus(index),
            _books(index),
            const Divider(
              height: 24.0,
            ),
            InkWell(
              onTap: () => display(index),
              child: Icon(
                displayOfDetails[index] ? Icons.expand_less : Icons.expand_more,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Property _purchaseId(int index) {
    return Property(
      property: 'شماره سفارش',
      value: _purchaseHistory[index].id.toString(),
      valueInTheEnd: false,
      lastProperty: false,
    );
  }

  Property _purchasePrice(int index) {
    return Property(
      property: 'مبلغ سفارش',
      value: _purchaseHistory[index].finalPrice,
      valueInTheEnd: false,
      lastProperty: false,
    );
  }

  Property _purchaseDate(int index) {
    return Property(
      property: 'تاریخ سفارش',
      value: _purchaseHistory[index].date,
      valueInTheEnd: false,
      lastProperty: false,
    );
  }

  Padding _purchaseStatus(int index) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 0.0,
        top: 0.0,
        right: 0.0,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Expanded(
            child: Text('وضعیت:'),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    _purchaseHistory[index].status.title!,
                    style: TextStyle(
                      color: _purchaseHistory[index].status.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Visibility _books(int index) {
    return Visibility(
      visible: displayOfDetails[index],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            height: 24.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              _purchaseHistory[index].books.length,
              (bookIndex) => SizedBox(
                width: 100.0.w - (2 * 5.0.w) - (2 * 18.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return BookIntroductionPage(
                            book: _purchaseHistory[index].books[bookIndex],
                          );
                        },
                      ),
                    );
                  },
                  child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          '${bookIndex + 1}- ${_purchaseHistory[index].books[bookIndex].name}',
                          style: TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _paymentButton(index),
        ],
      ),
    );
  }

  Visibility _paymentButton(int index) {
    return Visibility(
      visible: _purchaseHistory[index].status == PurchaseStatus.waiting,
      child: SizedBox(
        width: 100.0.w - (2 * 18.0) - (2 * 5.0.w),
        child: ElevatedButton.icon(
          onPressed: () {
            _payment(index);
          },
          label: const Text('خرید'),
          icon: const Icon(Ionicons.card_outline),
        ),
      ),
    );
  }

  late  Payment payment;
  void _payment(int index) async {
    String description = '';

    for(int i = 0; i < _purchaseHistory[index].books.length; ++i) {
      description += '${i + 1}- ${_purchaseHistory[index].books[i].name} \n';
    }

    payment = Payment(
      amount: _purchaseHistory[index].finalPriceInt,
      callbackURL: PurchaseHistoryPage.routeName,
      description: description,
    );




    payment.startPayment(_purchaseHistory[index].id.toString());

  }

  PaymentStatus? status;
  StreamSubscription? _sub;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _sub = uriLinkStream.listen((Uri? uri) {
        ZarinPal().verificationPayment(
            "OK", paymentRequest.authority!, paymentRequest, (
            isPaymentSuccess,
            refID,
            paymentRequest,
            ) {
          if (isPaymentSuccess) {
            print('111111111');
            print('2 ${paymentRequest.authority}');
            setState(() {
              status = PaymentStatus.OK;

              _paymentGateway = false;

              _tayyd(paymentRequest.authority!, payment.statuss!);
            });

          } else {
            print('222222222');
            print('3 ${paymentRequest.authority}');
            setState(() {
              status = PaymentStatus.NOK;

              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(
                  context,
                  Ionicons.refresh_outline,
                  'پرداخت موفقیت آمیز نبود. لطفاً دوباره امتحان کنید.',
                  4,
                ),
              );
            });
          }
        });
      });
    }
  }

  void _tayyd(String authority, int status) async {
    var client = http.Client();
    customDio = await CustomDio.dio.get(
      'dashboard/invoice_and_pay/callback',
      queryParameters: {'Authority' : authority, 'Status': status,},
    );


    if(customDio.statusCode == 200) {
      showDialog(
          context: context,
          builder: (builder) {
            return AlertDialog(
              title: Text(
                customDio.data.toString(),
                style: TextStyle(color: Colors.greenAccent),
              ),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    print(authority);


    print(customDio.data);
  }

  Future<void> _handleInitialUri() async {
    if (!initialUriIsHandled) {
      initialUriIsHandled = true;
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

  late String amount;




}
