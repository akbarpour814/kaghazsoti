//------/dart and flutter packages
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kaz_reader/pages/purchase_history/purchase_history_controller.dart';

//------/packages
export 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:uni_links/uni_links.dart';

//------/controller
import '/controller/custom_dio.dart';
import '/controller/custom_response.dart';
import '/controller/internet_connection.dart';
import '/controller/load_data_from_api.dart';

//------/model
import '/model/payment.dart';
import 'purchase_history_model.dart';

//------/view/view_models
import '../book/book_page.dart';
import '../../widgets/custom_circular_progress_indicator.dart';
import '../../widgets/custom_smart_refresher.dart';
import '/widgets/custom_snack_bar.dart';
import '/widgets/display_of_details.dart';
import '/widgets/no_internet_connection.dart';
import '/widgets/property.dart';

//------/main
import '/main.dart';

class PurchaseHistoryPage extends GetView<PurchaseHistoryController> {
  const PurchaseHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context),
      bottomNavigationBar: playerBottomNavigationBar,
    );
  }

  AppBar _appBar(BuildContext context) {
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

  Widget _body(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.fetch(),
      child: controller.obx(
        (state) => _innerBody(context),
        onError: (e) => const Text('onError'),
        onLoading: const Center(
          child: CustomCircularProgressIndicator(),
        ),
        onEmpty: const Text('onEmpty'),
      ),
    );
  }

  Widget _innerBody(BuildContext context) {
    return ListView.builder(
      itemCount: controller.state!.length,
      itemBuilder: (BuildContext context, int index) {
        return _purchaseInvoice(context, index);
      },
    );

    /*   if (connectionStatus == ConnectivityResult.none) {
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
    }*/
  }

  Padding _purchaseInvoice(BuildContext context,int index) {
    return Padding(
      padding: EdgeInsets.only(
        left: 5.0.w,
        top: index == 0 ? 16.0 : 0.0,
        right: 5.0.w,
        bottom: index == controller.state!.length - 1 ? 16.0 : 8.0,
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
            _purchaseId(context, index),
            _purchasePrice(context, index),
            _purchaseDate(context, index),
            _purchaseStatus(context, index),
            _books(context, index),
            const Divider(
              height: 24.0,
            ),
            InkWell(
              onTap: () => controller.show(index),
              child: Icon(
                index == controller.currentIndex.value ? Icons.expand_less : Icons.expand_more,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Property _purchaseId(BuildContext context,int index) {
    return Property(
      property: 'شماره سفارش',
      value: controller.state![index].id.toString(),
      valueInTheEnd: false,
      lastProperty: false,
    );
  }

  Property _purchasePrice(BuildContext context,int index) {
    return Property(
      property: 'مبلغ سفارش',
      value: controller.state![index].finalPrice,
      valueInTheEnd: false,
      lastProperty: false,
    );
  }

  Property _purchaseDate(BuildContext context,int index) {
    return Property(
      property: 'تاریخ سفارش',
      value: controller.state![index].date,
      valueInTheEnd: false,
      lastProperty: false,
    );
  }

  Padding _purchaseStatus(BuildContext context,int index) {
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
                    controller.state![index].status.title!,
                    style: TextStyle(
                      color: controller.state![index].status.color,
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

  Visibility _books(BuildContext context,int index) {
    return Visibility(
      visible: index == controller.currentIndex.value,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            height: 24.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              controller.state![index].books.length,
              (bookIndex) => SizedBox(
                width: 100.0.w - (2 * 5.0.w) - (2 * 18.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) {
                          return BookPage(
                            book: controller.state![index].books[bookIndex],
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
                          '${bookIndex + 1}- ${controller.state![index].books[bookIndex].name}',
                          style: TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _paymentButton(context, index),
        ],
      ),
    );
  }

  Visibility _paymentButton(BuildContext context,int index) {
    return Visibility(child: Text(';;;'));
    // return Visibility(
    //   visible: controller.state![index].status == PurchaseStatus.waiting,
    //   child: SizedBox(
    //     width: 100.0.w - (2 * 18.0) - (2 * 5.0.w),
    //     child: ElevatedButton.icon(
    //       onPressed: () {
    //         startPayment(
    //             _purchaseHistory[index], PurchaseHistoryPage.routeName);
    //
    //         setState(() {
    //           _paymentGateway = true;
    //           _purchaseIndexSelected = index;
    //         });
    //       },
    //       label: const Text('خرید'),
    //       icon: const Icon(Ionicons.card_outline),
    //     ),
    //   ),
    // );
  }

  /*void _handleIncomingLinks() {
    // if (!kIsWeb) {
    //
    //   uriLinkStream2 = uriLinkStream.listen((Uri? uri) {
    //
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
            for (int i = 0;
                i < _purchaseHistory[_purchaseIndexSelected].books.length;
                ++i) {
              libraryId
                  .add(_purchaseHistory[_purchaseIndexSelected].books[i].id);
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
        _paymentGateway = false;
      });
    }
  }*/
}
