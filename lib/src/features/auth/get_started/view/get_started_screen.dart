import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/src/features/auth/get_started/controller/get_started_controller.dart';
import 'package:todo_app/src/features/auth/google_login/view/google_login_screen.dart';
import '../../../../core/config/constant/assets_path.dart';
import '../../../../core/utils/extensions/context.dart';
import '../../../../core/utils/extensions/gap.dart';
import '../../../../core/utils/theme/theme.dart';
import '../../../common/view/app_button/app_button.dart';

class GetStartedScreen extends ConsumerWidget {
  const GetStartedScreen({super.key});

  static const String name = "get-started";

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    ref.watch(getStartedProvider);
    final notifier = ref.read(getStartedProvider.notifier);

    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 35.0, left: 35, top: 65),
            child: Image.asset(AssetsPath.loginCartoon, fit: BoxFit.contain),
          ),

          Expanded(
            child: Hero(
              tag: "main-container",
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    color: backgroundColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "“Let’s Get Started Your Journey To Always Be On Time”",
                        style: context.text.titleLarge?.copyWith(
                          fontSize: 28,
                          color: bigTextColor,
                        ),
                      ),
                      14.ph,
                      Text(
                        "From daily reminders to important deadlines, our app keeps everything organized to help you save time and make life easier.",
                        style: context.text.bodySmall?.copyWith(
                          color: bigTextColor,
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(99),
                              color: primaryColor,
                            ),
                          ),
                          12.pw,
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(99),
                              color: greyContainer,
                            ),
                          ),
                        ],
                      ),
                      40.ph,
                      AppButton(
                        text: "Get Started",
                        showArrow: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              pageBuilder: (_, __, ___) => const GoogleLoginScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
