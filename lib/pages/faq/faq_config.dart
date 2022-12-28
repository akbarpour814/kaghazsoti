
import '../../core/config/config.dart';
import '../../core/config/routes.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/texts.dart';
import '../../services/apis.dart';
import 'faq_page.dart';

class FAQConfig extends Config {
  static final FAQConfig _faqConfig = FAQConfig();
  late FAQAPIs apis;
  late FAQIcons icons;
  late FAQTexts texts;

  FAQConfig() {
    title = FAQTexts.faq;
    icon = FAQIcons.faq;
    route = Routes.faq;
    page = const FAQPage();
    apis = FAQAPIs();
    icons = FAQIcons();
    texts = FAQTexts();
  }

  static FAQConfig get config => _faqConfig;
}
