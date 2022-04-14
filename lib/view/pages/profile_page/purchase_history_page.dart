import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaghaze_souti/controller/internet_connection.dart';
import 'package:kaghaze_souti/controller/load_data_from_api.dart';
import 'package:kaghaze_souti/view/pages/category_page/subcategory_books_page.dart';
import 'package:kaghaze_souti/view/view_models/display_of_details.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import '../../../model/payment.dart';
import '../../view_models/custom_smart_refresher.dart';
import '../../view_models/no_internet_connection.dart';
import '/model/purchase.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';
import '/view/view_models/property.dart';

import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../main.dart';
import '../../view_models/book_introduction_page.dart';
import '../../view_models/custom_circular_progress_indicator.dart';

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

  @override
  void initState() {
    super.initState();

    _purchaseHistory = [];
    _purchaseHistoryTemp = [];
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
        _purchaseHistory.clear();
        _purchaseHistory.addAll(_purchaseHistoryTemp);

        dataIsLoading = false;
        refresh = false;
        loading = false;

        displayOfDetails =
        List<bool>.generate(_purchaseHistory.length, (index) => false);
      });
    }

    return customDio;
  }

  // late RefreshController _refreshController;
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
    return dataIsLoading
        ? FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? _innerBody()
            : Center(
            child: CustomCircularProgressIndicator(
                message: 'لطفاً شکیبا باشید.'));
      },
      future: _initPurchaseHistory(),
    )
        : _innerBody();
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
            onRefresh: () {
              onRefresh(() => _initPurchaseHistory());
            },
          onLoading: () {
            onLoading(() => _initPurchaseHistory());
          },
            list: List.generate(
                _purchaseHistory.length, (index) => _purchaseInvoice(index)),
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
          border: Border.all(color: Theme
              .of(context)
              .primaryColor),
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
              onTap: () {

                display(index);
              },
              child: Icon(
                displayOfDetails[index]
                    ? Icons.expand_less
                    : Icons.expand_more,
                color: Theme
                    .of(context)
                    .primaryColor,
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
                  (bookIndex) =>
                  SizedBox(
                    width: 100.0.w - (2 * 5.0.w) - (2 * 18.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return BookIntroductionPage(
                                bookIntroduction:
                                _purchaseHistory[index].books[bookIndex],
                              );
                            },
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${bookIndex + 1} - ${_purchaseHistory[index]
                                .books[bookIndex].name}',
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

  void _payment(int index) {
    Payment payment = Payment(amount: _purchaseHistory[index].finalPriceInt,
      callbackURL: PurchaseHistoryPage.routeName,
      description: 'description',);

    payment.startPayment();
  }
}
