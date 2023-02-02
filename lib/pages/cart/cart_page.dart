//------/dart and flutter packages
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

//------/packages
export 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:kaz_reader/model/purchase.dart';
// import 'package:uni_links/uni_links.dart';

//------/controller
import '../../model/book_introduction.dart';
import '../../widgets/fade_in_image_widget.dart';
import '/controller/custom_dio.dart';
import '/controller/custom_response.dart';
import '/controller/internet_connection.dart';
import '/controller/load_data_from_api.dart';

//------/model
import '../book/book_model.dart';
import '../../widgets/book_introduction/book_introduction_model.dart';
import '/model/payment.dart';
import '../purchase_history/purchase_history_model.dart';

//------/view/view_models
import '../book/book_page.dart';
import '../../widgets/custom_circular_progress_indicator.dart';
import '/widgets/custom_snack_bar.dart';
import '/widgets/no_internet_connection.dart';
import '/widgets/property.dart';

//------/main
import '/main.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cartPage';

  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with InternetConnection, LoadDataFromAPI, CustomVerificationPayment {
  late List<String> _bookCartSlug;
  late List<BookModel> _bookCart;
  late Map<String, BookModel> _bookCartTemp;
  late bool _purchaseInvoiceWasIssued;
  PurchaseHistoryModel? _purchaseInvoice;
  late bool _paymentGateway;
  late bool _showButtons;

  late bool _issuanceOfPurchaseInvoiceClick;

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();

    _bookCartSlug = [];
    _bookCartSlug.addAll(bookCartSlug);
    _bookCart = [];
    _bookCartTemp = {};
    _purchaseInvoiceWasIssued = false;
    _paymentGateway = false;
    _showButtons = true;

    _issuanceOfPurchaseInvoiceClick = true;
  }

  Future _initCart() async {
    if (dataIsLoading) {
      _bookCartTemp.clear();

      for (int i = 0; i < _bookCartSlug.length; ++i) {
        customDio = await CustomDio.dio.post('books/${_bookCartSlug[i]}');

        if (customDio.statusCode == 200) {
          customResponse = CustomResponse.fromJson(customDio.data);

          _bookCartTemp[_bookCartSlug[i]] =
              BookModel.fromJson(customResponse.data);
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
              (!dataIsLoading) &&
              (_showButtons)
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
    if (_paymentGateway) {
      return const Center(child: CustomCircularProgressIndicator());
    } else if (dataIsLoading) {
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
                  CupertinoPageRoute(
                    builder: (context) {
                      return BookPage(
                        book: BookIntroductionModel(
                          id: _bookCart[index].id,
                          type: _bookCart[index].type,
                          slug: _bookCart[index].slug,
                          name: _bookCart[index].name,
                          author: _bookCart[index].author,
                          publisherOfPrintedVersion:
                              _bookCart[index].publisherOfPrintedVersion,
                          duration: _bookCart[index].duration,
                          price: _bookCart[index].price,
                          votes: _bookCart[index].numberOfVotes,
                          stars: _bookCart[index].numberOfStars,
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
            child: FadeInImageWidget(
              image: _bookCart[index].bookCoverPath,
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
            if (_issuanceOfPurchaseInvoiceClick) {
              _issuanceOfPurchaseInvoice();
            }
          }
        },
        label: Text(_issuanceOfPurchaseInvoiceClick
            ? 'صدور فاکتور خرید'
            : 'لطفاً شکیبا باشید.'),
        icon: const Icon(Ionicons.bag_check_outline),
      ),
    );
  }

  void _issuanceOfPurchaseInvoice() async {
    setState(() {
      _issuanceOfPurchaseInvoiceClick = false;
    });

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
        _purchaseInvoice = PurchaseHistoryModel.fromJson(customResponse.data);

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
        onPressed: () async {
          if (!dataIsLoading) {
            startPayment(
                Purchase.fill(
                    idp: _purchaseInvoice!.id,
                    couponDiscountp: _purchaseInvoice!.couponDiscount,
                    totalPricep: _purchaseInvoice!.totalPrice,
                    finalPricep: _purchaseInvoice!.finalPrice,
                    finalPriceIntp: _purchaseInvoice!.finalPriceInt,
                    datep: _purchaseInvoice!.date,
                    statusp: _purchaseInvoice!.status,
                    booksp: _purchaseInvoice!.books
                        .map((e) => BookIntroduction(
                            author: e.author,
                            bookCoverPath: e.bookCoverPath,
                            duration: e.duration,
                            id: e.id,
                            name: e.name,
                            numberOfStars: e.stars,
                            numberOfVotes: e.votes,
                            price: e.price,
                            publisherOfPrintedVersion:
                                e.publisherOfPrintedVersion,
                            slug: e.slug,
                            type: e.type))
                        .toList()),
                CartPage.routeName);

            setState(() {
              _showButtons = false;
              _paymentGateway = true;
            });
          }
        },
        label: const Text('ادامه خرید'),
        icon: const Icon(Ionicons.card_outline),
      ),
    );
  }

  void _handleIncomingLinks() {
    // if (!kIsWeb) {
    //   uriLinkStream2 = uriLinkStream.listen((Uri? uri) {
    //     _verificationPayment(uri!.queryParameters);
    //   });
    // }
  }

  void _verificationPayment(Map<String, String> queryParameters) async {
    try {
      customDio = await CustomDio.dio.get(
        'dashboard/invoice_and_pay/callback',
        queryParameters: queryParameters,
      );

      if (customDio.statusCode == 200) {
        customResponse = CustomResponse.fromJson(customDio.data);

        setState(() {
          dataIsLoading = true;
          _paymentGateway = false;
        });

        if (customResponse.data['data']['level'] == 'success') {
          setState(() {
            for (int i = 0; i < _purchaseInvoice!.books.length; ++i) {
              libraryId.add(_purchaseInvoice!.books[i].id);
            }
          });

          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              Ionicons.checkmark_done_outline,
              'پرداخت شما با موفقیت انجام شد.',
              4,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              Ionicons.refresh_outline,
              'پرداخت شما با موفقیت انجام نشد.',
              4,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            context,
            Ionicons.call_outline,
            'خرید ناموفق! لطفاً با ما تماس بگیرید.',
            4,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _showButtons = true;
        _paymentGateway = false;
      });
    }
  }
}
