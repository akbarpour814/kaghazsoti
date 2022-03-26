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
import '../../view_models/custom_circular_progress_indicator.dart';

class MyLibraryPage extends StatefulWidget {
  const MyLibraryPage({Key? key}) : super(key: key);

  @override
  _MyLibraryPageState createState() => _MyLibraryPageState();
}

class _MyLibraryPageState extends State<MyLibraryPage> {
  late Response<dynamic> _customDio;
  late CustomResponse customResponse;

  late List<Book> _myBooks;

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

      for(Map<String, dynamic> book in data['data']) {
        _customDio = await CustomDio.dio.post('books/${book['slug']}');

        if(_customDio.statusCode == 200) {
          customResponse = CustomResponse.fromJson(_customDio.data);

          _myBooks.add(Book.fromJson(customResponse.data));
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
      bottomNavigationBar: const PlayerBottomNavigationBar(),
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
  late Book book;

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
          audiobookInPlay = widget.book;

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const AudiobookPlayerPage();
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

  /*SizedBox _navigatorButtons(BuildContext context) {
    return SizedBox(
      height: 13.0.h,
      width: 15.0.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _navigatorToAudiobookPlayerPage(context),
          _navigatorToBookIntroductionPage(context),
        ],
      ),
    );
  }

  Flexible _navigatorToAudiobookPlayerPage(BuildContext context) {
    return Flexible(
      child: InkWell(
        child: Icon(
          Ionicons.play_circle_outline,
          color: Theme.of(context).primaryColor,
        ),
        onTap: () {
          setState(() {
            audiobookInPlay = widget.book;
          });

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const AudiobookPlayerPage();
              },
            ),
          );
        },
      ),
    );
  }

  Flexible _navigatorToBookIntroductionPage(BuildContext context) {
    return Flexible(
      child: InkWell(
        child: Icon(
          Ionicons.information_circle_outline,
          color: Theme.of(context).primaryColor,
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return BookIntroductionPage(book: widget.book);
              },
            ),
          );
        },
      ),
    );
  }*/
}
