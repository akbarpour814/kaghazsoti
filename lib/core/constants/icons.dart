

import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';

class BaseIcons {
  final IconData undone = Ionicons.checkmark_outline;
  final IconData done = Ionicons.checkmark_done_outline;
}

class HomeIcons extends BaseIcons {
  static const IconData home = Ionicons.home_outline;
}

class CategoryIcons extends BaseIcons {
  static const IconData category = Ionicons.albums_outline;

  final IconData audioBooks = Ionicons.musical_notes_outline;
  final IconData voicemails = Ionicons.mail_open_outline;
  final IconData ebooks = Ionicons.laptop_outline;
  final IconData podcasts = Ionicons.volume_medium_outline;
  final IconData childrenAndTeenagersBooks = Ionicons.happy_outline;

}

class LibraryIcons extends BaseIcons {
  static const IconData library = Ionicons.library_outline;
}

class ProfileIcons extends BaseIcons {
  static const IconData profile = Ionicons.person_outline;

  final IconData editProfile = Ionicons.pencil_outline;
  final IconData cart = Ionicons.bag_outline;
  final IconData purchaseHistory = Ionicons.calendar_outline;
  final IconData marked = Ionicons.bookmark_outline;
  final IconData passwordSettings = Ionicons.key_outline;
  final IconData faq = Ionicons.help;
  final IconData contactUs = Ionicons.call_outline;
  final IconData aboutUs = Ionicons.information_outline;
  final IconData lightTheme = Ionicons.sunny_outline;
  final IconData darkTheme = Ionicons.moon_outline;
  final IconData logOut = Ionicons.log_out_outline;
}

class EditProfileIcons extends BaseIcons {
  static const IconData editProfile = Ionicons.pencil_outline;

  final IconData editingProfile = editProfile;
}

class CartIcons extends BaseIcons {
  static const IconData cart = Ionicons.bag_outline;
}

class PurchaseHistoryIcons extends BaseIcons {
  static const IconData purchaseHistory = Ionicons.calendar_outline;
}

class MarkedIcons extends BaseIcons {
  static const IconData marked = Ionicons.bookmark_outline;
}

class PasswordSettingsIcons extends BaseIcons {
  static const IconData passwordSettings = Ionicons.key_outline;
}

class FAQIcons extends BaseIcons {
  static const IconData faq = Ionicons.help;
}

class ContactUsIcons extends BaseIcons {
  static const IconData contactUs = Ionicons.call_outline;
}

class AboutUsIcons extends BaseIcons {
  static const IconData aboutUs = Ionicons.information_outline;
}

class SearchIcons extends BaseIcons {
  static const IconData search = Ionicons.search_outline;
}

class FirstAndLastNameIcons extends BaseIcons {
  final IconData suffixIcon = Ionicons.person_outline;
}

class NumberPhoneIcons extends BaseIcons {
  final IconData suffixIcon = Ionicons.phone_portrait_outline;
}

class PasswordIcons extends BaseIcons {
  final IconData visible = Ionicons.eye_outline;
  final IconData invisible = Ionicons.eye_off_outline;
}

class BookIcons extends BaseIcons {
  final IconData suffixIcon = Ionicons.key;
  final IconData refresh_outline = Ionicons.refresh_outline;
}






































