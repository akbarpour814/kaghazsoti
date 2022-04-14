import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaghaze_souti/controller/internet_connection.dart';
import 'package:kaghaze_souti/controller/load_data_from_api.dart';
import 'package:kaghaze_souti/view/audio_player_models/audiobook_player_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../view_models/no_internet_connection.dart';
import '/main.dart';

import 'package:sizer/sizer.dart';

import '../../../controller/custom_dio.dart';
import '../../../model/book_introduction.dart';
import '../../view_models/custom_circular_progress_indicator.dart';

class MyLibraryPage extends StatefulWidget {
  const MyLibraryPage({Key? key}) : super(key: key);

  @override
  _MyLibraryPageState createState() => _MyLibraryPageState();
}

class _MyLibraryPageState extends State<MyLibraryPage> with InternetConnection, LoadDataFromAPI {
  late RefreshController _refreshController;
  late bool _refresh;
  late bool _loading;
  late int _lastPage;
  late int _currentPage;

  late List<BookIntroduction> _myBooks;
  late List<BookIntroduction> _myBooksTemp;

  @override
  void initState() {
    super.initState();

    _refreshController = RefreshController(initialRefresh: false);
    _refresh = false;
    _loading = false;
    _currentPage = 1;

    _myBooks = [];
    _myBooksTemp = [];
  }

  Future _initMyBooks() async {
    customDio = await CustomDio.dio.get(
      'dashboard/my_books',
      queryParameters: {'page': _currentPage},
    );

    if (customDio.statusCode == 200) {
      Map<String, dynamic> data = customDio.data;

      _lastPage = data['last_page'];

      if (_currentPage == 1) {
        _myBooksTemp.clear();
      }

      for (Map<String, dynamic> bookIntroduction in data['data']) {
        _myBooksTemp.add(BookIntroduction.fromJson(bookIntroduction));
      }

      setState(() {
        dataIsLoading = false;

        _refresh = false;
        _loading = false;

        _myBooks.clear();
        _myBooks.addAll(_myBooksTemp);
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
      title: const Text('کتابخانه من'),
      leading: const Icon(
        Ionicons.library_outline,
      ),
    );
  }

  FutureBuilder _body() {
    return FutureBuilder(
      future: _initMyBooks(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CustomCircularProgressIndicator(

            ),
          );
        } else {
          if (connectionStatus == ConnectivityResult.none) {
            return const Center(
              child: NoInternetConnection(),
            );
          } else {
            return _innerBody();
          }
        }
      },
    );
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
      if (_myBooks.isEmpty) {
        return const Center(
          child: Text('کتابی در کتابخانه شما موجود نمی باشد.'),
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
                  (!dataIsLoading)) {
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
            children: List<MyBook>.generate(
              _myBooks.length,
              (index) => MyBook(
                book: _myBooks[index],
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

          _initMyBooks();
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

            _initMyBooks();
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
class MyBook extends StatefulWidget {
  late BookIntroduction book;

  MyBook({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  _MyBookState createState() => _MyBookState();
}

class _MyBookState extends State<MyBook> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          if (widget.book.id != previousAudiobookInPlayId) {
            demoIsPlaying.$ = false;
            demoInPlayId = -1;
            demoPlayer.stop();

            audioPlayerHandler.updateQueue([]);
            audiobookInPlay = widget.book;
            audiobookInPlayId = widget.book.id;
          }

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AudiobookPlayerPage(audiobook: widget.book);
              },
            ),
          );
        });
      },
      child: Card(
        color: Colors.transparent,
        elevation: 0.0,
        shape: Theme.of(context).cardTheme.shape,
        child: Row(
          children: [
            _bookCover(),
            _bookShortInformation(),
          ],
        ),
      ),
    );
  }

  Padding _bookCover() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
          shape: BoxShape.rectangle,
        ),
        width: 25.0.w,
        height: 13.0.h,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
          child: FadeInImage.assetNetwork(
            placeholder: defaultBookCover,
            image: widget.book.bookCoverPath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Expanded _bookShortInformation() {
    return Expanded(
      child: ListTile(
        title: Text(
          widget.book.name,
        ),
        subtitle: Text(
          '${widget.book.author}\n\n${widget.book.duration}',
        ),
      ),
    );
  }
}
