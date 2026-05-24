import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/src/features/splash_screen/controller/splash_provider.dart';
import '../../../core/utils/theme/theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  static const String name = 'splash_screen';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _logoCtrl;
  late AnimationController _textCtrl;
  late AnimationController _rippleCtrl;

  late Animation<double> _logoScale;
  late Animation<double> _logoRotate;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<double> _textSlide;
  late Animation<double> _rippleScale;
  late Animation<double> _rippleOpacity;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rippleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScale = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut),
    );
    _logoRotate = Tween(begin: 0.3, end: 0.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOutCubic),
    );
    _logoFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: const Interval(0.0, 0.4)),
    );
    _textFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn),
    );
    _textSlide = Tween(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut),
    );
    _rippleScale = Tween(begin: 0.3, end: 2.5).animate(
      CurvedAnimation(parent: _rippleCtrl, curve: Curves.easeOut),
    );
    _rippleOpacity = Tween(begin: 0.25, end: 0.0).animate(
      CurvedAnimation(parent: _rippleCtrl, curve: Curves.easeIn),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    // Ripple first
    _rippleCtrl.repeat();

    await Future.delayed(const Duration(milliseconds: 200));
    await _logoCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 100));
    await _textCtrl.forward();

    // Auth check happens via provider
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _rippleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(splashScreenProvider(context));

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [

            // Ripple ring
            AnimatedBuilder(
              animation: _rippleCtrl,
              builder: (_, __) => Transform.scale(
                scale: _rippleScale.value,
                child: Opacity(
                  opacity: _rippleOpacity.value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1FB4C4),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Logo + text
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _logoCtrl,
                  builder: (_, __) => Opacity(
                    opacity: _logoFade.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: Transform.rotate(
                        angle: _logoRotate.value,
                        child: Image.asset(
                          'assets/images/todo_loading.png',
                          width: 90,
                          height: 90,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                AnimatedBuilder(
                  animation: _textCtrl,
                  builder: (_, __) => Opacity(
                    opacity: _textFade.value,
                    child: Transform.translate(
                      offset: Offset(0, _textSlide.value),
                      child: const Text(
                        'Todo App',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
