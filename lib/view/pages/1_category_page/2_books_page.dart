import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/model/book.dart';
import 'package:takfood_seller/model/category.dart';
import 'package:takfood_seller/view/view_models/book_short_introduction.dart';
import 'package:takfood_seller/view/view_models/category_name.dart';
import 'package:takfood_seller/view/view_models/player_bottom_navigation_bar.dart';

class BooksPage extends StatefulWidget {
  late String title;
  late List<Book> books;
  BooksPage({Key? key, required this.title, required this.books,}) : super(key: key);

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
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
      title: Text(widget.title),
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

  SingleChildScrollView _body() {
    return SingleChildScrollView(
      child: Column(
        children: List<BookShortIntroduction>.generate(
          widget.books.length,
              (index) => BookShortIntroduction(book: widget.books[index],),
        ),
      ),
    );
  }
}
