import '../../core/config/config.dart';
import '../../core/config/routes.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/texts.dart';
import '../../services/apis.dart';
import 'book_page.dart';

class BookConfig extends Config {
  static final BookConfig _bookConfig = BookConfig();
  late BookAPIs apis;
  late BookIcons icons;
  late BookTexts texts;

  BookConfig() {
    // title = BookTexts.category;
    // icon = BookIcons.category;
    // route = Routes.category;
    // page = const BookPage();
    apis = BookAPIs();
    icons = BookIcons();
    texts = BookTexts();
  }

  static BookConfig get config => _bookConfig;
}