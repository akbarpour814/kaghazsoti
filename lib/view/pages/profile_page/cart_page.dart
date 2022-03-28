import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/model/book.dart';
import 'package:takfood_seller/model/book_introduction.dart';
import 'package:takfood_seller/model/user.dart';
import 'package:takfood_seller/view/view_models/player_bottom_navigation_bar.dart';
import 'package:takfood_seller/view/view_models/property.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../controller/database.dart';
import '../../view_models/book_introduction_page.dart';
import '../../view_models/custom_circular_progress_indicator.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  late List<Book> _cart;
  late int _totalPrice;

  @override
  void initState() {
    _totalPrice = 0;
    _cart = [];

    super.initState();
  }

  Future _initCart() async {
    _cart.clear();

    for (int i = 0; i < cartSlug.length; ++i) {
      _customDio = await CustomDio.dio.post('books/${cartSlug[i]}');

      if (_customDio.statusCode == 200) {
        _customResponse = CustomResponse.fromJson(_customDio.data);

        _cart.add(Book.fromJson(_customResponse.data));
      }
    }

    return _customDio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: const PlayerBottomNavigationBar(),
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
    if (cartSlug.isEmpty) {
      return const Center(
        child: Text('محصولی در سبد خرید شما وجود ندارد.'),
      );
    } else {
      return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.hasData
              ? _innerBody()
              : const Center(
                  child: CustomCircularProgressIndicator(),
                );
        },
        future: _initCart(),
      );
    }
  }

  Widget _innerBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 5.0.w,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _books(),
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
                      value: '$_totalPrice تومان',
                      valueInTheEnd: true,
                      lastProperty: false,
                    ),
                    Property(
                      property: 'تخفیف',
                      value: '$_totalPrice تومان',
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
                  value: '$_totalPrice تومان',
                  valueInTheEnd: true,
                  lastProperty: true,
                ),
              ),
            ),
            SizedBox(
              width: 100.0.w - (2 * 5.0.w),
              child: ElevatedButton.icon(
                onPressed: () {
                  
                },
                label: const Text('خرید با پرداخت اینترنتی'),
                icon: const Icon(Ionicons.card_outline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _books() {
    return Padding(
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
            Text('کتاب ها', style: TextStyle(color: Theme.of(context).primaryColor,),),
            Divider(
              height: 4.0.h,
              thickness: 1.0,
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
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return BookIntroductionPage(
                  bookIntroduction: BookIntroduction(id: _cart[index].id, slug: _cart[index].slug, name: _cart[index].name, author: _cart[index].author, publisherOfPrintedVersion: _cart[index].publisherOfPrintedVersion, duration: _cart[index].duration, price: _cart[index].price, numberOfVotes: _cart[index].numberOfVotes, numberOfStars: _cart[index].numberOfStars, bookCoverPath: _cart[index].bookCoverPath,),
                );
              },
            ),
          );
        },
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
        trailing: _bookDeleteButton(index),
      ),
    );
  }

  OutlinedButton _bookDeleteButton(int index) {
    return OutlinedButton(
      onPressed: () {
        _bookDelete(index);
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
    );
  }

  void _bookDelete(int index) async {
    setState(() {
      cartSlug.remove(_cart[index].slug);

      _cart.removeAt(index);
    });

    await sharedPreferences.setStringList('cartSlug', cartSlug);
  }
}
