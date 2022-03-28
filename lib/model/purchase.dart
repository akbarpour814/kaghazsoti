import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:takfood_seller/model/book_introduction.dart';

class Purchase {
  late int id;
  late String price;
  late String date;
  late PurchaseStatus status;
  late List<BookIntroduction> books;

  Purchase.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    int priceTemp = json['final_price'] ?? 0;
    price = priceTemp == 0 ? 'رایگان' : '${priceTemp.toString().seRagham()} تومان';

    DateTime dateTime = DateTime.parse(json['created_at']);
    date = '${DateFormat('HH:mm').format(dateTime.toLocal())} - ${dateTime.toPersianDate(twoDigits: true)}';

    String statusTemp = json['real_status'];
    status = statusTemp == 'پرداخت شده' ? PurchaseStatus.bought : PurchaseStatus.waiting;

    books = [];
    for(Map<String, dynamic> bookIntroduction in json['items']) {
      books.add(BookIntroduction.fromJson(bookIntroduction['book']));
    }
  }
}

enum PurchaseStatus {
  bought, waiting, cancelled
}

extension PurchaseStatusExtension on PurchaseStatus {
  static const Map<PurchaseStatus, String> statusOfPurchases = {
    PurchaseStatus.bought: 'پرداخت شده',
    PurchaseStatus.waiting: 'پرداخت نشده',
    PurchaseStatus.cancelled: 'لغو خرید',
  };

  static const Map<PurchaseStatus, Color> statusColorOfPurchase = {
    PurchaseStatus.bought: Colors.lightGreen,
    PurchaseStatus.waiting: Colors.grey,
    PurchaseStatus.cancelled: Colors.redAccent,
  };

  String? get title => statusOfPurchases[this];

  Color? get color => statusColorOfPurchase[this];
}
