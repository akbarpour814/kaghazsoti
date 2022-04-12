import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import '/view/pages/profile_page/marked_page.dart';
import '/view/view_models/show_stars.dart';
import 'package:zarinpal/zarinpal.dart';
import '../../controller/custom_response.dart';
import '../../model/book_introduction.dart';
import 'books_page.dart';
import '/main.dart';
import '/model/book.dart';
import '/view/pages/profile_page/cart_page.dart';
import '/view/view_models/audiobook_player_page.dart';
import '/view/view_models/books_list_view.dart';
import '/view/view_models/property.dart';
import 'package:sizer/sizer.dart';

import '/controller/custom_dio.dart';
import 'custom_circular_progress_indicator.dart';
import 'custom_snack_bar.dart';
import 'no_internet_connection.dart';
import 'player_bottom_navigation_bar.dart';
import 'progress_bar/playOrPauseController.dart';

class BookIntroductionPage extends StatefulWidget {
  late BookIntroduction bookIntroduction;

  BookIntroductionPage({
    Key? key,
    required this.bookIntroduction,
  }) : super(key: key);

  @override
  _BookIntroductionPageState createState() => _BookIntroductionPageState();
}

class _BookIntroductionPageState extends State<BookIntroductionPage> with TickerProviderStateMixin {
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  late bool _dataIsLoading;
  late Book _book;
  TextEditingController _commentController = TextEditingController();
  String? _commentError;
  late TabController _tabController;
  late int _tabIndex;
  late List<bool> _displayOfDetails;
  late int _previousIndex;
  late int _numberOfStars;
  late List<bool> _stars;
  late bool _availableInCart;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    _dataIsLoading = true;

    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _tabIndex = 0;

    _previousIndex = -1;
    _numberOfStars = 0;
    _stars = List<bool>.generate(5, (index) => false);

