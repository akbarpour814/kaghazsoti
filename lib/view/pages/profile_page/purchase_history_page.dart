import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sizer/sizer.dart';
import 'package:takfood_seller/model/purchase.dart';
import 'package:takfood_seller/view/view_models/player_bottom_navigation_bar.dart';
import 'package:takfood_seller/view/view_models/property.dart';

import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../main.dart';
import '../../view_models/book_introduction_page.dart';
import '../../view_models/custom_circular_progress_indicator.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({Key? key}) : super(key: key);

  @override
  _PurchaseHistoryPageState createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  late  bool _internetConnectionChecker;
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  late bool _dataIsLoading;
  late List<Purchase> _purchaseHistory;
  late List<bool> _displayOfDetails;
  late int _previousIndex;

  @override
  void initState() {
    _dataIsLoading = true;
    _purchaseHistory = [];

    _previousIndex = -1;

    super.initState();
  }

  Future _initPurchaseHistory() async {
    _customDio = await CustomDio.dio.post('dashboard/invoices');

    if (_customDio.statusCode == 200) {
      _purchaseHistory.clear();

      _customResponse = CustomResponse.fromJson(_customDio.data);

      int lastPage = _customResponse.data['last_page'];

      for (Map<String, dynamic> purchase in _customResponse.data['data']) {
        _purchaseHistory.add(Purchase.fromJson(purchase));
      }

      for(int i = 2; i <= lastPage; ++i) {
        _customDio = await CustomDio.dio.post('dashboard/invoices', queryParameters: {'page': i},);

        if(_customDio.statusCode == 200) {
          _customResponse = CustomResponse.fromJson(_customDio.data);

          for (Map<String, dynamic> purchase in _customResponse.data['data']) {
            _purchaseHistory.add(Purchase.fromJson(purchase));
          }
        }
      }

      List<Purchase> _purchaseHistoryTemp = [];
      _purchaseHistoryTemp.addAll(_purchaseHistory.reversed.toList());

      _purchaseHistory.clear();
      _purchaseHistory.addAll(_purchaseHistoryTemp);

      _displayOfDetails =
          List<bool>.generate(_purchaseHistory.length, (index) => false);

      _dataIsLoading = false;
    }

    return _customDio;
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
    return _dataIsLoading
        ? FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.hasData
                  ? _innerBody()
                  : const Center(
                      child: CustomCircularProgressIndicator(),
                    );
            },
            future: _initPurchaseHistory(),
          )
        : _innerBody();
  }

  Widget _innerBody() {
    if (_purchaseHistory.isEmpty) {
      return const Center(
        child: Text('تا کنون برای شما فاکتور خریدی صادر نشده است.'),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: List.generate(
            _purchaseHistory.length,
            (index) => _purchaseInvoice(index),
          ),
        ),
      );
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
              onTap: () {
                setState(() {
                  if (index == _previousIndex && _displayOfDetails[index]) {
                    _displayOfDetails[index] = false;
                  } else if (index == _previousIndex &&
                      !_displayOfDetails[index]) {
                    _displayOfDetails[index] = true;
                  } else if (index != _previousIndex) {
                    if (_previousIndex != -1) {
                      _displayOfDetails[_previousIndex] = false;
                    }
                    _displayOfDetails[index] = true;
                  }

                  _previousIndex = index;
                });
              },
              child: Icon(
                _displayOfDetails[index]
                    ? Icons.expand_less
                    : Icons.expand_more,
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
      visible: _displayOfDetails[index],
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
                            bookIntroduction: _purchaseHistory[index].books[bookIndex],
                          );
                        },
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${bookIndex + 1} - ${_purchaseHistory[index].books[bookIndex].name}',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _purchaseHistory[index].status == PurchaseStatus.waiting,
            child: SizedBox(
              width: 100.0.w - (2 * 18.0) - (2 * 5.0.w),
              child: ElevatedButton.icon(
                onPressed: () {},
                label: const Text('خرید'),
                icon: const Icon(Ionicons.card_outline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
