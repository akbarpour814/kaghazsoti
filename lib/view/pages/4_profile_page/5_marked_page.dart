import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/model/book.dart';
import 'package:takfood_seller/model/user.dart';
import 'package:takfood_seller/view/view_models/book_short_introduction.dart';
import 'package:takfood_seller/view/view_models/player_bottom_navigation_bar.dart';

import '../../../controller/database.dart';

class MarkedPage extends StatefulWidget {
  const MarkedPage({
    Key? key
  }) : super(key: key);

  @override
  _MarkedPageState createState() => _MarkedPageState();
}

class _MarkedPageState extends State<MarkedPage> {
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
      title: const Text('نشان شده ها'),
      automaticallyImplyLeading: false,
      leading: const Icon(
        Ionicons.bookmark_outline,
      ),
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
    if (database.user.markedBooks.isEmpty) {
      return const Center(
        child: Text('شما تا کنون کتابی را نشان نکرده اید.'),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: List.generate(
            database.user.markedBooks.length,
            (index) => BookShortIntroduction(
              book: database.user.markedBooks[index],
            ),
          ),
        ),
      );
    }
  }
}
