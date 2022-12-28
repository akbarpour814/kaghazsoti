import '../../core/config/config.dart';
import '../../core/config/routes.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/texts.dart';
import '../../services/apis.dart';
import 'edit_profile_page.dart';

class EditProfileConfig extends Config {
  static final EditProfileConfig _editProfileConfig = EditProfileConfig();
  late EditProfileAPIs apis;
  late EditProfileIcons icons;
  late EditProfileTexts texts;
  late EditProfileColors colors;

  EditProfileConfig() {
    title = EditProfileTexts.editProfile;
    icon = EditProfileIcons.editProfile;
    route = Routes.editProfile;
    page = EditProfilePage();
    apis = EditProfileAPIs();
    icons = EditProfileIcons();
    texts = EditProfileTexts();
    colors = EditProfileColors();
  }

  static EditProfileConfig get config => _editProfileConfig;
}