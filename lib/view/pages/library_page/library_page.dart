import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kaghaze_souti/view/audio_player_models/audiobook_player_page.dart';
import 'package:kaghaze_souti/view/pages/library_page/book_chapters_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// import 'package:takfood_seller/controller/database.dart';
import '../../view_models/no_internet_connection.dart';
import '/main.dart';
import '/model/book.dart';
import '/view/view_models/book_introduction_page.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../model/book_introduction.dart';
import '../../view_models/custom_circular_progress_indicator.dart';
import '../login_pages/splash_page.dart';

class MyLibraryPage extends StatefulWidget {
  const MyLibraryPage({Key? key}) : super(key: key);

  @override
  _MyLibraryPageState createState() => _MyLibraryPageState();
}

class _MyLibraryPageState extends State<MyLibraryPage> {
  late bool _internetConnectionChecker;
  late Response<dynamic> _customDio;
  late CustomResponse customResponse;

  late bool _dataIsLoading;
  late int _lastPage;
  late int _currentPage;

  late List<BookIntroduction> _myBooksTemp;
  late List<BookIntroduction> _myBooks;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {

    _dataIsLoading = true;
    _currentPage = 1;
    _myBooksTemp = [];
    _myBooks = [];

    super.initState();
    _refreshController = RefreshController(initialRefresh: false);

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

  Future _initMyBooks() async {
    _customDio = await CustomDio.dio.get('dashboard/my_books', queryParameters: {'page': _currentPage},);

    print(_customDio.headers);
    if (_customDio.statusCode == 200) {
      Map<String, dynamic> data = _customDio.data;

      if(_currentPage == 1) {
        _myBooks.clear();
      }

      _lastPage = data['last_page'];

      for (Map<String, dynamic> bookIntroduction in data['data']) {
        _myBooks.add(BookIntroduction.fromJson(bookIntroduction));
      }

      setState(() {
        _myBooksTemp.clear();
        _myBooksTemp.addAll(_myBooks);

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
      title: const Text('کتابخانه من'),
      leading: const Icon(
        Ionicons.library_outline,
      ),
    );
  }

  FutureBuilder _body() {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CustomCircularProgressIndicator(message: 'لطفاً شکیبا باشید.'));
        } else {
          return (_connectionStatus == ConnectivityResult.none)
              ? const Center(child: NoInternetConnection(),)
              : _innerBody();
        }
      },
      future: _initMyBooks(),
    );
  }

  Widget _innerBody() {
    if (_connectionStatus == ConnectivityResult.none) {
      setState(() {
        _dataIsLoading = true;
      });

      return const Center(child: NoInternetConnection(),);
    } else {
      if (_myBooksTemp.isEmpty) {
        return const Center(
          child: Text('کتابی در کتابخانه شما موجود نمی باشد.'),
        );
      } else {
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: const MaterialClassicHeader(),
          footer: CustomFooter(
            builder: (BuildContext? context, LoadStatus? mode) {
              Widget bar;

              if ((mode == LoadStatus.idle) && (_currentPage == _lastPage) &&
                  (!_dataIsLoading)) {
                bar = Text(
                  'کتاب دیگری یافت نشد.',
                  style: TextStyle(
                    color: Theme
                        .of(context!)
                        .primaryColor,
                  ),
                );
              } else if (mode == LoadStatus.idle) {
                bar = Text('لطفاً صفحه را بالا بکشید.',
                    style: TextStyle(color: Theme
                        .of(context!)
                        .primaryColor));
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
                  style: TextStyle(color: Theme
                      .of(context!)
                      .primaryColor),
                );
              }

              return SizedBox(
                height: 55.0,
                child: Center(child: bar),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: loading ? null : _onRefresh,
          onLoading: refresh ? null : _onLoading,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                MyBook(
                  book: _myBooksTemp[index],
                ),
            itemCount: _myBooksTemp.length,
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
    try {
      // monitor network fetch
      setState(() {
        refresh = loading ? false : true;
        if (refresh) {
          _currentPage = 1;

          _initMyBooks();

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
