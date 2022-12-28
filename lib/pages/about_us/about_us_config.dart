import '../../core/config/config.dart';
import '../../core/config/routes.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/texts.dart';
import '../../services/apis.dart';
import 'about_us_page.dart';

class AboutUsConfig extends Config {
  static final AboutUsConfig _aboutUsConfig = AboutUsConfig();
  late AboutUsAPIs apis;
  late AboutUsIcons icons;
  late AboutUsTexts texts;

  AboutUsConfig() {
    title = AboutUsTexts.aboutUs;
    icon = AboutUsIcons.aboutUs;
    route = Routes.aboutUs;
    page = const AboutUsPage();
    apis = AboutUsAPIs();
    icons = AboutUsIcons();
    texts = AboutUsTexts();
  }

  static AboutUsConfig get config => _aboutUsConfig;
}