/*
class AboutUsIcons with CommonIcons {
  final aboutUs = Ionicons.information_outline;
  final website = Ionicons.earth_outline;
  final email = Ionicons.logo_yahoo;
  final whatsapp = Ionicons.logo_whatsapp;
}

class AccountIcons with CommonIcons {
  final edit_profile = Ionicons.person_outline;
  final checkmark = Ionicons.checkmark_outline;
  final checkmarkDone = Ionicons.checkmark_done_outline;
  final number_phone = Ionicons.phone_portrait_outline;
}

class BookIcons with CommonIcons {
  final bookmark = Ionicons.bookmark_outline;
  final document = Ionicons.document_text_outline;
  final bagRemove = Ionicons.bag_remove_outline;
  final bagAdd = Ionicons.bag_add_outline;
  final library = Ionicons.library_outline;
}



class CartIcons with CommonIcons {
  final bag = Ionicons.bag_outline;
  final bagCheck = Ionicons.bag_check_outline;
  final card = Ionicons.card_outline;
  final call = Ionicons.call_outline;
}




class CategoryIcons with CommonIcons, BottomNavigationBarIcons {
  final bag = Ionicons.musical_notes_outline;
  final bagCheck = Ionicons.mail_open_outline;
  final card = Ionicons.laptop_outline;
  final call = Ionicons.volume_medium_outline;
  final happy = Ionicons.happy_outline;
  final albums = Ionicons.albums_outline;
}

class ContactUsIcons with CommonIcons {
  final bag = Ionicons.musical_notes_outline;
  final bagCheck = Ionicons.mail_open_outline;
  final card = Ionicons.laptop_outline;
  final call = Ionicons.volume_medium_outline;
  final happy = Ionicons.happy_outline;
  final albums = Ionicons.albums_outline;
}

class FrequentlyAskedQuestionsIcons with CommonIcons {
  final bag = Ionicons.musical_notes_outline;
  final bagCheck = Ionicons.mail_open_outline;
  final card = Ionicons.laptop_outline;
  final call = Ionicons.volume_medium_outline;
  final happy = Ionicons.happy_outline;
  final albums = Ionicons.albums_outline;
}



class LibraryIcons with CommonIcons, BottomNavigationBarIcons {
  final bag = Ionicons.musical_notes_outline;
  final bagCheck = Ionicons.mail_open_outline;
  final card = Ionicons.laptop_outline;
  final call = Ionicons.volume_medium_outline;
  final happy = Ionicons.happy_outline;
  final albums = Ionicons.albums_outline;
}

class MainIcons with CommonIcons {
  final bag = Ionicons.musical_notes_outline;
  final bagCheck = Ionicons.mail_open_outline;
  final card = Ionicons.laptop_outline;
  final call = Ionicons.volume_medium_outline;
  final happy = Ionicons.happy_outline;
  final albums = Ionicons.albums_outline;
}

class MarkedIcons with CommonIcons {
  final bag = Ionicons.musical_notes_outline;
  final bagCheck = Ionicons.mail_open_outline;
  final card = Ionicons.laptop_outline;
  final call = Ionicons.volume_medium_outline;
  final happy = Ionicons.happy_outline;
  final albums = Ionicons.albums_outline;
}

class PasswordSettingIcons with CommonIcons {
  final bag = Ionicons.musical_notes_outline;
  final bagCheck = Ionicons.mail_open_outline;
  final card = Ionicons.laptop_outline;
  final call = Ionicons.volume_medium_outline;
  final happy = Ionicons.happy_outline;
  final albums = Ionicons.albums_outline;
}

class ProfileIcons with CommonIcons, BottomNavigationBarIcons {
  final bag = Ionicons.musical_notes_outline;
  final bagCheck = Ionicons.mail_open_outline;
  final card = Ionicons.laptop_outline;
  final call = Ionicons.volume_medium_outline;
  final happy = Ionicons.happy_outline;
  final albums = Ionicons.albums_outline;
}

class PurchaseIcons with CommonIcons {
  final bag = Ionicons.musical_notes_outline;
  final bagCheck = Ionicons.mail_open_outline;
  final card = Ionicons.laptop_outline;
  final call = Ionicons.volume_medium_outline;
  final happy = Ionicons.happy_outline;
  final albums = Ionicons.albums_outline;
}

class SearchIcons with CommonIcons, BottomNavigationBarIcons {
  final bag = Ionicons.musical_notes_outline;
  final bagCheck = Ionicons.mail_open_outline;
  final card = Ionicons.laptop_outline;
  final call = Ionicons.volume_medium_outline;
  final happy = Ionicons.happy_outline;
  final albums = Ionicons.albums_outline;
}
*/

