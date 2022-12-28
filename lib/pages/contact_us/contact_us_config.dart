
import '../../core/config/config.dart';
import '../../core/config/routes.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/texts.dart';
import 'contact_us_page.dart';

class ContactUsConfig extends Config {
  static final ContactUsConfig _contactUsConfig = ContactUsConfig();
  late ContactUsIcons icons;
  late ContactUsTexts texts;

  ContactUsConfig() {
    title = ContactUsTexts.contactUs;
    icon = ContactUsIcons.contactUs;
    route = Routes.contactUs;
    page = const ContactUsPage();
    icons = ContactUsIcons();
    texts = ContactUsTexts();
  }

  static ContactUsConfig get config => _contactUsConfig;
}