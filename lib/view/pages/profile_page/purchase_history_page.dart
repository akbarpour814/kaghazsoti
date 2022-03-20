import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/model/purchase.dart';
import 'package:takfood_seller/model/user.dart';
import 'package:takfood_seller/view/view_models/datetime_format.dart';
import 'package:takfood_seller/view/view_models/player_bottom_navigation_bar.dart';
import 'package:takfood_seller/view/view_models/property.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/database.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({
    Key? key}) : super(key: key);

  @override
  _PurchaseHistoryPageState createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  late List<bool> _displayOfDetails;
  late int _previousIndex;

  @override
  void initState() {
    _displayOfDetails =
        List<bool>.generate(database.user.purchaseHistory.length, (index) => false);

    _previousIndex = -1;

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
    if (database.user.purchaseHistory.isEmpty) {
      return const Center(
        child: Text('شما تا کنون محصولی خریداری نکرده اید.'),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: List.generate(
            database.user.purchaseHistory.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                left: 5.0.w,
                top: index == 0 ? 16.0 : 0.0,
                right: 5.0.w,
                bottom: index == database.user.purchaseHistory.length - 1 ? 16.0 : 8.0,
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
                    Property(
                      property: 'شماره سفارش',
                      value: database.user.purchaseHistory[index].number.toString(),
                      valueInTheEnd: false,
                      lastProperty: false,
                    ),
                    Property(
                      property: 'کالا یا خدمات',
                      value: database.user.purchaseHistory[index].type,
                      valueInTheEnd: false,
                      lastProperty: false,
                    ),
                    Property(
                      property: 'مبلغ سفارش',
                      value:
                      '${database.user.purchaseHistory[index].prices.toString()} تومان',
                      valueInTheEnd: false,
                      lastProperty: false,
                    ),
                    Property(
                      property: 'تاریخ سفارش',
                      value: database.user.purchaseHistory[index].date.format(),
                      valueInTheEnd: false,
                      lastProperty: false,
                    ),
                    Padding(
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
                                    database.user.purchaseHistory[index].status.title!,
                                    style: TextStyle(
                                      color: database.user.purchaseHistory[index].status.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _displayOfDetails[index],
                      child: Column(
                        children: [
                          const Divider(
                            height: 24.0,
                            thickness: 1.0,
                          ),

//-------------------------------------------------------------------------------------------------------------------------
                          Visibility(
                            visible: database.user.purchaseHistory[index].status == PurchaseStatus.waiting,
                            child: SizedBox(
                              width:  100.0.w - (2 * 18.0) - (2 * 5.0.w),
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                label: const Text('خرید با پرداخت اینترنتی'),
                                icon: const Icon(
                                    Ionicons.card_outline
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: database.user.purchaseHistory[index].status == PurchaseStatus.cancelled,
                            child: SizedBox(
                              width:  100.0.w - (2 * 18.0) - (2 * 5.0.w),
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                label: const Text('افزودن دوباره به سبد خرید'),
                                icon: const Icon(
                                  Ionicons.cart_outline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 24.0,
                      thickness: 1.0,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (index == _previousIndex &&
                              _displayOfDetails[index]) {
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
