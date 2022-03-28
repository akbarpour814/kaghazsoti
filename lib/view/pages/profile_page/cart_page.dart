import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/model/book.dart';
import 'package:takfood_seller/model/user.dart';
import 'package:takfood_seller/view/view_models/player_bottom_navigation_bar.dart';
import 'package:takfood_seller/view/view_models/property.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/database.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key
  }) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late int _totalPrice;

  @override
  void initState() {
    _totalPrice = 0;

    super.initState();
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
        Ionicons.cart_outline,
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
    //----------------------------------------------------------------------------------------------------------
    if(true) {
      return const Center(child: Text('محصولی در سبد خرید شما وجود ندارد.'),);
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 5.0.w,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      const Text('محصولات'),
                      Divider(
                        height: 4.0.h,
                        thickness: 1.0,
                      ),
                      /*Column(
                        children: List<Card>.generate(
                          database.user.cart.length,
                              (index) {
                            //---------------------------------------------------------------------------------
                            _totalPrice += database.user.cart.length;

                            return Card(
                              color: Colors.transparent,
                              elevation: 0.0,
                              shape: index == database.user.cart.length - 1
                                  ? const Border()
                                  : Theme.of(context).cardTheme.shape,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
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
                                          image:  database.user.cart[index].bookCoverPath,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Icon(
                                                  Ionicons.gift_outline,
                                                  size: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .fontSize,
                                                  color: Colors.lightGreen,
                                                ),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  'هدیه',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                      color:
                                                      Colors.lightGreen),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            database.user.cart[index].name,
                                            style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .fontSize,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        'قیمت:\n${database.user.cart[index].price} تومان',
                                        style:
                                        Theme.of(context).textTheme.caption,
                                      ),
                                      trailing: OutlinedButton(
                                        onPressed: () {},
                                        child: const Text(
                                          'حذف',
                                          style:
                                          TextStyle(color: Colors.redAccent),
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
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),*/
                      Divider(
                        height: 4.0.h,
                        thickness: 1.0,
                      ),
                      Property(
                        property: 'مبلغ نهایی',
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
                    property: 'اعتبار شما',
                    value: '$_totalPrice تومان',
                    valueInTheEnd: true,
                    lastProperty: true,
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
                width:  100.0.w - (2 * 5.0.w),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  label: const Text('خرید با پرداخت اینترنتی'),
                  icon: const Icon(Ionicons.card_outline),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
