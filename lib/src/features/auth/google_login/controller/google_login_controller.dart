import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef GoogleLoginNotifier = AutoDisposeAsyncNotifierProvider<GoogleLoginProvider, void>;

final googleLoginProvider = GoogleLoginNotifier(GoogleLoginProvider.new);

class GoogleLoginProvider extends AutoDisposeAsyncNotifier<void> {
  late AnimationController animationController;
  late Animation<double> fadeIn;
  late Animation<Offset> slideUp;

  void initAnimations(TickerProvider vsync) {
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    fadeIn = CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    slideUp = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));

    Future.delayed(const Duration(milliseconds: 500), () {
      animationController.forward();
    });
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // TODO: your Google sign-in logic
    });
  }

  @override
  FutureOr<void> build() {}
}