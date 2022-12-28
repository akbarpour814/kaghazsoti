class MainAPIs {

}

class EditProfileAPIs extends MainAPIs {
  final String editProfile = 'api/user';
  final String profile = 'api/user';
}

class FAQAPIs extends MainAPIs {
  final String faq = 'api/faq';
}

class AboutUsAPIs extends MainAPIs {
  final String aboutUs = 'api/درباره-ما';
  final String adminInfo = 'api/admin/info';
}

class HomeAPIs extends MainAPIs {
  final String home = 'api/home';

  final String audioBooks = 'کتاب-صوتی';
  final String voicemails = 'نامه-صوتی';
  final String ebooks = 'کتاب-الکترونیکی';
  final String podcasts = 'پادکست';
  final String childrenAndTeenagersBooks = 'کتاب-کودک-و-نوجوان';
}

class CategoryAPIs extends MainAPIs {
  final String category = 'api/categories';
}

class LibraryAPIs extends MainAPIs {
  final String library = 'api/dashboard/my_books';
  final String removeFreeBook = 'api/dashboard/free/remove';
}

class MarkedAPIs extends MainAPIs {
  final String marked = 'api/dashboard/users/wish';
}

class PurchaseHistoryAPIs extends MainAPIs {
  final String purchaseHistory = 'api/dashboard/invoices';
}

class BookAPIs extends MainAPIs {
  final String book = 'api/books';
}

class SearchAPIs extends MainAPIs {
  final String books = 'api/books';
  final String search = 'api/search';
}