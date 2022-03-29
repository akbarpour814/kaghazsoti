import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:takfood_seller/model/book_introduction.dart';
import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../view_models/custom_circular_progress_indicator.dart';
import '/main.dart';
import '../../view_models/books_page.dart';

import 'package:sizer/sizer.dart';

import '/model/home_page_category_data.dart';
import '/view/view_models/books_list_view.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late  bool _internetConnectionChecker;
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  late List<HomePageCategoryData> _homePageCategoriesData;

  @override
  void initState() {
    _homePageCategoriesData = [];

    super.initState();
  }

  Future _initHomePageCategoriesData() async {
    _customDio = await CustomDio.dio.post('home');

    if (_customDio.statusCode == 200) {
      _homePageCategoriesData.clear();

      _customResponse = CustomResponse.fromJson(_customDio.data);

      _homePageCategoriesData.add(HomePageCategoryData.fromJson('کتاب های صوتی', (_customResponse.data['books'])['کتاب-صوتی']));

      _homePageCategoriesData.add(HomePageCategoryData.fromJson('نامه های صوتی', (_customResponse.data['books'])['نامه-صوتی']));

      _homePageCategoriesData.add(HomePageCategoryData.fromJson('کتاب های الکترونیکی', (_customResponse.data['books'])['کتاب-الکترونیکی']));

      _homePageCategoriesData.add(HomePageCategoryData.fromJson('پادکست ها', (_customResponse.data['books'])['پادکست']));

      _homePageCategoriesData.add(HomePageCategoryData.fromJson('کتاب های کودک و نوجوان', (_customResponse.data['books'])['کتاب-کودک-و-نوجوان']));
    }

    return _customDio;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _body(),
        bottomNavigationBar: playerBottomNavigationBar,
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF00444D), // navigation bar color
      ),
      child: SafeArea(
        child: Scaffold(
          body: _innerBody(),
          bottomNavigationBar: playerBottomNavigationBar,
        ),
      ),
    );
  }

  FutureBuilder _body() {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? _innerBody()
            : const Center(child: CustomCircularProgressIndicator());
      },
      future: _initHomePageCategoriesData(),
    );
  }

  SingleChildScrollView _innerBody() {
    return SingleChildScrollView(
      child: Column(
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
        'تازه ترین', widget.homePageCategoryData.latestBooks);
  }

  Column _bestSellingBooksPart() {
    return _latestAndBestSellingBooks(
      'پر فروش ترین',
      widget.homePageCategoryData.bestSellingBooks,
    );
  }

  Column _latestAndBestSellingBooks(
      String title, List<BookIntroduction> books) {
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
          ),
        ),
        BooksListView(
          books: books,
        ),
      ],
    );
  }
}
