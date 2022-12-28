
import 'package:kaz_reader/core/config/config.dart';
import 'package:kaz_reader/core/config/routes.dart';
import 'package:kaz_reader/core/constants/icons.dart';
import 'package:kaz_reader/core/constants/texts.dart';
import 'package:kaz_reader/pages/Search/Search_page.dart';
import 'package:kaz_reader/services/apis.dart';

class SearchCore extends Config {
  static final SearchCore _searchConfig = SearchCore();
  late SearchAPIs apis;
  late SearchIcons icons;
  late SearchTexts texts;

  SearchCore() {
    title = SearchTexts.search;
    icon = SearchIcons.search;
    route = Routes.search;
    page = const SearchPage();
    apis = SearchAPIs();
    icons = SearchIcons();
    texts = SearchTexts();
  }

  static SearchCore get config => _searchConfig;
}