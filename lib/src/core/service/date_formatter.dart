import 'package:intl/intl.dart';

class DateFormatter {
  // Format: Feb 02, 2024
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM, yyyy').format(date);
  }

  // Format: Monday, 25 May 2026
  static String formatDateWithDay(DateTime date) {
    return DateFormat('EEEE, dd MMM yyyy').format(date);
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
