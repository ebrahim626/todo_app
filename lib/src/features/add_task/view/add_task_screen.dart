import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/src/core/service/date_formatter.dart';
import 'package:todo_app/src/core/service/time_formatter.dart';
import 'package:todo_app/src/core/utils/extensions/gap.dart';
import 'package:todo_app/src/core/utils/theme/theme.dart';
import 'package:todo_app/src/features/add_task/controller/add_task_provider.dart';
import 'package:todo_app/src/features/common/view/app_button/app_button.dart';
import 'package:todo_app/src/features/common/view/drop_down/custom_drop_down.dart';
import 'package:todo_app/src/features/common/view/text_field/custom_textfield_with_label.dart';
import '../../../core/utils/extensions/context.dart';
import '../../common/view/platform/platform_date_picker.dart';
import '../../common/view/platform/show_time_picker.dart';

class AddTaskScreen extends ConsumerWidget {
  const AddTaskScreen({super.key});

  static const String name = "add-task";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    ref.watch(addTaskProvider);
    final notifier = ref.read(addTaskProvider.notifier);

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
        child: Form(
          key: notifier.formKey,
          child: Column(
            children: [
              CustomTextFieldWithLabel(
                label: "Task Title",
                hintText: "Enter your task title",
                controller: notifier.taskTitleController,
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
                selectedItem: notifier.selectedTaskType,
                height: MediaQuery.sizeOf(context).height * 0.65,
                backgroundColor: Colors.white,
                width: MediaQuery.sizeOf(context).width * 0.9,
                items: notifier.taskTypes,
                onSelectionChanged: (v) {
                  notifier.onTaskTypeChange(v);
                },
                itemToString: (item) => item,
              ),
              14.ph,
              Row(
                children: [
                  Text(
                    "Task Priority",
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
                label: "Select Task Priority",
                backgroundColor: Colors.white,
                selectedItem: notifier.selectedTaskPriority,
                width: MediaQuery.sizeOf(context).width * 0.9,
                items: ["Must Do", "Should Do", "Can Wait"],
                onSelectionChanged: (v) {
                  notifier.onTaskPriorityChange(v);
                },
                itemToString: (item) => item,
              ),
              14.ph,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Due Date",
                              style: context.text.titleSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "*",
                              style: context.text.titleSmall?.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        8.ph,
                        CustomTextFieldWithLabel(
                          hintText: "Select Date",
                          isRequired: "*",
                          readOnly: true,
                          controller: TextEditingController(
                            text: notifier.selectedDueDate != null
                                ? DateFormatter.formatDate(
                                    notifier.selectedDueDate!,
                                  )
                                : "",
                          ),
                          onTap: () async {
                            // Calculate min and max dates based on selected student age
                            final now = DateTime.now();

                            DateTime minDate;
                            DateTime maxDate;

                            // Adult: 18 years or older
                            maxDate = DateTime(3000);
                            minDate = DateTime(
                              1900,
                            ); // Or any reasonable minimum date

                            final selectedDate = await PlatformDatePicker.show(
                              context,
                              initialDate: notifier.selectedDueDate ?? now,
                              minimumDate: minDate,
                              maximumDate: maxDate,
                              primaryButtonText: "Select",
                            );

                            if (selectedDate != null) {
                              notifier.onDueDateChange(selectedDate);
                            }
                          },
                          trailing: Icon(
                            Icons.calendar_today,
                            color: hintTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  14.pw,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Due Time",
                              style: context.text.titleSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "*",
                              style: context.text.titleSmall?.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        8.ph,
                        CustomTextFieldWithLabel(
                          hintText: "Select Time",
                          readOnly: true,
                          isRequired: "*",
                          controller: TextEditingController(
                            text: notifier.selectedDueTime != null
                                ? DateTimeFormatter.formatTime(
                                    notifier.selectedDueTime ?? TimeOfDay.now(),
                                  )
                                : "",
                          ),
                          onTap: () async {
                            final selectedTime = await PlatformTimePicker.show(
                              context,
                              initialTime:
                                  notifier.selectedDueTime ?? TimeOfDay.now(),
                              primaryButtonText: 'Select',
                            );

                            if (selectedTime != null) {
                              notifier.onDueTimeChange(selectedTime);
                            }
                          },
                          trailing: const Icon(
                            Icons.access_time,
                            color: hintTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              14.ph,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Reminder Date",
                              style: context.text.titleSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "*",
                              style: context.text.titleSmall?.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        8.ph,
                        CustomTextFieldWithLabel(
                          hintText: "Select Date",
                          isRequired: "*",
                          readOnly: true,
                          controller: TextEditingController(
                            text: notifier.selectedReminderDate != null
                                ? DateFormatter.formatDate(
                                    notifier.selectedReminderDate!,
                                  )
                                : "",
                          ),
                          onTap: () async {
                            // Calculate min and max dates based on selected student age
                            final now = DateTime.now();

                            DateTime minDate;
                            DateTime maxDate;

                            // Adult: 18 years or older
                            maxDate = DateTime(3000);
                            minDate = DateTime(
                              1900,
                            ); // Or any reasonable minimum date

                            final selectedDate = await PlatformDatePicker.show(
                              context,
                              initialDate: notifier.selectedReminderDate ?? now,
                              minimumDate: minDate,
                              maximumDate: maxDate,
                              primaryButtonText: "Select",
                            );

                            if (selectedDate != null) {
                              notifier.onReminderDateChange(selectedDate);
                            }
                          },
                          trailing: Icon(
                            Icons.calendar_today,
                            color: hintTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  14.pw,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // ← important
                      children: [
                        Row(
                          children: [
                            Text(
                              "Reminder Time",
                              style: context.text.titleSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "*",
                              style: context.text.titleSmall?.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        8.ph,
                        CustomTextFieldWithLabel(
                          hintText: "Select Time",
                          readOnly: true,
                          isRequired: "*",
                          controller: TextEditingController(
                            text: notifier.selectedReminderTime != null
                                ? DateTimeFormatter.formatTime(
                                    notifier.selectedReminderTime ??
                                        TimeOfDay.now(),
                                  )
                                : "",
                          ),
                          onTap: () async {
                            final selectedTime = await PlatformTimePicker.show(
                              context,
                              initialTime:
                                  notifier.selectedReminderTime ??
                                  TimeOfDay.now(),
                              primaryButtonText: 'Select',
                            );

                            if (selectedTime != null) {
                              notifier.onReminderTimeChange(selectedTime);
                            }
                          },
                          trailing: const Icon(
                            Icons.access_time,
                            color: hintTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              14.ph,
              CustomTextFieldWithLabel(
                label: "Task Description",
                hintText: "Enter your task description",
                controller: notifier.taskDescriptionController,
                maxLines: 7,
                optional: true,
              ),
              Spacer(),
              AppButton(
                  text: "Add Task",
                  onTap: () {
                    notifier.addTask(context);
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
