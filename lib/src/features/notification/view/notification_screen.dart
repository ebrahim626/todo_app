import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/src/core/utils/extensions/context.dart';
import 'package:todo_app/src/features/notification/controller/notification_provider.dart';

import '../../../core/utils/theme/theme.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  static const String name = 'notification-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationProvider);
    final notifier = ref.read(notificationProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.only(left: 24),
          icon: Icon(Icons.arrow_back_ios_new_sharp, size: 32),
          onPressed: () => Navigator.of(context).pop(),
        ),

        centerTitle: true,
        title: Text(
          "Notifications",
          style: context.text.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(height: 1.0, color: dividerColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: pendingColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You have an upcoming task: Need To Fix Main Door Lock.",
                    style: context.text.titleSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        "2 minutes ago",
                        style: context.text.titleSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
