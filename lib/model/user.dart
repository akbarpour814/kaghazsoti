import 'package:flutter/cupertino.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/model/comment.dart';
import 'package:takfood_seller/model/purchase.dart';

import 'book.dart';

class User {
  late String token;
  late String firstAndLastName;
  late int nationalCode;
  late String email;
  late int phoneNumber;
  late String address;
  late String password;
  late int walletBalance;
  late List cart;
  late List<Purchase> purchaseHistory;
  late List<Book> markedBooks;
  late List<Comment> comments;
  late List<Book> library;

  User({
    required this.token,
    required this.firstAndLastName,
    required this.nationalCode,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.password,
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
