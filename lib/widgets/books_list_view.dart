//------/dart and flutter packages
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//------/packages
export 'package:flutter_screenutil/flutter_screenutil.dart';

//------/model
import 'book_introduction/book_introduction_model.dart';

//------/view/view_models
import '../pages/book/book_page.dart';

//------/main
import '/main.dart';
import 'fade_in_image_widget.dart';

// ignore: must_be_immutable
class BooksListView extends StatelessWidget {
  late List<BookIntroductionModel> books;

  BooksListView({
    Key? key,
    required this.books,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int numberOfChildren = (100.0.w / 170.0).ceil();

    return SizedBox(
      height: 160.0.r,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          books.length >= numberOfChildren + 4
              ? numberOfChildren + 4
              : books.length,
          (index) => Padding(
            padding: EdgeInsets.only(
              left: 20.0,
              right: index == 0 ? 20.0 : 0.0,
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) {
                      return BookPage(book: books[index]);
                    },
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
                 width: 130.0.r,
                height: 160.0.r,
                child: _bookCover(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _bookCover(int index) {
    return SizedBox(
      width: 130.0.r,
      height: 160.0.r,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5.0),),
        child: FadeInImageWidget(
          image: books[index].bookCoverPath,
        ),
      ),
    );
  }

  // Expanded _bookName(int index, BuildContext context) {
  //   return Expanded(
  //     child: Center(
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //         child: Text(
  //           books[index].name,
  //           style: TextStyle(color: Theme.of(context).primaryColor),
  //           maxLines: 1,
  //           textAlign: TextAlign.center,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
