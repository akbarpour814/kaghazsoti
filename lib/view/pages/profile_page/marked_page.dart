import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaghaze_souti/controller/internet_connection.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../controller/load_data_from_api.dart';
import '../../../main.dart';
import '../../../model/book.dart';
import '../../../model/book_introduction.dart';
import '../../view_models/custom_circular_progress_indicator.dart';
import '../../view_models/custom_smart_refresher.dart';
import '../../view_models/no_internet_connection.dart';
import '../category_page/subcategory_books_page.dart';
import '/view/view_models/book_short_introduction.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';



class MarkedPage extends StatefulWidget {
  const MarkedPage({Key? key}) : super(key: key);

  @override
  _MarkedPageState createState() => _MarkedPageState();
}

class _MarkedPageState extends State<MarkedPage> with InternetConnection, LoadDataFromAPI, Refresher {
  late List<BookIntroduction> _markedBooks;
  late List<BookIntroduction> _markedBooksTemp;

  @override
  void initState() {
    super.initState();

    _markedBooks = [];
    _markedBooksTemp = [];
  }

  Future _initMarkedBooks() async {
    customDio = await CustomDio.dio.get('dashboard/users/wish', queryParameters: {'page': currentPage},);


    if (customDio.statusCode == 200) {
      customResponse = CustomResponse.fromJson(customDio.data);

      lastPage = customResponse.data['last_page'];

      if (currentPage == 1) {
        _markedBooksTemp.clear();
      }

      for (Map<String, dynamic> book in customResponse.data['data']) {
        _markedBooksTemp.add(BookIntroduction.fromJson(book));
      }

      setState(() {
        dataIsLoading = false;

        refresh = false;
        loading = false;

        _markedBooks.clear();
        _markedBooks.addAll(_markedBooksTemp);
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
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('نشان شده ها'),
      automaticallyImplyLeading: false,
      leading: const Icon(
        Ionicons.bookmark_outline,
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
    return dataIsLoading ? FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? _innerBody()
            : Center(
            child: CustomCircularProgressIndicator(
                message: 'لطفاً شکیبا باشید.'));
      },
      future: _initMarkedBooks(),
    ) : _innerBody();
  }

  Widget _innerBody() {

    if(connectionStatus == ConnectivityResult.none) {
      setState(() {
        dataIsLoading = true;
      });

      return const Center(child: NoInternetConnection(),);
    } else {
      if (_markedBooks.isEmpty) {
        return const Center(
          child: Text('شما تا کنون کتابی را نشان نکرده اید.'),
        );
      } else {
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: const MaterialClassicHeader(),
          footer: CustomFooter(
            builder: (BuildContext? context, LoadStatus? mode) {
              Widget bar;

              if ((mode == LoadStatus.idle) && (currentPage == lastPage) && (!dataIsLoading)) {
                bar = Text(
                  'کتاب دیگری یافت نشد.',
                  style: TextStyle(
                    color: Theme.of(context!).primaryColor,
                  ),
                );
              } else if (mode == LoadStatus.idle) {
                bar = Text('لطفاً صفحه را بالا بکشید.',
                    style: TextStyle(color: Theme.of(context!).primaryColor));
              } else if (mode == LoadStatus.loading) {
                bar = CustomCircularProgressIndicator(
                    message: 'لطفاً شکیبا باشید.');
              } else if (mode == LoadStatus.failed) {
                bar = CustomCircularProgressIndicator(
                    message: 'لطفاً دوباره امتحان کنید.');
              } else if (mode == LoadStatus.canLoading) {
                bar = CustomCircularProgressIndicator(
                    message: 'لطفاً صفحه را پایین بکشید.');
              } else {
                bar = Text(
                  'کتاب دیگری یافت نشد.',
                  style: TextStyle(color: Theme.of(context!).primaryColor),
                );
              }

              return SizedBox(
                height: 55.0,
                child: Center(child: bar),
              );
            },
          ),
          controller: refreshController,
          onRefresh: loading ? null : () {onRefresh(() => _initMarkedBooks());},
          onLoading: refresh ? null : () {onLoading(() => _initMarkedBooks());},
          child: ListView(
            children: List<BookShortIntroduction>.generate(_markedBooks.length, (index) => BookShortIntroduction(
              book: _markedBooks[index],
            )),
          ),
        );
      }
    }


  }



 /* bool refresh = false;
  bool loading = false;

  void _onRefresh() async {
    try {
      // monitor network fetch
      setState(() {
        refresh = loading ? false : true;
        if (refresh) {
          currentPage = 1;

          _initMarkedBooks();

          print(currentPage);
          print('refresh');
          print(refresh);
          print(loading);
        }
      });
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use refreshFailed()

      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }

  void _onLoading() async {
    try {
      if (currentPage < lastPage) {
        setState(() {
          loading = refresh ? false : true;

          if (loading) {
            currentPage++;

            _initMarkedBooks();
          }
        });
      }

      await Future.delayed(const Duration(milliseconds: 1000));

      refreshController.loadComplete();
    } catch (e) {
      refreshController.loadFailed();
    }
  }*/
}
