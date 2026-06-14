class TaskPriority {
  static const int mustDo = 1;
  static const int shouldDo = 2;
  static const int canWait = 3;

  static const Map<int, String> labels = {
    mustDo: 'Must Do',
    shouldDo: 'Should Do',
    canWait: 'Can Wait',
  };

  static int? getValue(String label) {
      try{
       return labels.entries
            .firstWhere(
              (e) => e.value == label,
        )
            .key;
      }catch(_) {
        return null;
      }

  }

  static String getLabel(int value) {
    return labels[value] ?? 'Unknown';
  }
}