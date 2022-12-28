
import '../../core/config/config.dart';
import '../../core/config/routes.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/texts.dart';
import 'cart_page.dart';

class CartConfig extends Config {
  static final CartConfig _cartConfig = CartConfig();
  late CartIcons icons;
  late CartTexts texts;

  CartConfig() {
    title = CartTexts.cart;
    icon = CartIcons.cart;
    route = Routes.cart;
    page = const CartPage();
    icons = CartIcons();
    texts = CartTexts();
  }

  static CartConfig get config => _cartConfig;
}
