import 'package:flutter/animation.dart';


class BaseColors {
  static const Color skobeloff = Color(0xFF005C6B);
  static const Color darkJungleGreen = Color(0xFF171E26);
  static const Color arsenic = Color(0xFF424242);
  static const Color sonicSilver = Color(0xFF757575);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color white = Color(0xFFFFFFFF);

  static const Color primaryColor = skobeloff;
  static Color focusColor = skobeloff.withOpacity(0.6);
  static Color selectionColor = skobeloff.withOpacity(0.6);
  static const Color lightBackgroundColor = white;
  static const Color darkBackgroundColor = darkJungleGreen;
  static const Color dividerColor = skobeloff;
  static const Color lightCanvasColor = skobeloff;
  static const Color darkCanvasColor = arsenic;
  static const Color accentColor = skobeloff;
  static const Color darkBackgroundAppBarColor = skobeloff;
  static const Color cardBorderColor = grey;

  static const Color activeColorPrimary = skobeloff;
  static const Color activeColorSecondary = skobeloff;
  static const Color inactiveColorPrimary = grey;
  static const Color iconColor = skobeloff;


}

class ProfileColors extends BaseColors {

}

class EditProfileColors extends BaseColors {
  final Color authorizedEditingProfile = BaseColors.sonicSilver;
  final Color unauthorizedEditingProfile = BaseColors.skobeloff;
  final Color circularProgressIndicator = BaseColors.white;

}

class FirstAndLastNameColors extends BaseColors {
  final Color authorizedEditingProfile = BaseColors.sonicSilver;
  final Color unauthorizedEditingProfile = BaseColors.skobeloff;

}

class NumberPhoneColors extends BaseColors {
  final Color authorizedEditingProfile = BaseColors.sonicSilver;
  final Color unauthorizedEditingProfile = BaseColors.skobeloff;

}

class BookIntroductionColors extends BaseColors {
  final Color lightBackground = BaseColors.lightBackgroundColor;
  final Color darkBackground = BaseColors.darkBackgroundColor;
  final Color border = BaseColors.skobeloff;

}
