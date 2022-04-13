import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../view_models/no_internet_connection.dart';
import '/model/book_introduction.dart';
import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../view_models/custom_circular_progress_indicator.dart';
import '/main.dart';
import '../../view_models/books_page.dart';

import 'package:sizer/sizer.dart';

import '/model/home_page_category_data.dart';
import '/view/view_models/books_list_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ConnectivityResult _connectionStatus;
  late Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;

  late List<HomePageCategoryData> _homePageCategoriesData;

  @override
  void initState() {
    super.initState();

    _connectionStatus = ConnectivityResult.none;
    _connectivity = Connectivity();
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _homePageCategoriesData = [];
  }

  Future<void> _initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
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

  Future _initHomePageCategoriesData() async {
    _customDio = await CustomDio.dio.post('home');

    if (_customDio.statusCode == 200) {
      _homePageCategoriesData.clear();

      _customResponse = CustomResponse.fromJson(_customDio.data);

      _homePageCategoriesData.add(
        HomePageCategoryData.fromJson(
          'کتاب های صوتی',
          (_customResponse.data['books'])['کتاب-صوتی'],
        ),
      );

      _homePageCategoriesData.add(
        HomePageCategoryData.fromJson(
          'نامه های صوتی',
          (_customResponse.data['books'])['نامه-صوتی'],
        ),
      );

      _homePageCategoriesData.add(
        HomePageCategoryData.fromJson(
          'کتاب های الکترونیکی',
          (_customResponse.data['books'])['کتاب-الکترونیکی'],
        ),
      );

      _homePageCategoriesData.add(
        HomePageCategoryData.fromJson(
          'پادکست ها',
          (_customResponse.data['books'])['پادکست'],
        ),
      );

      _homePageCategoriesData.add(
        HomePageCategoryData.fromJson(
          'کتاب های کودک و نوجوان',
          (_customResponse.data['books'])['کتاب-کودک-و-نوجوان'],
        ),
      );
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
      title: const Text('خانه'),
      leading: const Icon(
        Ionicons.home_outline,
      ),
    );
  }

  FutureBuilder _body() {
    return FutureBuilder(
      future: _initHomePageCategoriesData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CustomCircularProgressIndicator(
              message: 'لطفاً شکیبا باشید.',
            ),
          );
        } else {
          if (_connectionStatus == ConnectivityResult.none) {
            return const Center(
              child: NoInternetConnection(),
            );
          } else {
            return _innerBody();
          }
        }
      },
    );
  }

  RefreshIndicator _innerBody() {
    return RefreshIndicator(
      onRefresh: _initHomePageCategoriesData,
      child: ListView(
        children: List<HomePageCategoryView>.generate(
          _homePageCategoriesData.length,
          (index) => HomePageCategoryView(
            homePageCategoryData: _homePageCategoriesData[index],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class HomePageCategoryView extends StatefulWidget {
  late HomePageCategoryData homePageCategoryData;

  HomePageCategoryView({
    Key? key,
    required this.homePageCategoryData,
  }) : super(key: key);

  @override
  _HomePageCategoryViewState createState() => _HomePageCategoryViewState();
}

class _HomePageCategoryViewState extends State<HomePageCategoryView> {
  final PageController _smoothPageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _upperPart(),
        _latestBooksPart(),
        _bestSellingBooksPart(),
        SizedBox(
          height: 2.0.h,
        ),
      ],
    );
  }

  Stack _upperPart() {
    return Stack(
      children: [
        SizedBox(
          height: 18.0.h,
          child: PageView.builder(
            controller: _smoothPageController,
            itemCount: widget.homePageCategoryData.banners.length,
            itemBuilder: (context, index) => Container(
              color: Theme.of(context).primaryColor,
              width: 100.0.w,
              height: 18.0.h,
              child: FadeInImage.assetNetwork(
                placeholder: defaultBanner,
                image: widget.homePageCategoryData.banners[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Center(
          child: Visibility(
            visible: widget.homePageCategoryData.banners.length > 1,
            child: SizedBox(
              width: 100.0.w,
              height: 18.0.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SmoothPageIndicator(
                    controller: _smoothPageController,
                    count: widget.homePageCategoryData.banners.length,
                    effect: JumpingDotEffect(
                      activeDotColor: Theme.of(context).primaryColor,
                      dotColor: Colors.white54,
                    ),
                  ),
                  SizedBox(
                    height: 2.5.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column _latestBooksPart() {
    return _latestAndBestSellingBooks(
      'تازه ترین',
      widget.homePageCategoryData.latestBooks,
    );
  }

  Column _bestSellingBooksPart() {
    return _latestAndBestSellingBooks(
      'پر فروش ترین',
      widget.homePageCategoryData.bestSellingBooks,
    );
  }

  Column _latestAndBestSellingBooks(String title, List<BookIntroduction> books) {
    return Column(
      children: [
        Card(
          color: Colors.transparent,
          elevation: 0.0,
          shape: const Border(),
          child: ListTile(
            title: Text(
              '$title ${widget.homePageCategoryData.bookCategoryName}',
              style: TextStyle(color: Theme.of(context).primaryColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            trailing: OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return BooksPage(
                        title:
                            '$title ${widget.homePageCategoryData.bookCategoryName}',
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
          ),
        ),
        BooksListView(
          books: books,
        ),
      ],
    );
  }
}
