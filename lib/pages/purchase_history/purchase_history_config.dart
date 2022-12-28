import 'package:kaz_reader/pages/purchase_history/purchase_history_page.dart';
import 'package:kaz_reader/services/apis.dart';

import '../../core/config/config.dart';
import '../../core/config/routes.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/texts.dart';

class PurchaseHistoryConfig extends Config {
  static final PurchaseHistoryConfig _purchaseHistoryConfig = PurchaseHistoryConfig();
  late PurchaseHistoryAPIs apis;
  late PurchaseHistoryIcons icons;
  late PurchaseHistoryTexts texts;

  PurchaseHistoryConfig() {
    title = PurchaseHistoryTexts.purchaseHistory;
    icon = PurchaseHistoryIcons.purchaseHistory;
    route = Routes.home;
    page = const PurchaseHistoryPage();
    apis = PurchaseHistoryAPIs();
    icons = PurchaseHistoryIcons();
    texts = PurchaseHistoryTexts();
  }

  static PurchaseHistoryConfig get config => _purchaseHistoryConfig;
}