import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../main.dart';
import '../../../model/book.dart';
import '../../../model/book_introduction.dart';
import '../../view_models/custom_circular_progress_indicator.dart';
import '../../view_models/no_internet_connection.dart';
import '/view/view_models/book_short_introduction.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';



class MarkedPage extends StatefulWidget {
  const MarkedPage({Key? key}) : super(key: key);

  @override
  _MarkedPageState createState() => _MarkedPageState();
}

class _MarkedPageState extends State<MarkedPage> {
  late bool _internetConnectionChecker;
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  late bool _dataIsLoading;
  late int _lastPage;
  late int _currentPage;
  List<BookIntroduction> _markedBooksTemp = [];
  List<BookIntroduction> _markedBooks = [];


  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;


  @override
  void initState() {
    _dataIsLoading = true;
    _currentPage = 1;

    super.initState();

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e.toString());
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


  Future _initMarkedBooks() async {
    _customDio = await CustomDio.dio.get('dashboard/users/wish', queryParameters: {'page': _currentPage}, options: Options(headers: {'Authorization': 'Bearer 106|aF8aWGhal8EDHk9sBBdW2tMo8DcaV13vJKfqG5Lj'}));


    if (_customDio.statusCode == 200) {
      _customResponse = CustomResponse.fromJson(_customDio.data);

      _lastPage = _customResponse.data['last_page'];

      if (_currentPage == 1) {
        _markedBooks.clear();
      }

      for (Map<String, dynamic> bookIntroduction in _customResponse.data['data']) {
        _markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
      }

      setState(() {
        _markedBooksTemp.clear();
        _markedBooksTemp.addAll(_markedBooks);

        _dataIsLoading = false;
        refresh = false;
        loading = false;
      });
    }

    return _customDio;
  }



  @override
  Widget build(BuildContext context) {
    _refreshController = RefreshController(initialRefresh: false);

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
    return _dataIsLoading ? FutureBuilder(
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

    if(_connectionStatus == ConnectivityResult.none) {
      setState(() {
        _dataIsLoading = true;
      });

      return const Center(child: NoInternetConnection(),);
    } else {
      if (_markedBooksTemp.isEmpty) {
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

              if ((mode == LoadStatus.idle) && (_currentPage == _lastPage) && (!_dataIsLoading)) {
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
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                BookShortIntroduction(
                  book: _markedBooksTemp[index],
                ),
            itemCount: _markedBooksTemp.length,
            itemExtent: 15.8.h,
          ),
        );
      }
    }


  }

  late RefreshController _refreshController;


  bool refresh = false;
  bool loading = false;

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    try {
      if (_currentPage < _lastPage) {
        setState(() {
          loading = refresh ? false : true;

          if (loading) {
            _currentPage++;

            _initMarkedBooks();
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
