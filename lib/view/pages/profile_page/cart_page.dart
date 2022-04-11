import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import '../../view_models/no_internet_connection.dart';
import '/main.dart';
import '/model/book.dart';
import '/model/book_introduction.dart';
import '/model/purchase.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';
import '/view/view_models/property.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../view_models/book_introduction_page.dart';
import '../../view_models/custom_circular_progress_indicator.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late  bool _internetConnectionChecker;
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  late bool _dataIsLoading;
  late List<Book> _cart;
  late bool _purchaseInvoiceWasIssued;
  Purchase? _purchaseInvoice;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;


  @override
  void initState() {
    _dataIsLoading = true;
    _cart = [];
    _purchaseInvoiceWasIssued = false;

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


  Map<String, Book> cart = {};
  Future _initCart() async {

    if(_dataIsLoading) {
      cart.clear();

      for (int i = 0; i < cartSlug.length; ++i) {
        _customDio = await CustomDio.dio.post('books/${cartSlug[i]}');

        if (_customDio.statusCode == 200) {
          _customResponse = CustomResponse.fromJson(_customDio.data);

          cart.addAll({cartSlug[i] : Book.fromJson(_customResponse.data)});
        }
      }

     setState(() {
       _dataIsLoading = false;

       _cart = cart.values.toList();
     });
    }

    return _customDio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: playerBottomNavigationBar,
      floatingActionButton: cartSlug.isNotEmpty && _connectionStatus != ConnectivityResult.none && !_dataIsLoading ? _issuanceOfPurchaseInvoiceButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('سبد خرید'),
      automaticallyImplyLeading: false,
      leading: const Icon(
        Ionicons.bag_outline,
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
            setState(() {
              if(_purchaseInvoiceWasIssued) {
                cartSlug.clear();
              }

              Navigator.of(context).pop();
            });
          },
        ),
      ],
    );
  }

  Widget _body() {
    if (cartSlug.isEmpty) {
      return const Center(
        child: Text('محصولی در سبد خرید شما وجود ندارد.'),
      );
    } else {
      return _dataIsLoading
          ? FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return snapshot.hasData
                    ? _innerBody()
                    : Center(child: CustomCircularProgressIndicator(message: 'لطفاً شکیبا باشید.'));
              },
              future: _initCart(),
            )
          : _innerBody();
    }
  }

  Widget _innerBody() {
    if(_connectionStatus == ConnectivityResult.none) {
      setState(() {
        _dataIsLoading = true;
      });

      return const Center(child: NoInternetConnection(),);
    } else {


      return RefreshIndicator(
        onRefresh: () {
          setState(() {
            _dataIsLoading = true;
          });

          return _initCart();
          },
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 5.0.w,
                top: 16.0,
                right: 5.0.w,
                bottom: _purchaseInvoiceWasIssued ? 8.0.h : 16.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _books(),
                  _prices(),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Padding _books() {
    return Padding(
      padding: EdgeInsets.only(bottom: _purchaseInvoiceWasIssued ? 8.0 : 8.0.h),
      child: Container(
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'کتاب ها',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            Divider(
              height: 4.0.h,
            ),
            Column(
              children: List<Card>.generate(
                _cart.length,
                (index) => _book(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _book(int index) {
    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      shape: index == _cart.length - 1
          ? const Border()
          : Theme.of(context).cardTheme.shape,
      child: Row(
        children: [
          _bookCover(index),
          _bookShortIntroduction(index),
        ],
      ),
    );
  }

  Padding _bookCover(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (!_purchaseInvoiceWasIssued) ? () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return BookIntroductionPage(
                  bookIntroduction: BookIntroduction(
                    id: _cart[index].id,
                    slug: _cart[index].slug,
                    name: _cart[index].name,
                    author: _cart[index].author,
                    publisherOfPrintedVersion:
                    _cart[index].publisherOfPrintedVersion,
                    duration: _cart[index].duration,
                    price: _cart[index].price,
                    numberOfVotes: _cart[index].numberOfVotes,
                    numberOfStars: _cart[index].numberOfStars,
                    bookCoverPath: _cart[index].bookCoverPath,
                  ),
                );
              },
            ),
          );
        } : null,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
            shape: BoxShape.rectangle,
          ),
          width: 20.0.w,
          height: 10.5.h,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
            child: FadeInImage.assetNetwork(
              placeholder: defaultBookCover,
              image: _cart[index].bookCoverPath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Expanded _bookShortIntroduction(int index) {
    return Expanded(
      child: ListTile(
        title: Text(
          _cart[index].name,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
          ),
        ),
        subtitle: Text(
          'قیمت:\n${_cart[index].price}',
          style: Theme.of(context).textTheme.caption,
        ),
        trailing: _bookRemoveButton(index),
      ),
    );
  }

  Visibility _bookRemoveButton(int index) {
    return Visibility(
      visible: !_purchaseInvoiceWasIssued,
      child: OutlinedButton(
        onPressed: () {
          _bookRemove(index);
        },
        child: const Text(
          'حذف',
          style: TextStyle(color: Colors.redAccent),
          overflow: TextOverflow.ellipsis,
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                30.0,
              ),
              side: const BorderSide(
                color: Colors.redAccent,
              ),
            ),
          ),
          side: MaterialStateProperty.all(
            const BorderSide(
              color: Colors.redAccent,
            ),
          ),
        ),
      ),
    );
  }

  void _bookRemove(int index) async {
    setState(() {
      cartSlug.remove(_cart[index].slug);

      _cart.removeAt(index);
    });

    await sharedPreferences.setStringList('cartSlug', cartSlug);
  }

  Widget _prices() {
    return _purchaseInvoice == null ? Container() : Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Property(
                  property: 'قیمت کتاب ها',
                  value: _purchaseInvoice!.totalPrice,
                  valueInTheEnd: true,
                  lastProperty: false,
                ),
                Property(
                  property: 'تخفیف',
                  value: _purchaseInvoice!.couponDiscount,
                  valueInTheEnd: true,
                  lastProperty: true,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Property(
              property: 'مبلغ قابل پرداخت',
              value: _purchaseInvoice!.finalPrice,
              valueInTheEnd: true,
              lastProperty: true,
            ),
          ),
        ),
      ],
    );
  }

  SizedBox _issuanceOfPurchaseInvoiceButton() {
    return SizedBox(
      width: 100.0.w - (2 * 5.0.w),
      child: ElevatedButton.icon(
        onPressed: () {
          if(!_dataIsLoading) {
            if(_purchaseInvoiceWasIssued) {

            } else {
              _issuanceOfPurchaseInvoice();
            }
          }
        },
        label: Text(!_purchaseInvoiceWasIssued
            ? 'صدور فاکتور خرید'
            : 'ادامه خرید'),
        icon: Icon(!_purchaseInvoiceWasIssued ? Ionicons.bag_check_outline : Ionicons.card_outline),
      ),
    );
  }

  void _issuanceOfPurchaseInvoice() async {
    List<String> booksId = List<String>.generate(_cart.length, (index) => _cart[index].id.toString());

    _customDio = await CustomDio.dio.post(
      'dashboard/invoices/create',
      data: {
        'id': booksId.toString(),
      },
    );

    if (_customDio.statusCode == 200) {
      _customResponse = CustomResponse.fromJson(_customDio.data);

      setState(() {
        _purchaseInvoice = Purchase.fromJson(_customResponse.data);

        _purchaseInvoiceWasIssued = true;
      });

      await sharedPreferences.setStringList('cartSlug', []);
    }
  }
}
