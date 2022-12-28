
class BaseTexts {
  final String waiting = 'لطفاً شکیبا باشید.';
  final String error = 'خطایی رخ داد؛ لطفاً صفحه را به پایین بکشید.';
}

class HomeTexts extends BaseTexts {
  static const String home = 'خانه';

  final String audioBooks = 'کتاب های صوتی';
  final String voicemails = 'نامه های صوتی';
  final String ebooks = 'کتاب های الکترونیکی';
  final String podcasts = 'پادکست ها';
  final String childrenAndTeenagersBooks = 'کتاب های کودک و نوجوان';
  final String latestBooks = 'تازه ترین';
  final String bestSellingBooks = 'پر فروش ترین';
  final String showAll = 'نمایش همه';
}

class CategoryTexts extends BaseTexts {
  static const String category = 'دسته بندی';

  final String audioBooks = 'کتاب صوتی';
  final String voicemails = 'نامه صوتی';
  final String ebooks = 'کتاب الکترونیکی';
  final String podcasts = 'پادکست';
  final String childrenAndTeenagersBooks = 'کتاب کودک و نوجوان';
}

class LibraryTexts extends BaseTexts {
  static const String library = 'کتابخانه من';
}

class ProfileTexts extends BaseTexts {
  static const String profile = 'نمایه من';

  final String editProfile = 'ویرایش حساب کاربری';
  final String cart = 'سبد خرید';
  final String purchaseHistory = 'تاریخچه خرید';
  final String marked = 'نشان شده ها';
  final String passwordSettings = 'تغییر رمز';
  final String faq = 'سوالات متداول';
  final String contactUs = 'تماس با ما';
  final String aboutUs = 'درباره ما';
  final String lightTheme = 'زمینه روشن';
  final String darkTheme = 'زمینه تیره';
  final String logOut = 'خروج از حساب کاربری';
}

class SearchTexts extends BaseTexts {
  static const String search = 'جست و جو';
}

class EditProfileTexts extends BaseTexts {
  static const String editProfile = 'ویرایش حساب کاربری';

  final String editingProfile = 'ویرایش حساب کاربری';
}

class CartTexts extends BaseTexts {
  static const String cart = 'سبد خرید';
}

class PurchaseHistoryTexts extends BaseTexts {
  static const String purchaseHistory = 'تاریخچه خرید';
}

class MarkedTexts extends BaseTexts {
  static const String marked = 'نشان شده ها';
}

class PasswordSettingsTexts extends BaseTexts {
  static const String passwordSettings = 'تغییر رمز';
}

class FAQTexts extends BaseTexts {
  static const String faq = 'سوالات متداول';
}

class ContactUsTexts extends BaseTexts {
  static const String contactUs = 'تماس با ما';
}

class AboutUsTexts extends BaseTexts {
  static const String aboutUs = 'درباره ما';
}

class FirstAndLastNameTexts extends BaseTexts {
  final String helperText = 'نام و نام خانوادگی';
  final String hintText = 'لطفاً نام و نام خانوادگی خود را وارد کنید.';
  final String noFirstAndLastNameError = 'لطفاً نام و نام خانوادگی خود را وارد کنید.';
  final String invalidFirstAndLastNameError = 'لطفاً نام و نام خانوادگی معتبر وارد کنید.';
}

class NumberPhoneTexts extends BaseTexts {
  final String helperText = 'تلفن همراه';
  final String hintText = 'لطفاً شماره تلفن همراه خود را وارد کنید.';
  final String noNumberPhoneError = 'لطفاً شماره تلفن همراه خود را وارد کنید.';
  final String invalidNumberPhoneError = 'لطفاً شماره تلفن همراه معتبر وارد کنید.';
}

class PasswordTexts extends BaseTexts {
  final String helperText = 'تلفن همراه';
  final String hintText = 'لطفاً شماره تلفن همراه خود را وارد کنید.';
  final String noNumberPhoneError = 'لطفاً شماره تلفن همراه خود را وارد کنید.';
  final String invalidNumberPhoneError = 'لطفاً شماره تلفن همراه معتبر وارد کنید.';
}

class BookTexts extends BaseTexts {
}