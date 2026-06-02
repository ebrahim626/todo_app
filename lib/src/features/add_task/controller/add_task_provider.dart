import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';


typedef AddTaskNotifier = AutoDisposeAsyncNotifierProvider<AddTaskProvider, void>;

final addTaskProvider = AddTaskNotifier(AddTaskProvider.new);

class AddTaskProvider extends AutoDisposeAsyncNotifier{

  DateTime? selectedDueDate;
  DateTime? selectedReminderDate;

  @override
  FutureOr<dynamic> build() {

  }

  void onDueDateChange(DateTime? date) {
    if (date != null) {
      selectedDueDate = date;
      ref.notifyListeners();
    }
  }
  void onReminderDateChange(DateTime? date) {
    if (date != null) {
      selectedReminderDate = date;
      ref.notifyListeners();
    }
  }

}