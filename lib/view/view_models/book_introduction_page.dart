import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/view/pages/profile_page/marked_page.dart';
import 'package:takfood_seller/view/view_models/show_stars.dart';
import 'package:zarinpal/zarinpal.dart';
import '../../controller/custom_response.dart';
import '../pages/category_page/books_page.dart';
import '/main.dart';
import '/model/book.dart';
import '/view/pages/profile_page/cart_page.dart';
import '/view/view_models/audiobook_player_page.dart';
import '/view/view_models/books_list_view.dart';
import '/view/view_models/property.dart';
import 'package:sizer/sizer.dart';

import '/controller/database.dart';
import '/controller/custom_dio.dart';
import 'custom_circular_progress_indicator.dart';
import 'custom_snack_bar.dart';
import 'player_bottom_navigation_bar.dart';
import 'progress_bar/playOrPauseController.dart';

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
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  TextEditingController _commentController = TextEditingController();
  String? _commentError;
  late TabController _tabController;
  late int _tabIndex;
  late bool _commentPosted;
  late List<bool> _displayOfDetails;
  late int _previousIndex;
  late int _numberOfStars;
  late List<bool> _stars;

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _tabIndex = 0;
    _commentPosted = false;
    _displayOfDetails = List<bool>.generate(widget.book.reviews.length, (index) => false);
    _previousIndex = -1;
    _numberOfStars = 0;
    _stars = List<bool>.generate(5, (index) => false);

    super.initState();
  }

  Future _initRelatedBooks() async {
    widget.book.relatedBooks.clear();

    for(String slug in widget.book.relatedBooksSlug) {
      _customDio = await CustomDio.dio.post('books/$slug');

      if(_customDio.statusCode == 200) {
        _customResponse = CustomResponse.fromJson(_customDio.data);

        widget.book.relatedBooks.add(Book.fromJson(_customResponse.data));
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
      title: Text(widget.book.name),
      leading: InkWell(
        child: Icon(
          Ionicons.bookmark_outline,
          color: markedBooksId.contains(widget.book.id) ? Colors.pinkAccent : Colors.white,
        ),
        onTap: () {
          setState(() {
            _setMarkedBooks();

            if(markedBooksId.contains(widget.book.id)) {
              widget.book.marked = false;

              markedBooksId.remove(widget.book.id);
            } else {
              widget.book.marked = true;

              markedBooksId.add(widget.book.id);
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

  void _setMarkedBooks() async {
    await CustomDio.dio.post('dashboard/users/wish', data: {'book_id': widget.book.id});
  }

  FutureBuilder _body() {
    return FutureBuilder(
      builder:
          (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? _innerBody()
            : const Center(child: CustomCircularProgressIndicator());
      },
      future: _initRelatedBooks(),
    );
  }

  SingleChildScrollView _innerBody() {
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
          _userComments(),
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
          /*child: FloatingActionButton(
            onPressed: () {
              setState(() {
                audioIsPlaying.$ = true;
                demoIsPlaying.$ = true;

                audioPlayer.setUrl(widget.book.demo);

                audioPlayer.play();
              });
            },
            child: const Icon(
              Ionicons.play_outline,
              color: Colors.white,
            ),
          ),*/
          child: PlayOrPauseController(
            playerBottomNavigationBar: false,
            bookIntroductionPage: true,
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
                ShowStars(numberOfStars: widget.book.numberOfStars,),
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
              widget.book.price,
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
            indicatorWeight: 3.0,
            tabs: const <Tab>[
              Tab(
                text: 'مشخصات',
              ),
              Tab(
                text: 'درباره کتاب',
              ),
              Tab(
                text: 'نظرات',
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
            value: widget.book.price,
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
                  .primaryColor,
              ),
              textAlign: TextAlign.center,
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
          Text('نظر شما:', style: TextStyle(color: Theme.of(context).primaryColor),),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<InkWell>.generate(
                5,
                    (index) =>
                    InkWell(
                      onTap: () {
                        setState(() {
                          if(_stars[index]) {
                            _stars[index] = false;

                            _numberOfStars--;
                          } else {
                            _stars[index] = true;

                            _numberOfStars++;
                          }
                        });
                      },
                      child: Icon(
                        Icons.star,
                        size: 25.0.sp,
                        color: _stars[index] ? Colors.amber : Colors.amber.withOpacity(0.4),
                      ),
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                errorText: _commentError,
                hintText: 'لطفاً نظر خود را بنویسید.',
                border: _outlineInputBorder,
                focusedBorder: _outlineInputBorder,
                disabledBorder: _outlineInputBorder,
                enabledBorder: _outlineInputBorder,
                errorBorder: _outlineInputBorder,
                focusedErrorBorder: _outlineInputBorder,
              ),
              maxLines: 8,
              cursorColor: Theme.of(context).dividerColor.withOpacity(0.6),
              cursorWidth: 1.0,
              onChanged: (String text) {
                setState(() {
                  if(_commentController.text.length < 3) {
                    _commentError = 'نظر شما باید بیش از حرف داشته باشد.';
                  } else {
                    _commentError = null;
                  }
                });
              },
            ),
          ),
          Center(
            child: Center(
              child: SizedBox(
                width: 100.0.w - (2 * 18.0) - (2 * 5.0.w),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      if(_commentController.text.isEmpty) {
                        _commentError = 'لطفاً نظر خود را بنویسید.';
                      } else if(_commentController.text.length < 3) {
                        _commentError = 'نظر شما باید بیش از حرف داشته باشد.';
                      } else {
                        _commentRegistration();
                      }
                    });
                  },
                  label: const Text('ثبت نظر',),
                  icon: const Icon(Ionicons.checkmark_outline),
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

  void _commentRegistration() async {
    _customDio = await CustomDio.dio.post(
      'dashboard/books/${widget.book.slug}/review',
      data: {
        'comment': _commentController.text,
        'rate': _numberOfStars,
      },
    );

    setState(() {
      if (_customDio.statusCode == 200) {
        _commentController = TextEditingController();
        _numberOfStars = 0;
        _stars = List<bool>.generate(5, (index) => false);

        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            context,
            Ionicons.checkmark_done_outline,
            'نظر شما با موفقیت ثبت شد.',
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            context,
            Ionicons.refresh_outline,
            'لطفاً دوباره امتحان کنید.',
          ),
        );
      }
    });
  }

  Visibility _otherPublisherBooks() {
    return Visibility(
      visible: (widget.book.otherBooksByThePublisher.isNotEmpty) && (_tabIndex != 2),
      child: _otherBooks(
        'کتاب های دیگر ناشر',
        widget.book.otherBooksByThePublisher,
      ),
    );
  }

  Visibility _relatedBooks() {
    return Visibility(
      visible: (widget.book.relatedBooks.isNotEmpty) && (_tabIndex != 2),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryColor,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        print(widget.book.slug);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return BooksPage(
                                title:
                                '$title با کتاب ${widget.book.name}',
                                books: books,
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        'نمایش همه',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              18.0,
                            ),
                            side: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        side: MaterialStateProperty.all(
                          BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ],
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

  Visibility _userComments() {
    return Visibility(
      visible: (widget.book.reviews.isNotEmpty) && (_tabIndex == 2),
      child: Padding(
        padding: EdgeInsets.only(left: 5.0.w, top: 0.0, right: 5.0.w, bottom: 16.0,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'نظرات کاربران',
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
            Column(
              children: List.generate(
                widget.book.reviews.length,
                    (index) => Padding(
                  padding: EdgeInsets.only(
                    top: 0.0,
                    bottom: index == widget.book.reviews.length - 1 ? 0.0 : 8.0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 18.0,
                      top: 18.0,
                      right: 18.0,
                      bottom: 8.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.book.reviews[index].userName.toString()),
                            ShowStars(numberOfStars: widget.book.reviews[index].numberOfStars,),
                          ],
                        ),
                        Visibility(
                          visible: _displayOfDetails[index],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(
                                height: 24.0,
                                thickness: 1.0,
                              ),
                              Text(
                                '- ${widget.book.reviews[index].review}',
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 24.0,
                          thickness: 1.0,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (index == _previousIndex &&
                                  _displayOfDetails[index]) {
                                _displayOfDetails[index] = false;
                              } else if (index == _previousIndex &&
                                  !_displayOfDetails[index]) {
                                _displayOfDetails[index] = true;
                              } else if (index != _previousIndex) {
                                if (_previousIndex != -1) {
                                  _displayOfDetails[_previousIndex] = false;
                                }
                                _displayOfDetails[index] = true;
                              }

                              _previousIndex = index;
                            });
                          },
                          child: Icon(
                            _displayOfDetails[index]
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
