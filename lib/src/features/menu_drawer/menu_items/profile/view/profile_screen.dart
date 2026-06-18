import 'package:flutter/material.dart';

import '../../../../../core/utils/extensions/context.dart';
import '../../../../../core/utils/extensions/gap.dart';
import '../../../../../core/utils/theme/theme.dart';
import '../../../../../core/utils/theme/theme.dart' as theme;
import '../../../../common/view/drop_down/custom_drop_down.dart';
import '../../../../common/view/text_field/custom_textfield_with_label.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String name = "profile_screen";

  @override
  Widget build(BuildContext context) {
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
        title: Text("Add Todo Task",
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
                label: "Task Title",
                hintText: "Enter your task title",
                // controller: notifier.taskTitleController,
                isRequired: "*",
              ),
              14.ph,
              Row(
                children: [
                  Text(
                    "Task Type",
                    style: context.text.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "*",
                    style: context.text.titleSmall?.copyWith(color: Colors.red),
                  ),
                ],
              ),
              8.ph,
              CustomDropDownPlus<String>(
                label: "Task Type",
                // selectedItem: notifier.selectedTaskType,
                height: MediaQuery.sizeOf(context).height * 0.65,
                backgroundColor: Colors.white,
                width: MediaQuery.sizeOf(context).width * 0.9,
                items: [],
                onSelectionChanged: (v) {

                },
                itemToString: (item) => item,
              ),
              14.ph,
            ],
          ),
        ),
      ),
    );
  }
}
