import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaghaze_souti/controller/internet_connection.dart';
import 'package:kaghaze_souti/controller/load_data_from_api.dart';
import 'package:kaghaze_souti/view/view_models/custom_circular_progress_indicator.dart';
import 'package:kaghaze_souti/view/view_models/custom_smart_refresher.dart';
import 'package:kaghaze_souti/view/view_models/no_internet_connection.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import '../../../main.dart';
import '/model/book_introduction.dart';

import '../../../controller/custom_response.dart';
import '../../../controller/custom_dio.dart';
import '/view/view_models/book_short_introduction.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with InternetConnection, LoadDataFromAPI, Refresher {
  late TextEditingController _searchController;
  String? _searchKey;
  late List<BookIntroduction> _books;
  late List<BookIntroduction> _booksTemp;
  late List<BookIntroduction> _booksFound;
  late bool _dataIsLoadingToSearchForBooks;
  late bool _noBooksFound;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _books = [];
    _booksTemp = [];
    _booksFound = [];
    _dataIsLoadingToSearchForBooks = false;
    _noBooksFound = false;
  }

  Future _initBooks() async {
    customDio = await CustomDio.dio.post(
      'books',
      queryParameters: {'page': currentPage},
    );

    if (customDio.statusCode == 200) {
      customResponse = CustomResponse.fromJson(customDio.data);

      lastPage = customResponse.data['last_page'];

      if (currentPage == 1) {
        _booksTemp.clear();
      }

      for (Map<String, dynamic> book in customResponse.data['data']) {
        _booksTemp.add(BookIntroduction.fromJson(book));
      }

      setState(() {
        refresh = false;
        loading = false;

        _books.clear();
        _books.addAll(_booksTemp);

        dataIsLoading = false;
      });
    }

    return customDio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: playerBottomNavigationBar,
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
    if (dataIsLoading) {
      return FutureBuilder(
        future: _initBooks(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return _innerBody();
          } else {
            return Center(
              child: CustomCircularProgressIndicator(

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
    Widget _body = Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 5.0.w,
          ),
          child: _searchTextField(),
        ),
        const Divider(
          height: 0.0,
        ),
        _searchResults(),
      ],
    );

    if (connectionStatus == ConnectivityResult.none) {
      setState(() {
        dataIsLoading = true;
      });

      return const Center(
        child: NoInternetConnection(),
      );
    } else {
      if (MediaQuery.of(context).orientation == Orientation.landscape) {
        return SingleChildScrollView(child: _body);
      } else {
        return _body;
      }
    }
  }

  Padding _searchTextField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: false,
        controller: _searchController,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          helperText: 'عبارت جست و جو',
          hintText: 'لطفاً عبارت مورد نظر را بنویسید.',
          suffixIcon: Icon(Ionicons.search_outline),
        ),
        onChanged: (String text) {
          setState(() {
            if (_searchController.text.isEmpty) {
              _searchKey = null;
              _books.clear();
              _books.addAll(_booksTemp);
              _dataIsLoadingToSearchForBooks = false;
              _noBooksFound = false;
            } else {
              _searchKey = _searchController.text;
              _dataIsLoadingToSearchForBooks = true;

              _initBooksFound();
            }
          });
        },
      ),
    );
  }

  Widget _searchResults() {

    if (_searchKey == null) {
      return _notSearching();
    } else {
      if (_dataIsLoadingToSearchForBooks) {
        return FutureBuilder(
          future: _initBooksFound(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              if ((_noBooksFound) && (_searchKey != null)) {
                return Expanded(
                  child: Center(
                    child: Text(
                        'کتابی با عبارت جست و جوی «$_searchKey» یافت نشد.'),
                  ),
                );
              } else {
                return _isSearching();
              }
            } else {
              return const Expanded(
                child: Center(
                  child: CustomCircularProgressIndicator(

                  ),
                ),
              );
            }
          },
        );
      } else {
        return _isSearching();
      }
    }
  }

  Future _initBooksFound() async {
    customDio = await CustomDio.dio.post(
      'search',
      data: {'q': _searchController.text},
    );

    if (customDio.statusCode == 200) {
      customResponse = CustomResponse.fromJson(customDio.data);

      setState(() {
        if (customResponse.data['books'] == null) {
          _noBooksFound = true;
        } else {
          _booksFound.clear();

          for (Map<String, dynamic> book in customResponse.data['books']) {
            _booksFound.add(BookIntroduction.fromJson(book));
          }

          _books.clear();
          _books.addAll(_booksFound);

          _dataIsLoadingToSearchForBooks = false;
        }
      });
    }

    return customDio;
  }

  Widget _isSearching() {
    SingleChildScrollView _isSearching = SingleChildScrollView(
      child: Column(
        children: List.generate(
          _books.length,
              (index) => BookShortIntroduction(
            book: _books[index],
            searchKey: _searchKey,
          ),
        ),
      ),
    );

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return _isSearching;
    } else {
      return Expanded(
        child: _isSearching,
      );
    }
  }

  Widget _notSearching() {
    CustomSmartRefresher _notSearching = CustomSmartRefresher(
      refreshController: refreshController,
      onRefresh: () => onRefresh(() => _initBooks()),
      onLoading: () => onLoading(() => _initBooks()),
      list: List<BookShortIntroduction>.generate(
        _books.length,
            (index) => BookShortIntroduction(
          book: _books[index],
          searchKey: _searchKey,
        ),
      ),
      listType: 'کتاب',
      refresh: refresh,
      loading: loading,
      lastPage: lastPage,
      currentPage: currentPage,
      dataIsLoading: dataIsLoading,
    );

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return _notSearching;
    } else {
      return Expanded(
        child: _notSearching,
      );
    }
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