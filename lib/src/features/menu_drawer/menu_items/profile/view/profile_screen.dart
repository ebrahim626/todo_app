import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/src/features/menu_drawer/menu_items/profile/controller/profile_controller.dart';
import '../../../../../core/utils/extensions/gap.dart';
import '../../../../../core/utils/theme/theme.dart';
import '../../../../../core/utils/theme/theme.dart' as theme;
import '../../../../common/view/text_field/custom_textfield_with_label.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const String name = "profile_screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);
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
          "My Profile",
          style: theme.textTheme.titleLarge?.copyWith(
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
        child: Form(
          child: Column(
            children: [
              CustomTextFieldWithLabel(
                label: "Email",
                hintText: "Enter your email",
                controller: notifier.emailController,
                isRequired: "*",
              ),
              14.ph,
              CustomTextFieldWithLabel(
                label: "Name",
                hintText: "Enter your name",
                controller: notifier.nameController,
                isRequired: "*",
              ),
              14.ph,

            ],
          ),
        ),
      ),
    );
  }
}
