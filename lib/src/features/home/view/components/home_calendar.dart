import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/src/core/utils/extensions/gap.dart';
import 'package:todo_app/src/core/utils/theme/theme.dart';
import 'package:todo_app/src/features/common/view/divider/app_divider.dart';
import '../../controller/home_controller.dart';

class HomeCalendar extends StatefulWidget {
  const HomeCalendar({super.key, required this.notifier, this.selectedDay});

  final HomeController notifier;
  final DateTime? selectedDay;

  @override
  State<HomeCalendar> createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  DateTime _focusedDay = DateTime.now();

  HomeController get _c => widget.notifier;

  // ─── Helpers ────────────────────────────────────────────────────────────────
  static String _monthName(int month) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    return months[month - 1];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
    _c.getTasks(date: focusedDay);
    _c.selectedDate = selectedDay;
  }

  void _previousMonth() => setState(() {
    _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
  });

  void _nextMonth() => setState(() {
    _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
  });

  // ─── Month/Year picker ───────────────────────────────────────────────────────
  Future<void> _showMonthYearPicker() async {
    int selectedYear = _focusedDay.year;
    int selectedMonth = _focusedDay.month;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Select Month & Year'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _YearSelector(
                  year: selectedYear,
                  onDecrement: () => setDialogState(() => selectedYear--),
                  onIncrement: () => setDialogState(() => selectedYear++),
                ),
                const SizedBox(height: 12),
                _MonthGrid(
                  selectedMonth: selectedMonth,
                  monthName: _monthName,
                  onMonthTap: (m) => setDialogState(() => selectedMonth = m),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(selectedYear, selectedMonth);
                });
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      daysOfWeekHeight: 26,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),
      onDaySelected: _onDaySelected,
      calendarFormat: CalendarFormat.month,
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        todayTextStyle: TextStyle(color: textColor),
        todayDecoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: primaryColor,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        selectedDecoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        defaultTextStyle: const TextStyle(color: Colors.black),
        weekendTextStyle: const TextStyle(color: Colors.black54),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronVisible: false,
        rightChevronVisible: false,
        headerPadding: EdgeInsets.zero,
      ),
      calendarBuilders: CalendarBuilders(
        headerTitleBuilder: (context, day) => _CalendarHeader(
          day: day,
          monthName: _monthName,
          onPrevious: _previousMonth,
          onNext: _nextMonth,
          onTitleTap: _showMonthYearPicker,
        ),
        defaultBuilder: (context, day, _) {
          final colors = _c.getColorsForDay(day);
          if (colors.isEmpty) return null;
          return _DayWithDots(day: day.day, colors: colors);
        },
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.day,
    required this.monthName,
    required this.onPrevious,
    required this.onNext,
    required this.onTitleTap,
  });

  final DateTime day;
  final String Function(int) monthName;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onTitleTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: onPrevious,
              icon: const Icon(Icons.chevron_left, size: 30),
            ),
            GestureDetector(
              onTap: onTitleTap,
              child: Text(
                '${monthName(day.month)}  ${day.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            IconButton(
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right, size: 30),
            ),
          ],
        ),
        5.ph,
        const AppDivider(height: 1, thickness: 1),
        16.ph,
      ],
    );
  }
}

class _DayWithDots extends StatelessWidget {
  const _DayWithDots({required this.day, required this.colors});

  final int day;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$day',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: colors
              .take(4)
              .map(
                (color) => Container(
              width: 5,
              height: 5,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          )
              .toList(),
        ),
      ],
    );
  }
}

class _YearSelector extends StatelessWidget {
  const _YearSelector({
    required this.year,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int year;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onDecrement,
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          '$year',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: onIncrement,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.selectedMonth,
    required this.monthName,
    required this.onMonthTap,
  });

  final int selectedMonth;
  final String Function(int) monthName;
  final void Function(int) onMonthTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.5,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        final month = index + 1;
        final isSelected = month == selectedMonth;
        return GestureDetector(
          onTap: () => onMonthTap(month),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? primaryColor : Colors.grey.shade300,
              ),
            ),
            child: Center(
              child: Text(
                monthName(month),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}