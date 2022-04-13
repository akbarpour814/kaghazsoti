import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import '../../../model/payment.dart';
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

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  late bool _internetConnectionChecker;
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  late bool _dataIsLoading;
  late List<Purchase> _purchaseHistoryTemp;
  late List<Purchase> _purchaseHistory;
  late List<bool> _displayOfDetails;
  late int _previousIndex;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  late int _lastPage;
  late int _currentPage;

  @override
  void initState() {
    _dataIsLoading = true;
    _purchaseHistoryTemp = [];
    _purchaseHistory = [];

    _previousIndex = -1;

    _currentPage = 1;

    super.initState();

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future _initPurchaseHistory() async {
    _customDio = await CustomDio.dio.post(
      'dashboard/invoices',
      queryParameters: {'page': _currentPage},
    );

    if (_customDio.statusCode == 200) {
      _customResponse = CustomResponse.fromJson(_customDio.data);

      _lastPage = _customResponse.data['last_page'];

      if (_currentPage == 1) {
        _purchaseHistory.clear();
      }

      for (Map<String, dynamic> purchase in _customResponse.data['data']) {
        _purchaseHistory.add(Purchase.fromJson(purchase));
      }

      setState(() {
        _purchaseHistoryTemp.clear();
        _purchaseHistoryTemp.addAll(_purchaseHistory);
      });

      // List<Purchase> _purchaseHistoryTemp = [];
      // _purchaseHistoryTemp.addAll(_purchaseHistory.reversed.toList());
      //
      // _purchaseHistory.clear();
      // _purchaseHistory.addAll(_purchaseHistoryTemp);

      _displayOfDetails =
          List<bool>.generate(_purchaseHistoryTemp.length, (index) => false);

      _dataIsLoading = false;
    }

    return _customDio;
  }

  late RefreshController _refreshController;
  @override
  Widget build(BuildContext context) {
    _refreshController = RefreshController(initialRefresh: false);

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
                  : Center(
                      child: CustomCircularProgressIndicator(
                          message: 'لطفاً شکیبا باشید.'));
            },
            future: _initPurchaseHistory(),
          )
        : _innerBody();
  }

  Widget _innerBody() {
    if (_connectionStatus == ConnectivityResult.none) {
      setState(() {
        _dataIsLoading = true;
      });

      return const Center(
        child: NoInternetConnection(),
      );
    } else {
      if (_purchaseHistoryTemp.isEmpty) {
        return const Center(
          child: Text('تا کنون برای شما فاکتور خریدی صادر نشده است.'),
        );
      } else {
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: const MaterialClassicHeader(),
          footer: CustomFooter(
            builder: (BuildContext? context, LoadStatus? mode) {
              Widget body;
              if (mode == LoadStatus.idle &&
                  _currentPage == _lastPage &&
                  !_dataIsLoading) {
                body = Text(
                  'فاکتور خرید دیگری یافت نشد.',
                  style: TextStyle(
                    color: Theme.of(context!).primaryColor,
                  ),
                );
              } else if (mode == LoadStatus.idle) {
                body = Text(
                  'لطفاً صفحه را بالا بکشید.',
                  style: TextStyle(
                    color: Theme.of(context!).primaryColor,
                  ),
                );
              } else if (mode == LoadStatus.loading) {
                body = Center(
                    child: CustomCircularProgressIndicator(
                        message: 'لطفاً شکیبا باشید.'));
              } else if (mode == LoadStatus.failed) {
                body = Center(
                    child: CustomCircularProgressIndicator(
                        message: 'لطفاً دوباره امتحان کنید.'));
              } else if (mode == LoadStatus.canLoading) {
                body = Center(
                    child: CustomCircularProgressIndicator(
                        message: 'لطفاً صفحه را پایین بکشید.'));
              } else {
                body = Text(
                  'فاکتور خرید دیگری یافت نشد.',
                  style: TextStyle(
                    color: Theme.of(context!).primaryColor,
                  ),
                );
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                _purchaseInvoice(index),
            itemCount: _purchaseHistoryTemp.length,
          ),
        );
      }
    }
  }

  void _onRefresh() {
    //await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    try {
      print('${_currentPage} xxxx');

      if (_currentPage < _lastPage) {
        setState(() {
          _currentPage++;

          print('xxxx');
          _initPurchaseHistory();
        });
      }
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use loadFailed(),if no data return,use LoadNodata()

      // if(mounted)
      //   setState(() {
      //
      //   });
      _refreshController.loadComplete();
    } catch (e) {
      _refreshController.loadFailed();
    }
  }

  Padding _purchaseInvoice(int index) {
    return Padding(
      padding: EdgeInsets.only(
        left: 5.0.w,
        top: index == 0 ? 16.0 : 0.0,
        right: 5.0.w,
        bottom: index == _purchaseHistoryTemp.length - 1 ? 16.0 : 8.0,
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
      value: _purchaseHistoryTemp[index].id.toString(),
      valueInTheEnd: false,
      lastProperty: false,
    );
  }

  Property _purchasePrice(int index) {
    return Property(
      property: 'مبلغ سفارش',
      value: _purchaseHistoryTemp[index].finalPrice,
      valueInTheEnd: false,
      lastProperty: false,
    );
  }

  Property _purchaseDate(int index) {
    return Property(
      property: 'تاریخ سفارش',
      value: _purchaseHistoryTemp[index].date,
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
                    _purchaseHistoryTemp[index].status.title!,
                    style: TextStyle(
                      color: _purchaseHistoryTemp[index].status.color,
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
              _purchaseHistoryTemp[index].books.length,
              (bookIndex) => SizedBox(
                width: 100.0.w - (2 * 5.0.w) - (2 * 18.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return BookIntroductionPage(
                            bookIntroduction:
                                _purchaseHistoryTemp[index].books[bookIndex],
                          );
                        },
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${bookIndex + 1} - ${_purchaseHistoryTemp[index].books[bookIndex].name}',
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
      visible: _purchaseHistoryTemp[index].status == PurchaseStatus.waiting,
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
    Payment payment = Payment(amount: _purchaseHistoryTemp[index].finalPriceInt, callbackURL: PurchaseHistoryPage.routeName, description: 'description',);

    payment.startPayment();
  }
}
