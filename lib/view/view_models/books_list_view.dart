import 'package:flutter/material.dart';
import '/view/view_models/book_introduction_page.dart';
import 'package:sizer/sizer.dart';

import '../../main.dart';
import '../../model/book_introduction.dart';

// ignore: must_be_immutable
class BooksListView extends StatelessWidget {
  late List<BookIntroduction> books;

  BooksListView({
    Key? key,
    required this.books,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int numberOfChildren = (100.0.w / 170.0).ceil();

    return SizedBox(
      height: 22.0.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          books.length >= numberOfChildren + 4 ? numberOfChildren + 4 : books.length,
          (index) => Padding(
            padding: EdgeInsets.only(
              left: 20.0,
              right: index == 0 ? 20.0 : 0.0,
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return BookIntroductionPage(book: books[index]);
                    },
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
                width: 150.0,
                height: 22.0.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _bookCover(index),
                    Divider(
                      height: 0.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    _bookName(index, context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _bookCover(int index) {
    return SizedBox(
      width: 150.0,
      height: 18.0.h,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(5.0),
        ),
        child: FadeInImage.assetNetwork(
          placeholder: defaultBookCover,
          image: books[index].bookCoverPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Expanded _bookName(int index, BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            books[index].name,
            style: TextStyle(color: Theme.of(context).primaryColor),
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
