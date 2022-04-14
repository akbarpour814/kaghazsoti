import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaghaze_souti/controller/internet_connection.dart';
import 'package:kaghaze_souti/controller/load_data_from_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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

class _SubcategoryBooksPageState extends State<SubcategoryBooksPage> with InternetConnection, LoadDataFromAPI, Load {
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

    _refreshController = RefreshController(initialRefresh: false);
    _refresh = false;
    _loading = false;
    _currentPage = 1;

    _subcategoryBooks = [];
    _subcategoryBooksTemp = [];
  }

  Future _initSubcategoryBooks() async {
    customDio = await CustomDio.dio.post(
      'categories/${widget.subcategory.slug}',
      queryParameters: {'page': _currentPage},
    );

    if (customDio.statusCode == 200) {
      customResponse = CustomResponse.fromJson(customDio.data);

      _lastPage = customResponse.data['last_page'];

      if (_currentPage == 1) {
        _subcategoryBooksTemp.clear();
      }

      for (Map<String, dynamic> book in customResponse.data['data']) {
        _subcategoryBooksTemp.add(BookIntroduction.fromJson(book));
      }

      setState(() {
        dataIsLoading = false;

        _refresh = false;
        _loading = false;

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
            updateList: _initSubcategoryBooks(),
            list: List<BookShortIntroduction>.generate(
              _subcategoryBooks.length,
                  (index) => BookShortIntroduction(
                book: _subcategoryBooks[index],
              ),
            ),
            refresh: _refresh,
            loading: _loading,
            lastPage: _lastPage,
            currentPage: _currentPage,
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

mixin Load<T extends StatefulWidget> on State<T> {
  late RefreshController _refreshController;
  late bool _refresh;
  late bool _loading;
  late int _lastPage;
  late int _currentPage;

  void _onRefresh(Future<dynamic> onRefresh) async {
    try {
      setState(() {
        _refresh = _loading ? false : true;

        if (_refresh) {
          _currentPage = 1;

          onRefresh;
        }
      });

      await Future.delayed(const Duration(milliseconds: 1000));

      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  void _onLoading(Future<dynamic> onLoading) async {
    try {
      if (_currentPage < _lastPage) {
        setState(() {
          _loading = _refresh ? false : true;

          if (_loading) {
            _currentPage++;

            onLoading;
          }
        });
      }

      await Future.delayed(const Duration(milliseconds: 1000));

      _refreshController.loadComplete();
    } catch (e) {
      _refreshController.loadFailed();
    }
  }
}

// ignore: must_be_immutable
class CustomSmartRefresher extends StatefulWidget {
  late Future<dynamic> updateList;
  late List<Widget> list;
  late bool refresh;
  late bool loading;
  late int lastPage;
  late int currentPage;
  late bool dataIsLoading;

  CustomSmartRefresher({
    Key? key,
    required this.updateList,
    required this.list,
    required this.refresh,
    required this.loading,
    required this.lastPage,
    required this.currentPage,
    required this.dataIsLoading,
  }) : super(key: key);

  @override
  _CustomSmartRefresherState createState() => _CustomSmartRefresherState();
}

class _CustomSmartRefresherState extends State<CustomSmartRefresher> {
  late RefreshController _refreshController;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: widget.loading
          ? null
          : () {
              _onRefresh(widget.updateList);
            },
      onLoading: widget.refresh
          ? null
          : () {
              _onLoading(widget.updateList);
            },
      enablePullDown: true,
      enablePullUp: true,
      header: const MaterialClassicHeader(),
      footer: CustomFooter(
        builder: (BuildContext? context, LoadStatus? mode) {
          Widget bar;

          if ((mode == LoadStatus.idle) &&
              (widget.currentPage == widget.lastPage) &&
              (!widget.dataIsLoading)) {
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
        children: List<Widget>.generate(
          widget.list.length,
          (index) => widget.list[index],
        ),
      ),
    );
  }

  void _onRefresh(Future<dynamic> onRefresh) async {
    try {
      setState(() {
        widget.refresh = widget.loading ? false : true;

        if (widget.refresh) {
          widget.currentPage = 1;

          onRefresh;
        }
      });

      await Future.delayed(const Duration(milliseconds: 1000));

      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  void _onLoading(Future<dynamic> onLoading) async {
    try {
      if (widget.currentPage < widget.lastPage) {
        setState(() {
          widget.loading = widget.refresh ? false : true;

          if (widget.loading) {
            widget.currentPage++;

            onLoading;
          }
        });
      }

      await Future.delayed(const Duration(milliseconds: 1000));

      _refreshController.loadComplete();
    } catch (e) {
      _refreshController.loadFailed();
    }
  }
}
