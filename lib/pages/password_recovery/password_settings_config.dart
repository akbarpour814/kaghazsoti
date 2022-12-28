
import 'package:kaz_reader/pages/password_recovery/password_recovery_page.dart';

import '../../core/config/config.dart';
import '../../core/config/routes.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/texts.dart';

class PasswordSettingsConfig extends Config {
  static final PasswordSettingsConfig _passwordSettingsConfig = PasswordSettingsConfig();
  late PasswordSettingsIcons icons;
  late PasswordSettingsTexts texts;

  PasswordSettingsConfig() {
    title = PasswordSettingsTexts.passwordSettings;
    icon = PasswordSettingsIcons.passwordSettings;
    route = Routes.passwordSettings;
    page = const PasswordRecoveryPage();
    icons = PasswordSettingsIcons();
    texts = PasswordSettingsTexts();
  }

  static PasswordSettingsConfig get config => _passwordSettingsConfig;
}