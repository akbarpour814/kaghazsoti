import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:takfood_seller/model/book.dart';
import 'package:takfood_seller/view/view_models/book_introduction_page.dart';
import 'package:sizer/sizer.dart';

import '../../main.dart';

class BooksListView extends StatelessWidget {
  late List<Book> books;

  BooksListView({
    Key? key,
    required this.books,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22.0.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          books.length >= 5 ? 5 : books.length,
          (index) => Padding(
            padding: EdgeInsets.only(
              left: 5.0.w,
              right: index == 0 ? 5.0.w : 0.0,
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
                width: 35.0.w,
                height: 22.0.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _bookCover(index),
                    Divider(
                      height: 0.0,
                      thickness: 1.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    _bookName(index),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _bookCover(int index) {
    return Container(
      //color: Colors.white,
      width: 35.0.w,
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

  Expanded _bookName(int index) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            books[index].name,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
