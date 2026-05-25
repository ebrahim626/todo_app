import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/extensions/context.dart';
import '../../../../core/utils/extensions/gap.dart';
import '../../../../core/utils/theme/theme.dart';

class CustomDropDownPlus<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T?> onSelectionChanged;
  final String Function(T) itemToString;
  final TextStyle? selectedTextStyle;
  final double? width;
  final double? height;
  final double? dropdownListFontSize;
  final Widget Function(T)? itemBuilder;
  final Color? labelColor;
  final Color? backgroundColor;
  final bool isCheckBox;
  final double? containerHeight;
  final double? containerWidth;
  final VoidCallback? onTap;
  final VoidCallback? onCancelSelection;
  final bool? readOnly;
  final double? verticalPadding;

  const CustomDropDownPlus({
    super.key,
    required this.label,
    required this.items,
    this.selectedItem,
    required this.onSelectionChanged,
    required this.itemToString,
    this.selectedTextStyle,
    this.width,
    this.dropdownListFontSize,
    this.itemBuilder,
    this.height,
    this.labelColor,
    this.backgroundColor,
    this.isCheckBox = false,
    this.containerHeight,
    this.containerWidth,
    this.onTap,
    this.onCancelSelection,
    this.readOnly = false,
    this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        backgroundColor: WidgetStateProperty.all(
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        ),
        maximumSize: height == null
            ? null
            : WidgetStateProperty.all(
                Size(double.infinity, height!), // Max height
              ),
        elevation: WidgetStateProperty.all(8),
      ),
      menuChildren: items.map((item) {
        final isSelected = selectedItem == item; // Ensure equality works
        return Container(
          width: width ?? double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: MenuItemButton(
            onPressed: () => onSelectionChanged(item),
            child: Row(
              children: [
                // 1️⃣ Custom itemBuilder (highest priority)
                if (itemBuilder != null)
                  itemBuilder!(item)
                // 2️⃣ Checkbox mode
                else if (isCheckBox) ...[
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) => onSelectionChanged(item),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    side: BorderSide(
                      color: primaryColor, // your custom color
                      width: 2,
                    ),
                  ),
                  8.pw,
                ],
                Flexible(
                  child: Text(
                    itemToString(item),
                    style: TextStyle(
                      color: isSelected
                          ? Theme.of(context)
                                .primaryColor // Primary color for selected item
                          : Colors.black,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: dropdownListFontSize ?? 14.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      builder: (context, controller, child) {
        return GestureDetector(
          onTap: () {
            if (readOnly == true) {
              onTap?.call();
              return;
            }
            controller.isOpen ? controller.close() : controller.open();
            onTap?.call();
          },
          child: Container(
            height: containerHeight,
            width: containerWidth,
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: verticalPadding ?? 12.h,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).unselectedWidgetColor.withAlpha(30),
              ),
              borderRadius: BorderRadius.circular(12),
              color:
                  backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    selectedItem != null
                        ? itemToString(selectedItem as T)
                        : label,
                    style:
                        selectedTextStyle ??
                        context.text.titleSmall?.copyWith(
                          color: selectedItem == null
                              ? hintTextColor
                              : textColor,
                          fontWeight: FontWeight.w500,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onCancelSelection == null)
                  Icon(
                    controller.isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: textColor,
                  ),
                if (onCancelSelection != null)
                  InkWell(
                    onTap: () {
                      if (selectedItem != null) {
                        onCancelSelection?.call();
                      } else {
                        controller.open();
                      }
                    },
                    child: Icon(
                      controller.isOpen
                          ? Icons.keyboard_arrow_up
                          : selectedItem != null
                          ? Icons.close
                          : Icons.keyboard_arrow_down,
                      color: (!controller.isOpen && selectedItem != null)
                          ? Colors.red
                          : Theme.of(context).primaryColorDark,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
