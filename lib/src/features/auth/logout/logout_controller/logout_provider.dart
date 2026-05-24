import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef LogoutNotifier = AutoDisposeAsyncNotifierProvider<LogoutProvider, void>;

final logoutProvider = LogoutNotifier(LogoutProvider.new);

class LogoutProvider extends AutoDisposeAsyncNotifier {
  @override
  FutureOr<dynamic> build() {
    // TODO: implement build
  }



}