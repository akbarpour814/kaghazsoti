
import '../../core/constants/colors.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/texts.dart';

class FirstAndLastNameConfig {
  static final FirstAndLastNameConfig _firstAndLastNameConfig = FirstAndLastNameConfig();
  late FirstAndLastNameIcons icons;
  late FirstAndLastNameTexts texts;
  late FirstAndLastNameColors colors;

  FirstAndLastNameConfig() {
    icons = FirstAndLastNameIcons();
    texts = FirstAndLastNameTexts();
    colors = FirstAndLastNameColors();
  }

  static FirstAndLastNameConfig get config => _firstAndLastNameConfig;
}