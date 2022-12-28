
import 'package:kaz_reader/pages/profile/profile_page.dart';

import '../../core/config/config.dart';
import '../../core/config/routes.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/texts.dart';

class ProfileConfig extends Config {
  static final ProfileConfig _profileConfig = ProfileConfig();
  late ProfileIcons icons;
  late ProfileTexts texts;
  late ProfileColors colors;

  ProfileConfig() {
    title = ProfileTexts.profile;
    icon = ProfileIcons.profile;
    route = Routes.profile;
    page = const ProfilePage();
    icons = ProfileIcons();
    texts = ProfileTexts();
    colors = ProfileColors();
  }

  static ProfileConfig get config => _profileConfig;
}
