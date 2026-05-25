import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/extensions/context.dart';
import '../../../../core/utils/extensions/gap.dart';
import '../../../../core/utils/theme/theme.dart';

class CustomTextFieldWithLabel extends StatefulWidget {
  final String? label;
  final TextEditingController? controller;
  final String? hintText;
  final String? fieldName;
  final bool? readOnly;
  final bool? obscureText;
  final int? maxLines;
  final String? isRequired;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? leading;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final Color? isRequiredColor;
  final TextStyle? labelStyle;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final bool? enabled;
  final bool? optional;
  final TextInputAction? textInputAction;
  final bool isFillColor;
  final Color? fillColor;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final TextStyle? hintStyle;
  final Function(String)? onFieldSubmitted;
  final double? height;
  final Color? textColor;
  final TextStyle? style;

  const CustomTextFieldWithLabel({
    super.key,
    this.label,
    this.hintText,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.isRequired,
    this.readOnly,
    this.onTap,
    this.trailing,
    this.leading,
    this.controller,
    this.validator,
    this.obscureText,
    this.autofillHints,
    this.maxLines,
    this.isRequiredColor,
    this.labelStyle,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
    this.enabled,
    this.optional,
    this.isFillColor = true,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.hintStyle,
    this.fieldName,
    this.onFieldSubmitted,
    this.height,
    this.textColor,
    this.style,
    this.fillColor,
  });
  @override
  State<CustomTextFieldWithLabel> createState() =>
      _CustomTextFieldWithLabelState();
}

class _CustomTextFieldWithLabelState extends State<CustomTextFieldWithLabel> {
  late bool _obscureText;
  @override
  void initState() {
    super.initState();
    _obscureText =
        widget.obscureText ??
        widget.keyboardType == TextInputType.visiblePassword;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isPasswordField =
        widget.keyboardType == TextInputType.visiblePassword;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null && widget.label!.isNotEmpty)
          Row(
            children: [
              Text(
                widget.label!,
                style:
                    widget.labelStyle ??
                    context.text.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              if (widget.optional == true)
                Text(
                  ' (Optional)',
                  style: context.text.titleSmall!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: widget.isRequiredColor ?? Colors.blueGrey,
                  ),
                ),
              if (widget.isRequired != null)
                Text(
                  widget.isRequired!,
                  style: context.text.titleSmall!.copyWith(
                    color: widget.isRequiredColor ?? Colors.red,
                  ),
                ),
            ],
          ),

        if (widget.label != null && widget.label!.isNotEmpty) 8.ph,

        SizedBox(
          // height: widget.maxLines != null ? null : 48.h,
          height: widget.height,
          child: TextFormField(
            onTap: widget.onTap,
            textCapitalization: widget.textCapitalization,
            focusNode: widget.focusNode,
            onChanged: widget.onChanged,
            inputFormatters: widget.inputFormatters,
            controller: widget.controller,
            maxLines: widget.maxLines ?? 1,
            style:
                widget.style ??
                context.text.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: widget.textColor,
                ),
            maxLength: widget.maxLength,
            obscureText: _obscureText,
            enabled: widget.enabled,
            onFieldSubmitted: widget.onFieldSubmitted,
            decoration: InputDecoration(
              errorStyle: const TextStyle(color: Colors.red),
              hintText: widget.hintText,
              hintStyle:
                  widget.hintStyle ??
                  context.text.titleSmall!.copyWith(
                    color: hintTextColor,
                    fontWeight: FontWeight.w500,
                  ),
              isDense: true,
              prefixIcon: widget.leading,
              suffixIcon:
                  widget.trailing ??
                  (isPasswordField
                      ? IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.remove_red_eye_outlined
                                : Icons.remove_red_eye_rounded,
                            color: const Color(0xFF272B35),
                          ),
                          onPressed: _toggleVisibility,
                        )
                      : null),
              contentPadding: EdgeInsets.symmetric(
                vertical: 13.h,
                horizontal: 8.w,
              ),
              fillColor: widget.isFillColor
                  ? widget.fillColor ??  Colors.white
                  : Colors.transparent,
              filled: widget.isFillColor,
              // Add these border properties:
              border: OutlineInputBorder(
                borderSide: BorderSide(color: stockColor, width: 1.0),
                borderRadius: BorderRadius.circular(8.0), // Adjust as needed
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            readOnly: widget.readOnly ?? false,
            textInputAction: widget.textInputAction ?? TextInputAction.next,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            autofillHints: widget.autofillHints,
            validator:
                widget.validator ??
                (v) {
                  // Skip validation if field is not marked with '*' (not required)
                  if (widget.isRequired != '*') {
                    return null;
                  }

                  // Only validate required fields
                  if (v == null || v.isEmpty || v.trim().isEmpty) {
                    return '${widget.label ?? widget.fieldName ?? 'This field'} is required';
                  }

                  return null;
                },
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          ),
        ),
      ],
    );
  }
}
