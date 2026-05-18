import 'package:flutter/material.dart';
import 'package:todo_app/src/features/common/view/app_button/app_button.dart';
import '../../../../core/config/constant/assets_path.dart';
import '../../../../core/utils/extensions/context.dart';
import '../../../../core/utils/extensions/gap.dart';
import '../../../../core/utils/theme/theme.dart';

class GoogleLoginScreen extends StatefulWidget {
  const GoogleLoginScreen({super.key});

  @override
  State<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends State<GoogleLoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // ✅ Wait for Hero flight to finish, then fade content in
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Hero(
        tag: 'main-container',
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            decoration: const BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            // ✅ Only this part is new — wraps your existing Column
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 84,
                        left: 84,
                        top: 65,
                      ),
                      child: Image.asset(
                        AssetsPath.transparentLogo,
                        fit: BoxFit.contain,
                      ),
                    ),
                    60.ph,
                    Text(
                      "\u201cSign in with Google to continue managing your tasks and staying productive.\u201d",
                      style: context.text.titleLarge?.copyWith(
                        fontSize: 28,
                        color: bigTextColor,
                      ),
                    ),
                    14.ph,
                    Text(
                      "Access your personalized workspace, track daily goals, and keep everything organized in one place.",
                      style: context.text.bodySmall?.copyWith(
                        color: bigTextColor,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            color: greyContainer,
                          ),
                        ),
                        12.pw,
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    40.ph,
                    AppButton(
                      text: "Sign in with Google",
                      showArrow: true,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
