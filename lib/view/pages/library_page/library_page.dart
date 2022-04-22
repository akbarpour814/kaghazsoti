import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaghaze_souti/controller/internet_connection.dart';
import 'package:kaghaze_souti/controller/load_data_from_api.dart';
import 'package:kaghaze_souti/view/audio_player_models/audiobook_player_page.dart';
import 'package:kaghaze_souti/view/view_models/custom_smart_refresher.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../view_models/custom_snack_bar.dart';
import '../../view_models/no_internet_connection.dart';
import '/main.dart';

import 'package:sizer/sizer.dart';

import '../../../controller/custom_dio.dart';
import '../../../model/book_introduction.dart';
import '../../view_models/custom_circular_progress_indicator.dart';

class MyLibraryPage extends StatefulWidget {
  static const routeName = '/myLibraryPage';

  const MyLibraryPage({Key? key}) : super(key: key);

  @override
  _MyLibraryPageState createState() => _MyLibraryPageState();
}

class _MyLibraryPageState extends State<MyLibraryPage>
    with InternetConnection, LoadDataFromAPI, Refresher {
  late List<BookIntroduction> _myBooks;
  late List<BookIntroduction> _myBooksTemp;

  @override
  void initState() {
    super.initState();

    _myBooks = [];
    _myBooksTemp = [];
  }

  Future _initMyBooks() async {
    customDio = await CustomDio.dio.get(
      'dashboard/my_books',
      queryParameters: {'page': currentPage},
    );

    if (customDio.statusCode == 200) {
      Map<String, dynamic> data = customDio.data;

      lastPage = data['last_page'];

      if (currentPage == 1) {
        _myBooksTemp.clear();
      }

      for (Map<String, dynamic> bookIntroduction in data['data']) {
        _myBooksTemp.add(BookIntroduction.fromJson(bookIntroduction));
      }

      setState(() {
        refresh = false;
        loading = false;

        _myBooks.clear();
        _myBooks.addAll(_myBooksTemp);

        dataIsLoading = false;
      });
    }

    print('ModalRoute.of(context).settings.name');
    print(ModalRoute.of(context)!.settings.name);

    return customDio;
  }

  bool _secondTime = false;
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

  Widget _body() {
    if (dataIsLoading) {
      return FutureBuilder(
        future: _initMyBooks(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData) {
            return _innerBody();
          } else {
            return const Center(child: CustomCircularProgressIndicator());
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
      if (_myBooks.isEmpty) {
        return const Center(
          child: Text('کتابی در کتابخانه شما موجود نمی باشد.'),
        );
      } else {
        return CustomSmartRefresher(
          refreshController: refreshController,
          onRefresh: () => onRefresh(() => _initMyBooks()),
          onLoading: () => onLoading(() => _initMyBooks()),
          list: List<MyBook>.generate(
            _myBooks.length,
                (index) => MyBook(
              book: _myBooks[index],
            ),
          ),
          listType: 'کتاب',
          refresh: refresh,
          loading: loading,
          lastPage: lastPage,
          currentPage: currentPage,
          dataIsLoading: dataIsLoading,
        );
      }
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
        if (widget.book.id != previousAudiobookInPlayId) {
          audioPlayerHandler.onTaskRemoved();
          audioPlayerHandler.seek(Duration(microseconds: 0));

          demoOfBookIsPlaying.$ = false;
          demoInPlayId = -1;
          demoPlayer.stop();
          audioPlayerHandler.stop();

          mediaItems.clear();

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
      },
      child:  Card(
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
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          widget.book.author,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
