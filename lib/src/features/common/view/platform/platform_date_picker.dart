import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformDatePicker {
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
    String? primaryButtonText,
  }) async {
    // Ensure initialDate is valid and within bounds
    final now = DateTime.now();
    DateTime effectiveInitialDate = initialDate ?? now;

    // Clamp initialDate between minimumDate and maximumDate
    if (minimumDate != null && effectiveInitialDate.isBefore(minimumDate)) {
      effectiveInitialDate = minimumDate;
    }
    if (maximumDate != null && effectiveInitialDate.isAfter(maximumDate)) {
      effectiveInitialDate = maximumDate;
    }

    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return isIOS
        ? await _showCupertinoDatePicker(
            context,
            effectiveInitialDate,
            minimumDate,
            maximumDate,
            primaryButtonText,
          )
        : await _showMaterialDatePicker(
            context,
            effectiveInitialDate,
            minimumDate,
            maximumDate,
            primaryButtonText,
          );
  }

  static Future<DateTime?> _showCupertinoDatePicker(
    BuildContext context,
    DateTime initialDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
    String? primaryButtonText,
  ) async {
    DateTime selectedDate = initialDate; // Use non-nullable initialDate

    return await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(
                      context,
                      initialDate,
                    ), // Return initialDate on cancel
                  ),
                  CupertinoButton(
                    child: Text(primaryButtonText ?? 'Done'),
                    onPressed: () => Navigator.pop(context, selectedDate),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  minimumDate: minimumDate ?? DateTime(1900),
                  maximumDate: maximumDate ?? DateTime(2100),
                  onDateTimeChanged: (DateTime newDate) {
                    selectedDate = newDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<DateTime?> _showMaterialDatePicker(
    BuildContext context,
    DateTime initialDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
    String? primaryButtonText,
  ) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minimumDate ?? DateTime(1900),
      lastDate: maximumDate ?? DateTime(2100),
      confirmText: primaryButtonText ?? 'OK',
    );
  }
}
