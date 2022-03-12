import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/controller/database.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/model/book.dart';
import 'package:takfood_seller/model/user.dart';
import 'package:takfood_seller/view/view_models/audiobook_player_page.dart';
import 'package:takfood_seller/view/view_models/book_introduction_page.dart';
import 'package:takfood_seller/view/view_models/player_bottom_navigation_bar.dart';
import 'package:sizer/sizer.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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

  Widget _body() {
    if (database.user.library.isEmpty) {
      return const Center(
        child: Text('کتابی در کتابخانه شما موجود نمی باشد.'),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: List<MyBook>.generate(
            database.user.library.length,
            (index) => MyBook(
              book: database.user.library[index],
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
    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      shape: Theme.of(context).cardTheme.shape,
      child: Row(
        children: [
          _bookCover(),
          _bookShortInformation(),
          _navigatorButtons(context),
        ],
      ),
    );
  }

  Padding _bookCover() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              widget.book.bookCoverPath,
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
          shape: BoxShape.rectangle,
        ),
        width: 25.0.w,
        height: 13.0.h,
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

  SizedBox _navigatorButtons(BuildContext context) {
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
  }
}
