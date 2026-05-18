import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef GetStartedNotifier = AutoDisposeAsyncNotifierProvider<GetStartedProvider, void>;

final getStartedProvider = GetStartedNotifier(GetStartedProvider.new);

class GetStartedProvider extends AutoDisposeAsyncNotifier<void> {

  @override
  FutureOr<void> build() {
    // initialization logic
  }
}