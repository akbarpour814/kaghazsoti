//------/dart and flutter packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaz_reader/pages/about_us/about_us_controller.dart';
import 'dart:io';

//------/packages
export 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

//------/controller
import '/controller/custom_dio.dart';
import '/controller/custom_response.dart';
import '/controller/internet_connection.dart';
import '/controller/load_data_from_api.dart';

//------/model
import '/model/text_format.dart';

//------/view/view_models
import '../../widgets/custom_circular_progress_indicator.dart';
import '/widgets/no_internet_connection.dart';

//------/main
import '/main.dart';

class AboutUsPage extends GetView<AboutUsController> {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context),
      bottomNavigationBar: playerBottomNavigationBar,
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text('درباره ما'),
      automaticallyImplyLeading: false,
      leading: const Icon(
        Ionicons.information_outline,
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

  Widget _body(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.fetch(),
      child: controller.obx(
            (state) => _innerBody(context),
        onError: (e) => const Text('onError'),
        onLoading: const Center(
          child: CustomCircularProgressIndicator(),
        ),
        onEmpty: const Text('onEmpty'),
      ),
    );

  }

  SingleChildScrollView _innerBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 5.0.w,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _appLogo(context),
                Expanded(
                  child: SizedBox(
                    width: 50.0.w,
                    height: 20.0.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'راه های ارتباط با ما:',
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  _launcherToWhatsapp(context),
                                  _launcherToEmail(context),
                                  _launcherToWebsite(context),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _share(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _introductionTextWidget(),
          ],
        ),
      ),
    );
  }

  Image _appLogo(BuildContext context) {
    return Image.asset(
      appLogo,
      width: 40.0.w,
    );
  }

  Flexible _launcherToWhatsapp(BuildContext context) {
    return Flexible(
      child: InkWell(
        onTap: () {
          if (Platform.isAndroid || Platform.isIOS) {
            launch('https://wa.me/${controller.state!.whatsapp}/');
          } else {
            launch('https://api.whatsapp.com/send?phone=${controller.state!.whatsapp}');
          }
        },
        child: Icon(
          Ionicons.logo_whatsapp,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Flexible _launcherToEmail(BuildContext context) {
    return Flexible(
      child: InkWell(
        onTap: () {
          launch('mailto:${controller.state!.email}?');
        },
        child: Icon(
          Ionicons.logo_yahoo,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Flexible _launcherToWebsite(BuildContext context) {
    return Flexible(
      child: InkWell(
        onTap: () {
          launch(controller.state!.website);
        },
        child: Icon(
          Ionicons.earth_outline,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Flexible _share(BuildContext context) {
    return Flexible(
      child: ElevatedButton(
        onPressed: () {
          Share.share(
            controller.state!.share,
            subject: 'کاغذ صوتی',
          );
        },
        child: const Text(
          'ما را به اشتراک بگذارید.',
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Padding _introductionTextWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        controller.state!.aboutUs,
        style: const TextStyle(height: 1.7),
        textAlign: TextAlign.justify,
      ),
    );
  }
}

