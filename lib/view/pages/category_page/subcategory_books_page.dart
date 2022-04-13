import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
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

class _SubcategoryBooksPageState extends State<SubcategoryBooksPage> {
  late ConnectivityResult _connectionStatus;
  late Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  late bool _dataIsLoading;

  late RefreshController _refreshController;
  late bool _refresh;
  late bool _loading;
  late int _lastPage;
  late int _currentPage;

  late List<BookIntroduction> _subcategoryBooks;
  late List<BookIntroduction> _subcategoryBooksTemp;

  @override
  void initState() {
    super.initState();

    _connectionStatus = ConnectivityResult.none;
    _connectivity = Connectivity();
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _dataIsLoading = true;

    _refreshController = RefreshController(initialRefresh: false);
    _refresh = false;
    _loading = false;
    _currentPage = 1;

    _subcategoryBooks = [];
    _subcategoryBooksTemp = [];
  }

  Future<void> _initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
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

  Future _initSubcategoryBooks() async {
    _customDio = await CustomDio.dio.post(
      'categories/${widget.subcategory.slug}',
      queryParameters: {'page': _currentPage},
    );

    if (_customDio.statusCode == 200) {
      _customResponse = CustomResponse.fromJson(_customDio.data);

      _lastPage = _customResponse.data['last_page'];

      if (_currentPage == 1) {
        _subcategoryBooksTemp.clear();
      }

      for (Map<String, dynamic> book in _customResponse.data['data']) {
        _subcategoryBooksTemp.add(BookIntroduction.fromJson(book));
      }

      setState(() {
        _dataIsLoading = false;

        _refresh = false;
        _loading = false;

        _subcategoryBooks.clear();
        _subcategoryBooks.addAll(_subcategoryBooksTemp);
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
    if (_dataIsLoading) {
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
    if (_connectionStatus == ConnectivityResult.none) {
      setState(() {
        _dataIsLoading = true;
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
        return SmartRefresher(
          controller: _refreshController,
          onRefresh: _loading ? null : _onRefresh,
          onLoading: _refresh ? null : _onLoading,
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
        );
      }
    }
  }

  void _onRefresh() async {
    try {
      setState(() {
        _refresh = _loading ? false : true;

        if (_refresh) {
          _currentPage = 1;

          _initSubcategoryBooks();
        }
      });

      await Future.delayed(const Duration(milliseconds: 1000));

      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  void _onLoading() async {
    try {
      if (_currentPage < _lastPage) {
        setState(() {
          _loading = _refresh ? false : true;

          if (_loading) {
            _currentPage++;

            _initSubcategoryBooks();
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
