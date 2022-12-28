import 'package:kaz_reader/services/apis.dart';

import '../../core/config/config.dart';
import '../../core/config/routes.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/texts.dart';
import 'library_page.dart';

class LibraryConfig extends Config {
  static final LibraryConfig _libraryConfig = LibraryConfig();
  late LibraryAPIs apis;
  late LibraryIcons icons;
  late LibraryTexts texts;

  LibraryConfig() {
    title = LibraryTexts.library;
    icon = LibraryIcons.library;
    route = Routes.library;
    page = const LibraryPage();
    apis = LibraryAPIs();
    icons = LibraryIcons();
    texts = LibraryTexts();
  }

  static LibraryConfig get config => _libraryConfig;
}