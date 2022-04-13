import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import '../../view_models/no_internet_connection.dart';
import '/model/category.dart';
import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../main.dart';
import '../../../model/book_introduction.dart';
import '../../view_models/custom_circular_progress_indicator.dart';
import '/model/book.dart';
import '/view/view_models/book_short_introduction.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';


class SubcategoryBooksPage extends StatefulWidget {
  late Subcategory subcategory;
  SubcategoryBooksPage({Key? key, required this.subcategory,}) : super(key: key);

  @override
  _SubcategoryBooksPageState createState() => _SubcategoryBooksPageState();
}

class _SubcategoryBooksPageState extends State<SubcategoryBooksPage> {
  late  bool _internetConnectionChecker;
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  late bool _dataIsLoading;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  List<BookIntroduction> _books = [];
  List<BookIntroduction> _booksTemp = [];

  late RefreshController _refreshController;

  late int _lastPage;
  late int _currentPage;


  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    _dataIsLoading = true;

    _currentPage = 1;

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

  Future _initSubcategoryBooks() async {
    _customDio = await CustomDio.dio.post('categories/${widget.subcategory.slug}', queryParameters: {'page': _currentPage},);

    if(_customDio.statusCode == 200) {
      _customResponse = CustomResponse.fromJson(_customDio.data);

      _lastPage = _customResponse.data['last_page'];

      if(_currentPage == 1) {
        _books.clear();
      }

      for(Map<String, dynamic> bookIntroduction in _customResponse.data['data']) {
        _books.add(BookIntroduction.fromJson(bookIntroduction));
      }

     setState(() {
       _booksTemp.clear();
       _booksTemp.addAll(_books);

       _dataIsLoading = false;
       refresh = false;
       loading = false;
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
    return _dataIsLoading ? FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? _innerBody()
            : Center(
            child: CustomCircularProgressIndicator(
                message: 'لطفاً شکیبا باشید.'));
      },
      future: _initSubcategoryBooks(),
    ) : _innerBody();
  }

  Widget _innerBody() {

    if(_connectionStatus == ConnectivityResult.none) {
      setState(() {
        _dataIsLoading = true;
      });

      return const Center(child: NoInternetConnection(),);
    } else {
      if(_booksTemp.isEmpty) {
        return const Center(
          child: Text('کتابی یافت نشد.'),
        );
      } else {
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: const MaterialClassicHeader(),
          footer: CustomFooter(
            builder: (BuildContext? context, LoadStatus? mode) {
              Widget body;
              if ((mode == LoadStatus.idle && _currentPage == _lastPage && !_dataIsLoading)) {
                print('mod 1');

                body = Text(
                  'کتاب دیگری یافت نشد.',
                  style: TextStyle(
                    color: Theme.of(context!).primaryColor,
                  ),
                );
              } else if (mode == LoadStatus.idle) {
                print('mod 2');


                body = Text(
                  'لطفاً صفحه را بالا بکشید.',
                  style: TextStyle(
                    color: Theme.of(context!).primaryColor,
                  ),
                );

              } else if (mode == LoadStatus.loading) {
                print('mod 3');

                body = Center(
                    child: CustomCircularProgressIndicator(
                        message: 'لطفاً شکیبا باشید.'));
              } else if (mode == LoadStatus.failed) {
                print('mod 4');

                body = Center(
                    child: CustomCircularProgressIndicator(
                        message: 'لطفاً دوباره امتحان کنید.'));
              } else if (mode == LoadStatus.canLoading) {
                print('mod 5');

                body = Center(
                    child: CustomCircularProgressIndicator(
                        message: 'لطفاً صفحه را پایین بکشید.'));
              } else {
                print('mod 6');

                body = Text(
                  'کتاب دیگری یافت نشد.',
                  style: TextStyle(
                    color: Theme.of(context!).primaryColor,
                  ),
                );
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: loading ? null : _onRefresh,
          onLoading: refresh ? null : _onLoading,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                BookShortIntroduction(book: _booksTemp[index],),
            itemCount: _booksTemp.length,
            //itemExtent: 15.8.h,
          ),
        );
      }
    }
  }

  bool refresh = false;
  bool loading = false;


  void _onRefresh() async {
    try {
      // monitor network fetch
      setState(() {
        refresh = loading ? false : true;
        if (refresh) {
          _currentPage = 1;

          _initSubcategoryBooks();

          print(_currentPage);
          print('refresh');
          print(refresh);
          print(loading);
        }
      });
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use refreshFailed()

      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  void _onLoading() async {
    try {
      if (_currentPage < _lastPage) {
        setState(() {
          loading = refresh ? false : true;

          if (loading) {
            _currentPage++;


            _initSubcategoryBooks();
          }
        });
      }
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use loadFailed(),if no data return,use LoadNodata()

      // if(mounted)
      //   setState(() {
      //
      //   });
      _refreshController.loadComplete();
    } catch (e) {
      _refreshController.loadFailed();
    }
  }

}
