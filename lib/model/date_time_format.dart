import 'package:intl/intl.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class DateTimeFormat {
  static String dateTimeFormat({required String date}) {
    DateTime dateTime = DateTime.parse(date);

    return '${DateFormat('HH:mm').format(dateTime.toLocal())} - ${dateTime.toPersianDate(twoDigits: true)}';
  }
}
