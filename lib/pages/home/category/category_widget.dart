//------/dart and flutter packages
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kaz_reader/pages/home/home_config.dart';
import 'package:kaz_reader/pages/home/home_controller.dart';

//------/packages
export 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

//------/controller
import '../../../widgets/book_introduction/book_introduction_model.dart';
import '../../../widgets/books_list_view.dart';
import '../../../widgets/books_page.dart';
import '../../../widgets/fade_in_image_widget.dart';
import '/controller/custom_dio.dart';
import '/controller/custom_response.dart';
import '/controller/internet_connection.dart';
import '/controller/load_data_from_api.dart';

//------/model

//------/main
import '/main.dart';
import 'category_controller.dart';
import 'category_model.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryController controller;

  const CategoryWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        banner(context),
        latestBooks(context),
        bestSellingBooks(context),
        SizedBox(
          height: 15.0.r,
        ),
      ],
    );
  }

  FadeInImageWidget banner(BuildContext context) {
    return FadeInImageWidget(
      image: controller.state!.banner,
      height: 160.0.r,
      width: 1.0.sw,
    );
  }

  Column latestBooks(BuildContext context) {
    return part(
      context,
      HomeConfig.config.texts.latestBooks,
      controller.state!.latestBooks,
    );
  }

  Column bestSellingBooks(BuildContext context) {
    return part(
      context,
      HomeConfig.config.texts.bestSellingBooks,
      controller.state!.bestSellingBooks,
    );
  }

  Column part(
    BuildContext context,
    String title,
    List<BookIntroductionModel> books,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
          shape: const Border(),
          child: ListTile(
            title: Text(
              '$title ${controller.state!.title}',
              style: TextStyle(color: Theme.of(context).primaryColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            trailing: OutlinedButton(
              onPressed: () => controller.push(
                context,
                '$title ${controller.state!.title}',
                books,
              ),
              child: Text(HomeConfig.config.texts.showAll),
            ),
          ),
        ),
        BooksListView(books: books),
      ],
    );
  }
}
