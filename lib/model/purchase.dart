import 'package:flutter/material.dart';

class Purchase {
  late int number;
  late String type;
  late int prices;
  late DateTime date;
  late PurchaseStatus status;

  Purchase({
    required this.number,
    required this.type,
    required this.prices,
    required this.date,
    required this.status,
  });
}

enum PurchaseStatus {
  bought, waiting, cancelled
}

extension PurchaseStatusExtension on PurchaseStatus {
  static const Map<PurchaseStatus, String> statusOfPurchases = {
    PurchaseStatus.bought: 'خریداری شد',
    PurchaseStatus.waiting: 'در انتظار خرید',
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
