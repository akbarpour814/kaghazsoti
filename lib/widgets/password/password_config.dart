
import '../../core/constants/icons.dart';
import '../../core/constants/texts.dart';

class PasswordConfig {
  static final PasswordConfig _passwordConfig = PasswordConfig();
  late PasswordIcons icons;
  late PasswordTexts texts;
  //late NumberPhoneColors colors;

  PasswordConfig() {
    icons = PasswordIcons();
    texts = PasswordTexts();
    //colors = NumberPhoneColors();
  }

  static PasswordConfig get config => _passwordConfig;
}