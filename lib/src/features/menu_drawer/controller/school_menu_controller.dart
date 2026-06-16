import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SchoolMenu { enrollment, instructor, weeklyView, students, courses, home, analytics }

typedef SchoolMenuNotifier = AsyncNotifierProvider<SchoolMenuProvider, void>;

final schoolMenuProvider = SchoolMenuNotifier(SchoolMenuProvider.new);

class SchoolMenuProvider extends AsyncNotifier {
  late SchoolMenu selectedMenu;

  @override
  FutureOr<dynamic> build() {
    selectedMenu = SchoolMenu.enrollment;
  }

  void onMenuTap(SchoolMenu menu) {
    selectedMenu = menu;
    ref.notifyListeners();
  }
}
