import 'package:intl/intl.dart';

class DateTimeFormatter {
  DateTimeFormatter._();

  static String time(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('h:mm a').format(dateTime.toLocal());
  }

}