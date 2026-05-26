import 'package:flutter/material.dart';
import 'package:todo_app/src/core/utils/extensions/gap.dart';
import 'package:todo_app/src/core/utils/theme/theme.dart';
import 'package:todo_app/src/features/common/view/drop_down/custom_drop_down.dart';
import 'package:todo_app/src/features/common/view/text_field/custom_textfield_with_label.dart';

import '../../../core/utils/extensions/context.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  static const String name = "add-task";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          "Add Todo Task",
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
        child: Column(
          children: [
            CustomTextFieldWithLabel(
              label: "Task Title",
              hintText: "Enter your task title",
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
              backgroundColor: Colors.white,
              width: MediaQuery.sizeOf(context).width * 0.9,
              items: ["hi", "asdasfa", "sdg"],
              onSelectionChanged: (v) {},
              itemToString: (item) => item,
            ),
          ],
        ),
      ),
    );
  }
}
