extension DateTimeFormat on DateTime {
  String format() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} - $year/${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}';
}