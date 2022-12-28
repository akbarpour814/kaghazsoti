
import 'package:kaz_reader/core/config/config.dart';
import 'package:kaz_reader/core/config/routes.dart';
import 'package:kaz_reader/core/constants/icons.dart';
import 'package:kaz_reader/core/constants/texts.dart';
import 'package:kaz_reader/pages/home/home_page.dart';
import 'package:kaz_reader/services/apis.dart';

class HomeConfig extends Config {
  static final HomeConfig _homeConfig = HomeConfig();
  late HomeAPIs apis;
  late HomeIcons icons;
  late HomeTexts texts;

  HomeConfig() {
    title = HomeTexts.home;
    icon = HomeIcons.home;
    route = Routes.home;
    page = const HomePage();
    apis = HomeAPIs();
    icons = HomeIcons();
    texts = HomeTexts();
  }

  static HomeConfig get config => _homeConfig;
}
