import 'package:kaz_reader/services/apis.dart';

import '../../core/config/config.dart';
import '../../core/config/routes.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/texts.dart';
import 'marked_page.dart';



class MarkedConfig extends Config {
  static final MarkedConfig _markedConfig = MarkedConfig();
  late MarkedAPIs apis;
  late MarkedIcons icons;
  late MarkedTexts texts;

  MarkedConfig() {
    title = MarkedTexts.marked;
    icon = MarkedIcons.marked;
    route = Routes.marked;
    page = const MarkedPage();
    apis = MarkedAPIs();
    icons = MarkedIcons();
    texts = MarkedTexts();
  }

  static MarkedConfig get config => _markedConfig;
}