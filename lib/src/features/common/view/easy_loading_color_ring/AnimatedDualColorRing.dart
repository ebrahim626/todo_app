import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AnimatedDualColorRing extends StatefulWidget {
  const AnimatedDualColorRing();

  @override
  State<AnimatedDualColorRing> createState() => _AnimatedDualColorRingState();
}

class _AnimatedDualColorRingState extends State<AnimatedDualColorRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: const Color(0xffF5B041),
      end: const Color(0xff1FB4C4),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return SpinKitRing(
          color: _colorAnimation.value ?? const Color(0xffF5B041),
          size: 100.0,
          lineWidth: 7.0,
        );
      },
    );
  }
}