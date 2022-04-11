import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import '../../view_models/no_internet_connection.dart';
import '/model/book_introduction.dart';

import '../../../controller/custom_response.dart';
import '../../../controller/custom_dio.dart';
import '../../../main.dart';
import '../../view_models/custom_circular_progress_indicator.dart';
import '/model/book.dart';
import '/view/view_models/book_short_introduction.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late bool _internetConnectionChecker;
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  late bool _dataIsLoading;

  final TextEditingController _textEditingController = TextEditingController();
  late SearchTopic _searchTopic;
  late List<BookIntroduction> _booksTemp;
  late List<BookIntroduction> _books;

  late String _searchKey = '';
  late int _lastPage;
  late int _currentPage;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    _dataIsLoading = true;
    _searchTopic = SearchTopic.name;

    _books = [];
    _booksTemp = [];

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


  Future _initBooks() async {
    _customDio = await CustomDio.dio.post(
      'books',
      queryParameters: {'page': _currentPage},
    );

    if (_customDio.statusCode == 200) {
      _customResponse = CustomResponse.fromJson(_customDio.data);

      _lastPage = _customResponse.data['last_page'];

      if (_currentPage == 1) {
        _books.clear();
      }

      for (Map<String, dynamic> book in _customResponse.data['data']) {
        BookIntroduction _book = BookIntroduction.fromJson(book);
        _books.add(_book);
      }

      _booksTemp.clear();
      _booksTemp.addAll(_books);

      _dataIsLoading = false;

      setState(() {
        refresh = false;
        loading = false;

        print('load $loading');
        print('refresh $refresh');
      });
    }

    return _customDio;
  }

  @override
  Widget build(BuildContext context) {
    _refreshController = RefreshController(initialRefresh: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: PlayerBottomNavigationBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('جست و جو'),
      leading: const Icon(
        Ionicons.search_outline,
      ),
    );
  }

  Widget _body() {
    return _dataIsLoading
        ? FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.hasData
                  ? _innerBody()
                  : Center(
                      child: CustomCircularProgressIndicator(
                          message: 'لطفاً شکیبا باشید.'));
            },
            future: _initBooks(),
          )
        : _innerBody();
  }

  Widget _innerBody() {
    if(_connectionStatus == ConnectivityResult.none) {
      setState(() {
        _dataIsLoading = true;
      });

      return const Center(child: NoInternetConnection(),);
    } else {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 5.0.w,
            ),
            child: Column(
              children: [
                /* _selectASearchTopic(),
              const Divider(
                height: 32.0,
              ),*/
                _searchTextField(),
              ],
            ),
          ),
          const Divider(
            height: 0.0,
          ),
          _searchResults(),
        ],
      );
    }
  }

  Row _selectASearchTopic() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'جست و جو بر اساس: ${_searchTopic.title}',
        ),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () async => true,
                  child: SimpleDialog(
                    children: List<InkWell>.generate(
                      SearchTopic.values.length,
                      (index) => InkWell(
                        onTap: () {
                          setState(() {
                            _searchTopic = SearchTopic.values[index];

                            _booksUpdate();

                            Navigator.of(context).pop();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(SearchTopic.values[index].title!),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Icon(
            Ionicons.ellipsis_vertical_outline,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Padding _searchTextField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: false,
        controller: _textEditingController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          helperText: 'عبارت جست و جو',
          hintText: 'لطفاً عبارت مورد نظر را بنویسید.',
          errorText: false ? '' : null,
          suffixIcon: const Icon(Ionicons.search_outline),
        ),
        onChanged: (String text) {
          setState(() {
            if (_textEditingController.text.isEmpty) {
              _x = null;

              _booksTemp.clear();
              _booksTemp.addAll(_books);
              noKetab = false;
            } else {
              _x = _textEditingController.text;
              loadSearch = true;
              _initSearch();
            }
          });
        },
      ),
    );
  }

  String? _x;

  List<BookIntroduction> _searchBook = [];

  bool loadSearch = true;
  Future _initSearch() async {
    _customDio = await CustomDio.dio.post(
      'search',
      data: {'q': _textEditingController.text},
    );

    if (_customDio.statusCode == 200) {
      _customResponse = CustomResponse.fromJson(_customDio.data);

      setState(() {
        if (_customResponse.data['books'] == null) {
          noKetab = true;
        } else {
          _searchBook.clear();

          for (Map<String, dynamic> book in _customResponse.data['books']) {
            _searchBook.add(BookIntroduction.fromJson(book));
          }

          _booksTemp.clear();
          _booksTemp.addAll(_searchBook);

          loadSearch = false;
        }
      });
    }

    return _customDio;
  }

  bool noKetab = false;

  late RefreshController _refreshController;

  Widget _searchResults() {
    if (_x == null) {
      return ghablSerch();
    } else {
      return loadSearch ? FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.hasData
              ? ((noKetab) && (_x != null)
              ? Expanded(child: Center(child: Text('کتابی با عبارت جست و جوی «$_x» یافت نشد.'),),)
              : badSearch())
              : Expanded(child: Center(child: CustomCircularProgressIndicator(message: 'لطفاً شکیبا باشید.')));
        },
        future: _initSearch(),
      ) : badSearch();
    }

   /* if ((_booksTemp.isEmpty) && (_searchKey != '')) {
      return Expanded(
        child: Center(
          child: Text('کتابی با ${_searchTopic.title} «$_searchKey» یافت نشد.'),
        ),
      );
    } else {
      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              _booksTemp.length,
              (index) => BookShortIntroduction(
                book: _booksTemp[index],
                searchTopic: _searchTopic,
                searchKey: _searchKey,
              ),
            ),
          ),
        ),
      );
    }*/
  }

  Widget badSearch() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
            _booksTemp.length,
                (index) => BookShortIntroduction(
              book: _booksTemp[index],
              searchTopic: _searchTopic,
              searchKey: _searchKey,
            ),
          ),
        ),
      ),
    );
  }

  Widget ghablSerch() {
    return Expanded(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const MaterialClassicHeader(),
        footer: CustomFooter(
          builder: (BuildContext? context, LoadStatus? mode) {
            Widget body;
            if ((mode == LoadStatus.idle && _currentPage == _lastPage && !_dataIsLoading) ||
                _textEditingController.text.isNotEmpty) {
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
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              BookShortIntroduction(
            book: _booksTemp[index],
            searchTopic: _searchTopic,
            searchKey: _searchKey,
          ),
          itemCount: _booksTemp.length,
          itemExtent: 15.8.h,
        ),
      ),
    );
  }

  bool refresh = false;
  bool loading = false;

  void _onRefresh() async{
    // monitor network fetch
   // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

 /* void _onRefresh() async {
    setState(() {
      refresh = loading ? false : true;
      if (refresh) {
        _currentPage = 1;

        _initBooks();

        print(_currentPage);
        print('refresh');
        print(refresh);
        print(loading);
      }
    });
    await Future.delayed(Duration(milliseconds: 1000));
    if (_textEditingController.text.isEmpty) {
      try {
        // monitor network fetch
        setState(() {
          refresh = loading ? false : true;
          if (refresh) {
            _currentPage = 1;

            _initBooks();

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
    } else {
      try {
        // monitor network fetch
        setState(() {
          refresh = loading ? false : true;
          if (refresh) {
            _initSearch();
          }
        });
        await Future.delayed(Duration(milliseconds: 1000));
        // if failed,use refreshFailed()

        _refreshController.refreshCompleted();
      } catch (e) {
        _refreshController.refreshFailed();
      }
    }
  }*/

  void _onLoading() async {
    if (_textEditingController.text.isEmpty) {
      try {
        print('${_currentPage} xxxx');

        if (_currentPage < _lastPage) {
          setState(() {
            loading = refresh ? false : true;
            print('$loading xxxx');
            if (loading) {
              _currentPage++;

              print('xxxx');
              _initBooks();

              print(_currentPage);
              print('load');
              print(loading);
              print(refresh);
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
    } else {
      try {
        setState(() {
          loading = refresh ? false : true;

          if (loading) {
            _initSearch();
          }
        });
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

  void _booksUpdate() {
    setState(() {
      _searchKey = _textEditingController.text;

      if (_searchKey == '') {
        _booksTemp.clear();

        _booksTemp.addAll(_books);
      } else {
        switch (_searchTopic) {
          case SearchTopic.name:
            {
              _booksTemp.clear();

              _booksTemp.addAll(
                  _books.where((element) => element.name.contains(_searchKey)));

              break;
            }
          case SearchTopic.author:
            {
              _booksTemp.clear();

              _booksTemp.addAll(_books
                  .where((element) => element.author.contains(_searchKey)));

              break;
            }
          case SearchTopic.publisherOfPrintedVersion:
            {
              _booksTemp.clear();

              _booksTemp.addAll(_books.where((element) =>
                  element.publisherOfPrintedVersion.contains(_searchKey)));

              break;
            }
        }
      }
    });
  }
}

enum SearchTopic {
  name,
  author,
  publisherOfPrintedVersion,
}

extension SearchTopicExtension on SearchTopic {
  static const Map<SearchTopic, String> searchTopics = {
    SearchTopic.name: 'نام کتاب',
    SearchTopic.author: 'نام نویسنده',
    SearchTopic.publisherOfPrintedVersion: 'نام ناشر',
  };

  String? get title => searchTopics[this];
}
