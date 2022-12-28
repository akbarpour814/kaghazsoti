
import 'package:flutter/cupertino.dart';

import '../../core/config/config.dart';
import '../about_us/about_us_config.dart';
import '../cart/cart_config.dart';
import '../contact_us/contact_us_config.dart';
import '../edit_profile/edit_profile_config.dart';
import '../faq/faq_config.dart';
import '../marked/marked_config.dart';
import '../password_recovery/password_settings_config.dart';
import '../purchase_history/purchase_history_config.dart';

enum ProfileEnum {
  editProfile,
  cart,
  purchaseHistory,
  marked,
  passwordSettings,
  faq,
  contactUs,
  aboutUs;
}

extension ProfileEnumExtension on ProfileEnum {
  Config get _configs {
    return {
      ProfileEnum.editProfile: EditProfileConfig.config,
      ProfileEnum.cart: CartConfig.config,
      ProfileEnum.purchaseHistory: PurchaseHistoryConfig.config,
      ProfileEnum.marked: MarkedConfig.config,
      ProfileEnum.passwordSettings: PasswordSettingsConfig.config,
      ProfileEnum.faq: FAQConfig.config,
      ProfileEnum.contactUs: ContactUsConfig.config,
      ProfileEnum.aboutUs: AboutUsConfig.config,
    }[this]!;
  }

  String get title => _configs.title;

  IconData get icon => _configs.icon;

  Widget get page => _configs.page;
}
