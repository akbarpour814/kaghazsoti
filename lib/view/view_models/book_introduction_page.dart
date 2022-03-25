import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:zarinpal/zarinpal.dart';
import '/main.dart';
import '/model/book.dart';
import '/view/pages/profile_page/cart_page.dart';
import '/view/view_models/audiobook_player_page.dart';
import '/view/view_models/books_list_view.dart';
import '/view/view_models/property.dart';
import 'package:sizer/sizer.dart';

import '/controller/database.dart';
import '/controller/custom_dio.dart';
import 'player_bottom_navigation_bar.dart';

class BookIntroductionPage extends StatefulWidget {
  late Book book;

  BookIntroductionPage({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  _BookIntroductionPageState createState() => _BookIntroductionPageState();
}

class _BookIntroductionPageState extends State<BookIntroductionPage>
    with TickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  late TabController _tabController;
  late int _tabIndex;
  late bool _commentPosted;

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,
    );

    _tabIndex = 0;

    _commentPosted = false;

    super.initState();
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
      title: Text(widget.book.name),
      leading: InkWell(
        child: Icon(
          Ionicons.bookmark_outline,
          color: markedUser.contains(widget.book.id) ? Colors.pinkAccent : Colors.white,
        ),
        onTap: () {
          setState(() {
            int index = markedUser.indexWhere((element) => element == widget.book.id);

            if(index >= 0) {
              widget.book.marked = false;

              markedUser.removeAt(index);
            } else {
              widget.book.marked = true;

              //markedUser.add(widget.book);
            }
          });
        },
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

  void mark(int id) async {
    await CustomDio.dio.post('dashboard/users/wish', data: {'book_id': id}, options: Options(headers: headers));
  }

  SingleChildScrollView _body() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0.w,),
            child: Column(
              children: [
                _bookCover(),
                _bookPricesAndVotes(),
                _purchaseButtons(),
                _tabsTopic(),
                _tab(_tabIndex),
              ],
            ),
          ),
          _otherPublisherBooks(),
          _relatedBooks(),
        ],
      ),
    );
  }

  Stack _bookCover() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
            shape: BoxShape.rectangle,
          ),
          width: 70.0.w,
          height: 70.0.w,
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
        Positioned(
          left: 2.5.w,
          bottom: 2.5.w,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                audiobookInPlay = widget.book;

                //audioPlayer.setUrl(widget.book.demo);
                audioPlayer.setUrl(widget.book.demo);

                // audioIsPlaying.$ = true;
                //
                // audioPlayer.play();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AudiobookPlayerPage();
                    },
                  ),
                );
              });
            },
            child: const Icon(
              Ionicons.play_outline,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Padding _bookPricesAndVotes() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: 70.0.w,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  ''.padLeft(widget.book.numberOfStars, '\u2605'),
                  style: Theme
                      .of(context)
                      .textTheme
                      .caption
                      ?.copyWith(
                    color: Colors.amber,
                  ),
                ),
                Text(
                  '${widget.book.numberOfVotes.toString()} رای',
                  style: Theme
                      .of(context)
                      .textTheme
                      .caption,
                )
              ],
            ),
            Text(
              '${widget.book.price.toString()} تومان',
              style: Theme
                  .of(context)
                  .textTheme
                  .headline5,
            ),
          ],
        ),
      ),
    );
  }

  Row _purchaseButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 42.5.w,
          child: ElevatedButton.icon(
            onPressed: () {


            },
            label: const Text('خرید'),
            icon: const Icon(Ionicons.card_outline),
          ),
        ),
        SizedBox(
          width: 42.5.w,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const CartPage();
                  },
                ),
              );
            },
            label: const Text('سبد خرید'),
            icon: const Icon(
                Ionicons.cart_outline
            ),
          ),
        ),
      ],
    );
  }

  Padding _tabsTopic() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: Theme
            .of(context)
            .primaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(5.0)),
        child: DefaultTabController(
          length: 3,
          child: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFFC6DADE),
            indicatorWeight: 3.0,
            tabs: const <Tab>[
              Tab(
                text: 'مشخصات',
              ),
              Tab(
                text: 'درباره کتاب',
              ),
              Tab(
                text: 'ثبت نظر',
              ),
            ],
            onTap: (index) {
              setState(() {
                _tabIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _tab(int index) {
    OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme
            .of(context)
            .primaryColor,
      ),
      borderRadius: BorderRadius.circular(5.0),
    );

    Container _bookSpecifications = Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme
            .of(context)
            .primaryColor),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5.0)),
      ),
      child: Column(
        children: [
          Property(
            property: 'نام',
            value: widget.book.name,
            valueInTheEnd: false,
            lastProperty: false,
          ),
          Property(
            property: 'دسته',
            value: '${widget.book.category} - ${widget.book.subcategory}',
            valueInTheEnd: false,
            lastProperty: false,
          ),
          Property(
            property: 'نویسنده',
            value: widget.book.author,
            valueInTheEnd: false,
            lastProperty: false,
          ),
          Property(
            property: 'گوینده',
            value: widget.book.announcer,
            valueInTheEnd: false,
            lastProperty: false,
          ),
          Property(
            property: 'حجم دانلود',
            value: widget.book.fileSize.toString(),
            valueInTheEnd: false,
            lastProperty: false,
          ),
          Property(
            property: 'ناشر چاپی',
            value: widget.book.publisherOfPrintedVersion,
            valueInTheEnd: false,
            lastProperty: false,
          ),
          Property(
            property: 'سال انتشار چاچی',
            value: widget.book.printedVersionYear.toString(),
            valueInTheEnd: false,
            lastProperty: false,
          ),
          Property(
            property: 'ناشر صوتی',
            value: widget.book.publisherOfAudioVersion,
            valueInTheEnd: false,
            lastProperty: false,
          ),
          Property(
            property: 'سال انتشار صوت',
            value: widget.book.audioVersionYear.toString(),
            valueInTheEnd: false,
            lastProperty: false,
          ),
          Property(
            property: 'تعداد فصل',
            value: widget.book.numberOfChapters.toString(),
            valueInTheEnd: false,
            lastProperty: false,
          ),
          Property(
            property: 'تعداد صفحات',
            value: widget.book.numberOfPages.toString(),
            valueInTheEnd: false,
            lastProperty: false,
          ),
          Property(
            property: 'زمان پخش یا مطالعه',
            value: widget.book.duration,
            valueInTheEnd: false,
            lastProperty: false,
          ),
          Property(
            property: 'مبلغ',
            value: '${widget.book.price.toString()} تومان',
            valueInTheEnd: false,
            lastProperty: true,
          ),
        ],
      ),
    );
    Container _aboutBook = Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme
            .of(context)
            .primaryColor),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.book.aboutBook,
            textAlign: TextAlign.justify,
          ),
          Center(
            child: Divider(
              height: 10.0.h,
              thickness: 1.0,
            ),
          ),
          Center(
            child: Text(
              'قسمتی از کتاب ${widget.book.name}',
              style: Theme
                  .of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: Theme
                  .of(context)
                  .primaryColor),
            ),
          ),
          SizedBox(
            height: 2.5.h,
          ),
          Text(
            widget.book.partOfTheBook,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
    Container _comments = Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme
            .of(context)
            .primaryColor),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('نظر خود را بنویسید.'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<InkWell>.generate(
                5,
                    (index) =>
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.star,
                        size: 25.0.sp,
                        color: Colors.amber.withOpacity(0.4),
                      ),
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                border: _outlineInputBorder,
                focusedBorder: _outlineInputBorder,
                disabledBorder: _outlineInputBorder,
                enabledBorder: _outlineInputBorder,
                errorBorder: _outlineInputBorder,
                focusedErrorBorder: _outlineInputBorder,
              ),
              maxLines: 8,
              cursorColor: Theme
                  .of(context)
                  .dividerColor
                  .withOpacity(0.6),
              cursorWidth: 1.0,
            ),
          ),
          Center(
            child: Center(
              child: SizedBox(
                width: 100.0.w - (2 * 18.0) - (2 * 5.0.w),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _commentPosted =
                      _commentPosted ? false : true;
                    });
                  },
                  label: Text(_commentPosted
                      ? 'نظر شما ثبت شد'
                      : 'ثبت نظر',),
                  icon: Icon(_commentPosted
                      ? Ionicons.checkmark_done_outline
                      : Ionicons.checkmark_outline),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    late final List<Container> _tabs = [
      _bookSpecifications,
      _aboutBook,
      _comments,
    ];

    return _tabs[index];
  }

  Visibility _otherPublisherBooks() {
    return Visibility(
      visible: widget.book.otherBooksByThePublisher.isNotEmpty,
      child: _otherBooks(
        'کتاب های دیگر ناشر',
        widget.book.otherBooksByThePublisher,
      ),
    );
  }

  Visibility _relatedBooks() {
    return Visibility(
      visible: widget.book.relatedBooks.isNotEmpty,
      child: _otherBooks(
        'کتاب های مرتبط',
        widget.book.relatedBooks,
      ),
    );
  }

  Padding _otherBooks(String title, List<Book> books) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                ),
                Divider(
                  height: 4.0.h,
                  thickness: 1.0,
                ),
              ],
            ),
          ),
          BooksListView(books: books)
        ],
      ),
    );
  }
}
