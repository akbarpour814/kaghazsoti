
import '../../core/constants/colors.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/texts.dart';

class NumberPhoneConfig {
  static final NumberPhoneConfig _numberPhoneConfig = NumberPhoneConfig();
  late NumberPhoneIcons icons;
  late NumberPhoneTexts texts;
  late NumberPhoneColors colors;

  NumberPhoneConfig() {
    icons = NumberPhoneIcons();
    texts = NumberPhoneTexts();
    colors = NumberPhoneColors();
  }

  static NumberPhoneConfig get config => _numberPhoneConfig;
}