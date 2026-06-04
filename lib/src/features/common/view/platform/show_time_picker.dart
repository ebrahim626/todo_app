import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const primaryColor = Color(0xff1FB4C4);
const _primaryLight = Color(0xFF1FB4C4);
const _primaryDark = Color(0xFF4ECFDD); // slightly lighter for dark bg contrast

class PlatformTimePicker {
  static Future<TimeOfDay?> show(
      BuildContext context, {
        TimeOfDay? initialTime,
        String? primaryButtonText,
        String? title,
      }) async {
    final effectiveInitialTime = initialTime ?? TimeOfDay.now();
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return isIOS
        ? await _showCupertinoTimePicker(
      context,
      effectiveInitialTime,
      primaryButtonText,
      title,
    )
        : await _showMaterialTimePicker(
      context,
      effectiveInitialTime,
      primaryButtonText,
      title,
    );
  }

  // ─── iOS / Cupertino ────────────────────────────────────────────────────────

  static Future<TimeOfDay?> _showCupertinoTimePicker(
      BuildContext context,
      TimeOfDay initialTime,
      String? primaryButtonText,
      String? title,
      ) async {
    TimeOfDay selectedTime = initialTime;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? _primaryDark : _primaryLight;

    return showCupertinoModalPopup<TimeOfDay>(
      context: context,
      builder: (ctx) {
        final bg = isDark
            ? const Color(0xFF1C1C1E)
            : CupertinoColors.systemBackground.resolveFrom(ctx);
        final dividerColor =
        isDark ? const Color(0xFF38383A) : const Color(0xFFE0E0E0);

        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: CupertinoColors.systemGrey.resolveFrom(ctx),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (title != null)
                        Text(
                          title,
                          style: TextStyle(
                            color: isDark
                                ? CupertinoColors.white
                                : CupertinoColors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: -0.3,
                          ),
                        ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        onPressed: () => Navigator.pop(ctx, selectedTime),
                        child: Text(
                          primaryButtonText ?? 'Done',
                          style: TextStyle(
                            color: accent,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, thickness: 0.5, color: dividerColor),

                // Picker
                SizedBox(
                  height: 220,
                  child: CupertinoTheme(
                    data: CupertinoThemeData(primaryColor: accent),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: DateTime(
                        2000, 1, 1,
                        initialTime.hour,
                        initialTime.minute,
                      ),
                      use24hFormat:
                      MediaQuery.of(context).alwaysUse24HourFormat,
                      onDateTimeChanged: (dt) {
                        selectedTime =
                            TimeOfDay(hour: dt.hour, minute: dt.minute);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Android / Material ─────────────────────────────────────────────────────

  static Future<TimeOfDay?> _showMaterialTimePicker(
      BuildContext context,
      TimeOfDay initialTime,
      String? primaryButtonText,
      String? title,
      ) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? _primaryDark : _primaryLight;

    final pickerTheme = TimePickerThemeData(
      backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
      hourMinuteShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      dayPeriodShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      hourMinuteTextStyle: const TextStyle(
        fontSize: 52,
        fontWeight: FontWeight.w300,
        letterSpacing: -2,
      ),
      dayPeriodTextStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      helpTextStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: isDark ? Colors.white54 : Colors.black38,
      ),
      // Selected chip background
      hourMinuteColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accent.withValues(alpha: isDark ? 0.25 : 0.12);
        }
        return isDark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.black.withValues(alpha: 0.04);
      }),
      // Hour/minute digit color
      hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accent;
        }
        return isDark ? Colors.white70 : Colors.black87;
      }),
      // Dial
      dialBackgroundColor: isDark
          ? Colors.white.withValues(alpha: 0.06)
          : accent.withValues(alpha: 0.06),
      dialHandColor: accent,
      dialTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return isDark ? Colors.white70 : Colors.black87;
      }),
      // AM/PM
      dayPeriodColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accent.withValues(alpha: isDark ? 0.25 : 0.12);
        }
        return Colors.transparent;
      }),
      dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accent;
        }
        return isDark ? Colors.white54 : Colors.black45;
      }),
      dayPeriodBorderSide: BorderSide(
        color: isDark
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.black.withValues(alpha: 0.1),
      ),
      entryModeIconColor: isDark ? Colors.white38 : Colors.black38,
    );

    return showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: title?.toUpperCase() ?? 'SELECT TIME',
      confirmText: primaryButtonText ?? 'CONFIRM',
      cancelText: 'CANCEL',
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: Theme.of(ctx).colorScheme.copyWith(
              primary: accent,
              onPrimary: Colors.white,
              surface: isDark ? const Color(0xFF1E1E2E) : Colors.white,
            ),
            timePickerTheme: pickerTheme,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: accent,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  fontSize: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          // Wrap in _AnimatedTimePicker to fix missing keyboard→clock animation
          child: _AnimatedTimePicker(child: child!),
        );
      },
    );
  }
}

/// Adds a symmetric fade+slide animation whenever the time picker switches
/// between clock and keyboard entry modes (both directions).
class _AnimatedTimePicker extends StatefulWidget {
  const _AnimatedTimePicker({required this.child});
  final Widget child;

  @override
  State<_AnimatedTimePicker> createState() => _AnimatedTimePickerState();
}

class _AnimatedTimePickerState extends State<_AnimatedTimePicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  Widget? _currentChild;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _currentChild = widget.child;
    _controller.forward();
  }

  @override
  void didUpdateWidget(_AnimatedTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Flutter rebuilds this widget when the picker switches modes.
    // We detect a real mode change by checking widget identity.
    if (widget.child.runtimeType != oldWidget.child.runtimeType ||
        widget.child.key != oldWidget.child.key) {
      _controller.reverse().then((_) {
        if (mounted) {
          setState(() => _currentChild = widget.child);
          _controller.forward();
        }
      });
    } else {
      // Same mode, just update child without re-animating
      _currentChild = widget.child;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: _currentChild,
      ),
    );
  }
}