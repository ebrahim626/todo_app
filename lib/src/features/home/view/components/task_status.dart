class TaskStatus {
  static const int done = 1;
  static const int closed = 2;
  static const int pending = 3;
  static const int upcoming = 4;

  static const Map<int, String> labels = {
    done: 'Done',
    closed: 'Closed',
    pending: 'Pending',
    upcoming: 'Upcoming',
  };

  static int? getValue(String label) {
    try {
      return labels.entries
          .firstWhere((e) => e.value == label)
          .key;
    } catch (_) {
      return null;
    }
  }

  static String getLabel(int value) {
    return labels[value] ?? 'Unknown';
  }
}