//------/dart and flutter packages
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kaz_reader/core/constants/colors.dart';
import 'package:kaz_reader/int_extension.dart';
import 'package:kaz_reader/widgets/book_introduction/book_introduction_config.dart';

//------/packages
export 'package:flutter_screenutil/flutter_screenutil.dart';

//------/model
import '../fade_in_image_widget.dart';
import 'book_introduction_controller.dart';
import 'book_introduction_model.dart';

//------/view/pages/search_page
import '../../pages/search/search_page.dart';

//------/view/view_models
import '../../pages/book/book_page.dart';
import '/widgets/stars_widget.dart';

//------/main
import '/main.dart';

class BookIntroductionWidget extends StatelessWidget {
  final BookIntroductionController controller;

  const BookIntroductionWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.push(context),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            image(),
            info(context),
          ],
        ),
      ),
    );
  }

  Container image() {
    return Container(
      margin: EdgeInsets.all(8.0.r),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? BookIntroductionConfig.config.colors.darkBackground
            : BookIntroductionConfig.config.colors.lightBackground,
        border: Border.all(color: BookIntroductionConfig.config.colors.border),
        borderRadius: BorderRadius.all(
          Radius.circular(6.0.r),
        ),
      ),
      width: 100.0.r,
      height: 120.0.r,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(6.0.r),
        ),
        child: FadeInImageWidget(
          image: controller.state!.bookCoverPath,
          width: 100.0.r,
          height: 120.0.r,
        ),
      ),
    );
  }

  Flexible info(BuildContext context) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.only(left: 8.0.r),
        height: 110.0.r,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 60.0.r,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      title(),
                      votes(context),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      author(context),
                      stars(context),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                publisherOfPrintedVersion(context),
                price(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Flexible title() {
    return Flexible(
      child: Text(
        controller.state!.name,
        style: const TextStyle(overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Flexible votes(BuildContext context) {
    return Flexible(
      child: Text(
        controller.state!.votes.vote,
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  Flexible author(BuildContext context) {
    return Flexible(
      child: Text(
        controller.state!.author,
        style: Theme.of(context)
            .textTheme
            .caption!
            .copyWith(overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Flexible stars(BuildContext context) {
    return Flexible(
      child: StarsWidget(
        stars: controller.state!.stars,
      ),
    );
  }

  Flexible publisherOfPrintedVersion(BuildContext context) {
    return Flexible(
      child: Text(
        controller.state!.publisherOfPrintedVersion,
        style: Theme.of(context)
            .textTheme
            .caption!
            .copyWith(overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Flexible price(BuildContext context) {
    return Flexible(
      child: Text(
        controller.state!.price,
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }
}
