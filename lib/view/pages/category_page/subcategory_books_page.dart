import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaghaze_souti/controller/internet_connection.dart';
import 'package:kaghaze_souti/controller/load_data_from_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../view_models/custom_smart_refresher.dart';
import '../../view_models/no_internet_connection.dart';
import '/model/category.dart';
import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../main.dart';
import '../../../model/book_introduction.dart';
import '../../view_models/custom_circular_progress_indicator.dart';
import '/view/view_models/book_short_introduction.dart';

// ignore: must_be_immutable
class SubcategoryBooksPage extends StatefulWidget {
  late Subcategory subcategory;

  SubcategoryBooksPage({
    Key? key,
    required this.subcategory,
  }) : super(key: key);

  @override
  _SubcategoryBooksPageState createState() => _SubcategoryBooksPageState();
}

class _SubcategoryBooksPageState extends State<SubcategoryBooksPage> with InternetConnection, LoadDataFromAPI, Refresher {
  // late RefreshController _refreshController;
  // late bool _refresh;
  // late bool _loading;
  // late int _lastPage;
  // late int _currentPage;

  late List<BookIntroduction> _subcategoryBooks;
  late List<BookIntroduction> _subcategoryBooksTemp;

  @override
  void initState() {
    super.initState();

    refreshController = RefreshController(initialRefresh: false);
    refresh = false;
    loading = false;
    currentPage = 1;

    _subcategoryBooks = [];
    _subcategoryBooksTemp = [];
  }

  Future _initSubcategoryBooks() async {
    customDio = await CustomDio.dio.post(
      'categories/${widget.subcategory.slug}',
      queryParameters: {'page': currentPage},
    );

    if (customDio.statusCode == 200) {
      customResponse = CustomResponse.fromJson(customDio.data);

      lastPage = customResponse.data['last_page'];

      if (currentPage == 1) {
        _subcategoryBooksTemp.clear();
      }

      for (Map<String, dynamic> book in customResponse.data['data']) {
        _subcategoryBooksTemp.add(BookIntroduction.fromJson(book));
      }

      setState(() {
        dataIsLoading = false;

        refresh = false;
        loading = false;

        _subcategoryBooks.clear();
        _subcategoryBooks.addAll(_subcategoryBooksTemp);
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
      title: Text(widget.subcategory.name),
      centerTitle: false,
      automaticallyImplyLeading: false,
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
        future: _initSubcategoryBooks(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return _innerBody();
          } else {
            return Center(
              child: CustomCircularProgressIndicator(
                message: 'لطفاً شکیبا باشید.',
              ),
            );
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
      if (_subcategoryBooks.isEmpty) {
        return const Center(
          child: Text('کتابی یافت نشد.'),
        );
      } else {
        return CustomSmartRefresher(
          refreshController: refreshController,
          onRefresh: () {
            onRefresh(() => _initSubcategoryBooks());
          },
          onLoading: () {
            onLoading(() => _initSubcategoryBooks());
          },
            list: List<BookShortIntroduction>.generate(
              _subcategoryBooks.length,
                  (index) => BookShortIntroduction(
                book: _subcategoryBooks[index],
              ),
            ),
          listType: 'کتاب',
            refresh: refresh,
            loading: loading,
            lastPage: lastPage,
            currentPage: currentPage,
            dataIsLoading: dataIsLoading,
        );
        /*return SmartRefresher(
          controller: _refreshController,
          onRefresh: _loading
              ? null
              : () {
                  _onRefresh(_initSubcategoryBooks());
                },
          onLoading: _refresh
              ? null
              : () {
                  _onLoading(_initSubcategoryBooks());
                },
          enablePullDown: true,
          enablePullUp: true,
          header: const MaterialClassicHeader(),
          footer: CustomFooter(
            builder: (BuildContext? context, LoadStatus? mode) {
              Widget bar;

              if ((mode == LoadStatus.idle) &&
                  (_currentPage == _lastPage) &&
                  (!_dataIsLoading)) {
                bar = Text(
                  'کتاب دیگری یافت نشد.',
                  style: TextStyle(
                    color: Theme.of(context!).primaryColor,
                  ),
                );
              } else if (mode == LoadStatus.idle) {
                bar = Text(
                  'لطفاً صفحه را بالا بکشید.',
                  style: TextStyle(
                    color: Theme.of(context!).primaryColor,
                  ),
                );
              } else if (mode == LoadStatus.loading) {
                bar = Center(
                  child: CustomCircularProgressIndicator(
                    message: 'لطفاً شکیبا باشید.',
                  ),
                );
              } else if (mode == LoadStatus.failed) {
                bar = Text(
                  'لطفاً دوباره امتحان کنید.',
                  style: TextStyle(
                    color: Theme.of(context!).primaryColor,
                  ),
                );
              } else if (mode == LoadStatus.canLoading) {
                bar = Text(
                  'لطفاً صفحه را پایین بکشید.',
                  style: TextStyle(
                    color: Theme.of(context!).primaryColor,
                  ),
                );
              } else {
                bar = Text(
                  'کتاب دیگری یافت نشد.',
                  style: TextStyle(
                    color: Theme.of(context!).primaryColor,
                  ),
                );
              }

              return SizedBox(
                height: 55.0,
                child: Center(child: bar),
              );
            },
          ),
          child: ListView(
            children: List<BookShortIntroduction>.generate(
              _subcategoryBooks.length,
              (index) => BookShortIntroduction(
                book: _subcategoryBooks[index],
              ),
            ),
          ),
        );*/
      }
    }
  }
}