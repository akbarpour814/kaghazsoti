import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:takfood_seller/controller/database.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/model/book.dart';
import 'package:takfood_seller/model/user.dart';
import 'package:takfood_seller/view/view_models/audiobook_player_page.dart';
import 'package:takfood_seller/view/view_models/book_introduction_page.dart';
import 'package:takfood_seller/view/view_models/player_bottom_navigation_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../model/book_introduction.dart';
import '../../view_models/custom_circular_progress_indicator.dart';

class MyLibraryPage extends StatefulWidget {
  const MyLibraryPage({Key? key}) : super(key: key);

  @override
  _MyLibraryPageState createState() => _MyLibraryPageState();
}

class _MyLibraryPageState extends State<MyLibraryPage> {
  late  bool _internetConnectionChecker;
  late Response<dynamic> _customDio;
  late CustomResponse customResponse;

  late List<BookIntroduction> _myBooks;

  @override
  void initState() {
    _myBooks = [];

    super.initState();
  }

  Future _initMyBooks() async {
    _customDio = await CustomDio.dio.get('dashboard/my_books');

    if(_customDio.statusCode == 200) {
      _myBooks.clear();

      Map<String, dynamic> data = _customDio.data;

      int lastPage = data['last_page'];

      for(Map<String, dynamic> bookIntroduction in data['data']) {
        _myBooks.add(BookIntroduction.fromJson(bookIntroduction));
      }

      for(int i = 2; i <= lastPage; ++i) {
        _customDio = await CustomDio.dio.get('dashboard/my_books', queryParameters: {'page': i},);

        if(_customDio.statusCode == 200) {
          data = _customDio.data;

          for(Map<String, dynamic> bookIntroduction in data['data']) {
            _myBooks.add(BookIntroduction.fromJson(bookIntroduction));
          }
        }
      }
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
    return FutureBuilder(builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { return snapshot.hasData ? _innerBody() : const Center(child: CustomCircularProgressIndicator());}, future: _initMyBooks(),);
  }

  Widget _innerBody() {
    if (_myBooks.isEmpty) {
      return const Center(
        child: Text('کتابی در کتابخانه شما موجود نمی باشد.'),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
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
          previousAudiobookInPlayId = audiobookInPlay == null ? -1 : audiobookInPlay!.id;

          audiobookInPlay = widget.book;

          audiobookInPlayId = -1;
          player.stop();
          audioPlayer.stop();
          demoPlayer.stop();

          audioIsPlaying.$ = false;
          playing.$ = false;
          demoIsPlaying.$ = false;

          audioPlayer = AudioPlayer();

          player = audioPlayer;

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AudiobookPlayerPage();
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
