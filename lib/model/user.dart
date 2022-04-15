import '/model/ticket_data.dart';
import '/model/purchase.dart';

import 'book.dart';

class User {
  late String token;
  late String firstAndLastName;
  late String email;
  late int phoneNumber;
  late int walletBalance;
  late List cart;
  late List<Purchase> purchaseHistory;
  late List<Book> markedBooks;
  late List<TicketData> comments;
  late List<Book> library;

  User({
    required this.token,
    required this.firstAndLastName,
    required this.email,
    required this.phoneNumber,
    required this.walletBalance,
    required this.cart,
    required this.purchaseHistory,
    required this.markedBooks,
    required this.comments,
    required this.library,
  });
}

/*User user = User(
  token: '',
  firstAndLastName: 'مجید سلطانیان تیرانچی',
  nationalCode: 1273344642,
  email: 'majidsoltaniantiranchi@gmail.com',
  phoneNumber: 09134120771,
  address: 'ایران، اصفهان، خیابان آتشگاه، پشت بنای تاریخی منارجنبان',
  password: '123456789',
  walletBalance: 0,
  cart: [],
  purchaseHistory: List.generate(10, (index) => purchase),
  markedBooks: [],
  comments: List.generate(10, (index) => comment),
  library: [],
);*/
