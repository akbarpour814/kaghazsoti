import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaghaze_souti/controller/internet_connection.dart';
import '../../../controller/load_data_from_api.dart';
import '../../../model/payment.dart';
import '../../view_models/no_internet_connection.dart';
import '/main.dart';
import '/model/book.dart';
import '/model/book_introduction.dart';
import '/model/purchase.dart';
import '/view/view_models/property.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../view_models/book_introduction_page.dart';
import '../../view_models/custom_circular_progress_indicator.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cartPage';

  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with InternetConnection, LoadDataFromAPI {
  late List<String> _bookCartSlug;
  late List<Book> _bookCart;
  late Map<String, Book> _bookCartTemp;
  late bool _purchaseInvoiceWasIssued;
  Purchase? _purchaseInvoice;

  @override
  void initState() {
    super.initState();

    _bookCartSlug = [];
    _bookCartSlug.addAll(bookCartSlug);

    _bookCart = [];
    _bookCartTemp = {};
    _purchaseInvoiceWasIssued = false;
  }

  Future _initCart() async {
    if (dataIsLoading) {
      _bookCartTemp.clear();

      for (int i = 0; i < _bookCartSlug.length; ++i) {
        customDio = await CustomDio.dio.post('books/${_bookCartSlug[i]}');

        if (customDio.statusCode == 200) {
          customResponse = CustomResponse.fromJson(customDio.data);

          _bookCartTemp[_bookCartSlug[i]] = Book.fromJson(customResponse.data);
        }
      }

      setState(() {
        _bookCart = _bookCartTemp.values.toList();

        dataIsLoading = false;
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
      floatingActionButton: (_bookCartSlug.isNotEmpty) &&
              (connectionStatus != ConnectivityResult.none) &&
              (!dataIsLoading)
          ? ((_purchaseInvoiceWasIssued)
              ? _paymentButton()
              : _issuanceOfPurchaseInvoiceButton())
          : null,
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

              Navigator.of(context).pop();

          },
        ),
      ],
    );
  }

  Widget _body() {
    if (dataIsLoading) {
      return FutureBuilder(
        future: _initCart(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return _innerBody();
          } else {
            return Center(child: CustomCircularProgressIndicator());
          }
        },
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
      return RefreshIndicator(
        onRefresh: () {
          setState(() {
            dataIsLoading = true;
          });

          return _initCart();
        },
        child: _bookCartSlug.isEmpty
            ? const Center(
                child: Text('محصولی در سبد خرید شما وجود ندارد.'),
              )
            : ListView(
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
                _bookCart.length,
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
      shape: index == _bookCart.length - 1
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
        onTap: (!_purchaseInvoiceWasIssued)
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return BookIntroductionPage(
                        book: BookIntroduction(
                          id: _bookCart[index].id,
                          slug: _bookCart[index].slug,
                          name: _bookCart[index].name,
                          author: _bookCart[index].author,
                          publisherOfPrintedVersion:
                              _bookCart[index].publisherOfPrintedVersion,
                          duration: _bookCart[index].duration,
                          price: _bookCart[index].price,
                          numberOfVotes: _bookCart[index].numberOfVotes,
                          numberOfStars: _bookCart[index].numberOfStars,
                          bookCoverPath: _bookCart[index].bookCoverPath,
                        ),
                      );
                    },
                  ),
                );
              }
            : null,
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
              image: _bookCart[index].bookCoverPath,
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
          _bookCart[index].name,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Text(
          'قیمت:\n${_bookCart[index].price}',
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
      bookCartSlug.remove(_bookCart[index].slug);
      _bookCartSlug.remove(_bookCart[index].slug);

      _bookCart.removeAt(index);
    });

    await sharedPreferences.setStringList('bookCartSlug', _bookCartSlug);
  }

  Widget _prices() {
    if (_purchaseInvoice == null) {
      return Container();
    } else {
      return Column(
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
  }

  SizedBox _issuanceOfPurchaseInvoiceButton() {
    return SizedBox(
      width: 100.0.w - (2 * 5.0.w),
      child: ElevatedButton.icon(
        onPressed: () {
          if (!dataIsLoading) {
            _issuanceOfPurchaseInvoice();
          }
        },
        label: const Text('صدور فاکتور خرید'),
        icon: const Icon(Ionicons.bag_check_outline),
      ),
    );
  }

  void _issuanceOfPurchaseInvoice() async {
    List<String> booksId = List<String>.generate(
      _bookCart.length,
      (index) => _bookCart[index].id.toString(),
    );

    customDio = await CustomDio.dio.post(
      'dashboard/invoices/create',
      data: {'id': booksId.toString()},
    );

    if (customDio.statusCode == 200) {
      customResponse = CustomResponse.fromJson(customDio.data);

      setState(() {
        _purchaseInvoice = Purchase.fromJson(customResponse.data);

        _purchaseInvoiceWasIssued = true;

        bookCartSlug.clear();
      });

      await sharedPreferences.setStringList('bookCartSlug', []);
    }
  }

  SizedBox _paymentButton() {
    return SizedBox(
      width: 100.0.w - (2 * 5.0.w),
      child: ElevatedButton.icon(
        onPressed: () {
          if (!dataIsLoading) {
            _payment();
          }
        },
        label: const Text('ادامه خرید'),
        icon: const Icon(Ionicons.card_outline),
      ),
    );
  }

  void _payment() {
    Payment payment = Payment(
      amount: _purchaseInvoice!.finalPriceInt,
      callbackURL: CartPage.routeName,
      description: 'description',
    );

    payment.startPayment(_purchaseInvoice!.id.toString());
  }
}
