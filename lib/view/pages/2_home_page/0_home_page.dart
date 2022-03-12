import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:takfood_seller/controller/database.dart';
import 'package:takfood_seller/model/comment.dart';
import 'package:takfood_seller/model/purchase.dart';
import 'package:takfood_seller/test.dart';
import 'package:takfood_seller/view/pages/login_pages/splash_page.dart';
import 'package:takfood_seller/view/pages/login_pages/login_page.dart';
import 'package:takfood_seller/view/view_models/audiobook_player_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_value/shared_value.dart';

import 'package:sizer/sizer.dart';


import '../../../model/HomePageCategoryData.dart';
import '../../../model/book.dart';
import '../../view_models/books_list_view.dart';
import '../../view_models/player_bottom_navigation_bar.dart';
import '../1_category_page/2_books_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<HomePageCategoryView> category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: _body(),
      bottomNavigationBar: const PlayerBottomNavigationBar(),
    );
  }

  SingleChildScrollView _body() {
    return SingleChildScrollView(
      child: Column(
        children: List<HomePageCategoryView>.generate(database.homePageCategories.length, (index) => HomePageCategoryView(homePageCategoryData: database.homePageCategories[index],),),
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
            itemCount: widget.homePageCategoryData.pathOfSmoothPages.length,
            itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    widget.homePageCategoryData.pathOfSmoothPages[index],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              width: 100.0.w,
              height: 18.0.h,
            ),
          ),
        ),
        Center(
          child: Visibility(
            visible: widget.homePageCategoryData.pathOfSmoothPages.length > 1,
            child: SizedBox(
              width: 100.0.w,
              height: 18.0.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SmoothPageIndicator(
                    controller: _smoothPageController,
                    count: widget.homePageCategoryData.pathOfSmoothPages.length,
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
    return _latestAndBestSellingBooks('تازه ترین', widget.homePageCategoryData.latestBooks);
  }

  Column _bestSellingBooksPart() {
    return _latestAndBestSellingBooks(
      'پر فروش ترین',
      widget.homePageCategoryData.bestSellingBooks,
    );
  }

  Column _latestAndBestSellingBooks(String title, List<Book> books) {
    return Column(
      children: [
        Card(
          color: Colors.transparent,
          elevation: 0.0,
          shape: const Border(),
          child: ListTile(
            title: Text(
              '$title ${widget.homePageCategoryData.bookCategoryName}',
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
                          books: books,);
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
