import '../../core/constants/colors.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/texts.dart';

class BookIntroductionConfig {
  static final BookIntroductionConfig _bookIntroductionConfig = BookIntroductionConfig();
  late BookIntroductionColors colors;

  BookIntroductionConfig() {
    colors = BookIntroductionColors();
  }

  static BookIntroductionConfig get config => _bookIntroductionConfig;
}