    super.initState();

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }


  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future _initBook() async {
    _customDio =
        await CustomDio.dio.post('books/${widget.bookIntroduction.slug}');

    if (_customDio.statusCode == 200) {
      _customResponse = CustomResponse.fromJson(_customDio.data);

      _book = Book.fromJson(_customResponse.data);

      _displayOfDetails = List<bool>.generate(_book.reviews.length, (index) => false);
      print(_displayOfDetails);

      _availableInCart = cartSlug.contains(_book.slug);

      _dataIsLoading = false;

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
      title: Text(widget.bookIntroduction.name),
      leading: InkWell(
        child: Icon(
          Ionicons.bookmark_outline,
          color: markedBooksId.contains(widget.bookIntroduction.id)
              ? Colors.pinkAccent
              : Colors.white,
        ),
        onTap: () {
          if((!_dataIsLoading) && (_connectionStatus != ConnectivityResult.none)) {
            setState(() {
              _setMarkedBooks();

              if (markedBooksId.contains(widget.bookIntroduction.id)) {
                markedBooksId.remove(widget.bookIntroduction.id);
              } else {
                markedBooksId.add(widget.bookIntroduction.id);
              }
            });
          }
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
    await CustomDio.dio
        .post('dashboard/users/wish', data: {'book_id': _book.id});
  }

  Widget _body() {
    return _dataIsLoading
        ? FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.hasData
                  ? _innerBody()
                  : Center(child: CustomCircularProgressIndicator(message: 'لطفاً شکیبا باشید.'));
            },
            future: _initBook(),
          )
        : _innerBody();
  }

  Widget _innerBody() {
    if(_connectionStatus == ConnectivityResult.none) {
      setState(() {
        _dataIsLoading = true;
      });

      return const Center(child: NoInternetConnection(),);
    } else {
      return RefreshIndicator(
        onRefresh: () {
          setState(() {
            _dataIsLoading = true;
          });

          return _initBook(); },
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 5.0.w,
              ),
              child: Column(
                children: [
                  _bookCover(),
                  _bookPricesAndVotes(),
                  _cartButton(),
                  _addToLibraryButton(),
                  _tabsTopic(),
                  _tab(_tabIndex),
                ],
              ),
            ),
            _relatedBooks(),
            _otherPublisherBooks(),
            _userComments(),
          ],
        ),
      );
    }
  }

  bool playDemo = false;

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
              image: _book.bookCoverPath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          left: 2.5.w,
          bottom: 2.5.w,
            child: !demoIsPlaying.of(context) || (demoInPlayId != _book.id) ?
            FloatingActionButton(
              child: const Icon(Ionicons.play_outline),
              onPressed: () {
                setState(() {
                  demoIsPlaying.$ = true;
                  demoInPlayId = _book.id;
                  demoPlayer.setUrl(_book.demo);


                  audioPlayerHandler.stop();

                });
              },
            ) :
            StreamBuilder<PlayerState>(
            stream: demoPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;


              if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                return FloatingActionButton(
                  onPressed: null,
                  child: const CircularProgressIndicator(color: Colors.white,),
                );

              } else if (playing != true) {
                return FloatingActionButton(
                  child: const Icon(Ionicons.play_outline),
                  onPressed: demoPlayer.play,
                );

              } else {

                return FloatingActionButton(
                  child: const Icon(Ionicons.pause_outline),
                  onPressed: demoPlayer.pause,
                );
              }

            },
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
                ShowStars(
                  numberOfStars: _book.numberOfStars,
                ),
                Text(
                  '${_book.numberOfVotes.toString()} رای',
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
            Text(
              libraryId.contains(_book.id) ? 'موجود در کتابخانه' : _book.price,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Visibility _cartButton() {
    return Visibility(
      visible:
          (!libraryId.contains(_book.id)) && (!_book.price.contains('رایگان')),
      child: SizedBox(
        width: 100.0.w - (2 * 5.0.w),
        height: 5.5.h,
        child: ElevatedButton.icon(
          onPressed: () {
            _setCart();
          },
          label:
              Text(_availableInCart ? 'حذف از سبد خرید' : 'افزودن به سبد خرید'),
          icon: Icon(
            _availableInCart
                ? Ionicons.bag_remove_outline
                : Ionicons.bag_add_outline,
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Visibility _addToLibraryButton() {
    return Visibility(
      visible:
          (!libraryId.contains(_book.id)) && (_book.price.contains('رایگان')),
      child: SizedBox(
        width: 100.0.w - (2 * 5.0.w),
        height: 5.5.h,
        child: ElevatedButton.icon(
          onPressed: () {},
          label: const Text('افزودن به کتابخانه'),
          icon: const Icon(Ionicons.library_outline),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setCart() async {
    setState(() {
      if (_availableInCart) {
        cartSlug.remove(_book.slug);

        _availableInCart = false;
      } else {
        cartSlug.add(_book.slug);

        _availableInCart = true;
      }
    });

    await sharedPreferences.setStringList('cartSlug', cartSlug);
  }

  Padding _tabsTopic() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        borderRadius:
            libraryId.contains(_book.id)
                ? const BorderRadius.vertical(top: Radius.circular(5.0))
                : null,
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
        color: Theme.of(context).primaryColor,
      ),
      borderRadius: BorderRadius.circular(5.0),
    );

    Container _bookSpecifications = Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5.0)),
      ),
      child: Column(
        children: [
          Visibility(
            visible: _book.name.isNotEmpty,
            child: Property(
              property: 'نام',
              value: _book.name,
              valueInTheEnd: false,
              lastProperty: false,
            ),
          ),
          Visibility(
            visible:
                (_book.category.isNotEmpty) && (_book.subcategory.isNotEmpty),
            child: Property(
              property: 'دسته',
              value: '${_book.category} - ${_book.subcategory}',
              valueInTheEnd: false,
              lastProperty: false,
            ),
          ),
          Visibility(
            visible: _book.author.isNotEmpty,
            child: Property(
              property: 'نویسنده',
              value: _book.author,
              valueInTheEnd: false,
              lastProperty: false,
            ),
          ),
          Visibility(
            visible: _book.announcer.isNotEmpty,
            child: Property(
              property: 'گوینده',
              value: _book.announcer,
              valueInTheEnd: false,
              lastProperty: false,
            ),
          ),
          Visibility(
            visible: _book.fileSize != '0.0',
            child: Property(
              property: 'حجم دانلود',
              value: _book.fileSize.toString(),
              valueInTheEnd: false,
              lastProperty: false,
            ),
          ),
          Visibility(
            visible: _book.publisherOfPrintedVersion.isNotEmpty,
            child: Property(
              property: 'ناشر چاپی',
              value: _book.publisherOfPrintedVersion,
              valueInTheEnd: false,
              lastProperty: false,
            ),
          ),
          Visibility(
            visible: _book.printedVersionYear != 0,
            child: Property(
              property: 'سال انتشار چاچی',
              value: _book.printedVersionYear.toString(),
              valueInTheEnd: false,
              lastProperty: false,
            ),
          ),
          Visibility(
            visible: _book.publisherOfAudioVersion.isNotEmpty,
            child: Property(
              property: 'ناشر صوتی',
              value: _book.publisherOfAudioVersion,
              valueInTheEnd: false,
              lastProperty: false,
            ),
          ),
          Visibility(
            visible: _book.audioVersionYear != 0,
            child: Property(
              property: 'سال انتشار صوت',
              value: _book.audioVersionYear.toString(),
              valueInTheEnd: false,
              lastProperty: false,
            ),
          ),
          Visibility(
            visible: _book.numberOfChapters != 0,
            child: Property(
              property: 'تعداد فصل',
              value: _book.numberOfChapters.toString(),
              valueInTheEnd: false,
              lastProperty: false,
            ),
          ),
          Visibility(
            visible: _book.numberOfPages != '0',
            child: Property(
              property: 'تعداد صفحات',
              value: _book.numberOfPages.toString(),
              valueInTheEnd: false,
              lastProperty: false,
            ),
          ),
          Visibility(
            visible: _book.duration.isNotEmpty,
            child: Property(
              property: 'زمان پخش یا مطالعه',
              value: _book.duration,
              valueInTheEnd: false,
              lastProperty: false,
            ),
          ),
          Visibility(
            visible: _book.price.isNotEmpty,
            child: Property(
              property: 'مبلغ',
              value: _book.price,
              valueInTheEnd: false,
              lastProperty: true,
            ),
          ),
        ],
      ),
    );
    Container _aboutBook = Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _book.aboutBook,
            textAlign: TextAlign.justify,
          ),
          Center(
            child: Divider(
              height: 10.0.h,
            ),
          ),
          Center(
            child: Text(
              'قسمتی از کتاب ${_book.name}',
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 2.5.h,
          ),
          Text(
            _book.partOfTheBook,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
    Visibility _comments = Visibility(
      visible: !_book.reviewed,
      child: Container(
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(5.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'نظر شما:',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<InkWell>.generate(
                  5,
                  (index) => InkWell(
                    onTap: () {
                      setState(() {
                        if (_stars[index]) {
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
                      color: _stars[index]
                          ? Colors.amber
                          : Colors.amber.withOpacity(0.4),
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
                    if(_commentController.text.isEmpty) {
                      _commentError = null;
                    } else if (_commentController.text.length < 3) {
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
                        if ((_commentController.text.isEmpty) && (_numberOfStars == 0)) {
                          _commentError = 'لطفاً نظر خود را به همراه رأی بنویسید.';
                        } else if (_commentController.text.isEmpty) {
                          _commentError = 'لطفاً نظر خود را بنویسید.';
                        } else if (_commentController.text.length < 3) {
                          _commentError = 'نظر شما باید بیش از حرف داشته باشد.';
                        } else if(_numberOfStars == 0) {
                          _commentError = 'لطفاً رأی هم بدهید.';
                        } else {
                          _commentError = null;

                          _commentRegistration();
                        }
                      });
                    },
                    label: const Text(
                      'ثبت نظر',
                    ),
                    icon: const Icon(Ionicons.checkmark_outline),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    late final List<Widget> _tabs = [
      _bookSpecifications,
      _aboutBook,
      _comments,
    ];

    return _tabs[index];
  }

  void _commentRegistration() async {
    _customDio = await CustomDio.dio.post(
      'dashboard/books/${_book.slug}/review',
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
        _dataIsLoading = true;
        _tabIndex = 2;

        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            context,
            Ionicons.checkmark_done_outline,
            'نظر شما با موفقیت ثبت شد.',
            4,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            context,
            Ionicons.refresh_outline,
            'لطفاً دوباره امتحان کنید.',
            4,
          ),
        );
      }
    });
  }

  Visibility _otherPublisherBooks() {
    return Visibility(
      visible: (_book.otherBooksByThePublisher.isNotEmpty) && (_tabIndex != 2),
      child: _otherBooks(
        'کتاب های دیگر ناشر',
        _book.otherBooksByThePublisher,
      ),
    );
  }

  Visibility _relatedBooks() {
    return Visibility(
      visible: (_book.relatedBooks.isNotEmpty) && (_tabIndex != 2),
      child: _otherBooks(
        'کتاب های مرتبط',
        _book.relatedBooks,
      ),
    );
  }

  Padding _otherBooks(String title, List<BookIntroduction> books) {
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
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        print(_book.slug);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return BooksPage(
                                title: '$title با کتاب ${_book.name}',
                                books: books,
                              );
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'نمایش همه',
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 4.0.h,
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
      visible: (_book.reviews.isNotEmpty) && (_tabIndex == 2),
      child: Padding(
        padding: EdgeInsets.only(
          left: 5.0.w,
          top: 0.0,
          right: 5.0.w,
          bottom: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'نظرات کاربران',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            Divider(
              height: 4.0.h,
            ),
            Column(
              children: List.generate(
                _book.reviews.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    top: 0.0,
                    bottom: index == _book.reviews.length - 1 ? 0.0 : 8.0,
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
                            Text(
                                '${_book.reviews[index].id == userId ? 'نظر شما' : _book.reviews[index].name}'),
                            ShowStars(
                              numberOfStars: _book.reviews[index].numberOfStars,
                            ),
                          ],
                        ),
                        Visibility(
                          visible: _displayOfDetails[index],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(
                                height: 24.0,
                              ),
                              Text(
                                '- ${_book.reviews[index].review}',
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 24.0,
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
