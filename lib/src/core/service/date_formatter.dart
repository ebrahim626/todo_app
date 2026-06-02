import 'package:intl/intl.dart';

class DateFormatter {
  // Format: Feb 02, 2024
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  // Optional: If you need to parse from string
  static DateTime? parseDate(String dateString) {
    try {
      return DateFormat('MMM dd, yyyy').parse(dateString);
    } catch (e) {
      return null;
    }
  }
}
