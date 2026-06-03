import 'package:intl/intl.dart';

class DateTimeFormatter {
  DateTimeFormatter._();

  static String time(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('h:mm a').format(dateTime.toLocal());
  }

  static String date(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('dd MMM yyyy').format(dateTime.toLocal());
  }

  static String dateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('dd MMM yyyy, h:mm a').format(dateTime.toLocal());
  }
}