import '../../core/config/config.dart';
import '../../core/config/routes.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/texts.dart';
import '../../services/apis.dart';
import 'category_page.dart';

class CategoryConfig extends Config {
  static final CategoryConfig _categoryConfig = CategoryConfig();
  late CategoryAPIs apis;
  late CategoryIcons icons;
  late CategoryTexts texts;

  CategoryConfig() {
    title = CategoryTexts.category;
    icon = CategoryIcons.category;
    route = Routes.category;
    page = const CategoryPage();
    apis = CategoryAPIs();
    icons = CategoryIcons();
    texts = CategoryTexts();
  }

  static CategoryConfig get config => _categoryConfig;
}