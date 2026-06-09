class LocalTimeFormatter {
  const LocalTimeFormatter._();

  /// For POST — preserves the user's picked local time, converts to UTC
  static String toUtcIso(DateTime localDate) {
    return localDate.toLocal().toUtc().toIso8601String();
  }

  /// For GET — full local day as UTC range (covers entire day in local timezone)
  static ({String from, String to}) dayRangeUtc(DateTime localDate) {
    final start = DateTime(
      localDate.year,
      localDate.month,
      localDate.day,
      0, 0, 0,
    );
    final end = DateTime(
      localDate.year,
      localDate.month,
      localDate.day,
      23, 59, 59, 999,
    );
    return (
    from: start.toUtc().toIso8601String(),
    to: end.toUtc().toIso8601String(),
    );
  }
}