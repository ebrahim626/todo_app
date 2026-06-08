import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/src/core/utils/extensions/gap.dart';
import 'package:todo_app/src/core/utils/theme/theme.dart';
import 'package:todo_app/src/features/common/view/divider/app_divider.dart';

import '../../controller/home_controller.dart';

class HomeCalendar extends StatefulWidget {
  const HomeCalendar({super.key, required this.notifier});

  final HomeController notifier;

  @override
  State<HomeCalendar> createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  Map<DateTime, List<Color>> _buildTaskColorMap() {
    final Map<DateTime, List<Color>> colorMap = {};

    for (final task in widget.notifier.allTodoTasks ?? []) {
      if (task.dueDate == null) continue;

      final key = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
      );

      final color = widget.notifier.getStatusColor(task.taskStatus ?? 1);

      if (colorMap.containsKey(key)) {
        colorMap[key]!.add(color);
      } else {
        colorMap[key] = [color];
      }
    }

    return colorMap;
  }

// Remove the hardcoded _taskColorMap field entirely

  List<Color> _getColorsForDay(DateTime day) {
    final map = _buildTaskColorMap();         // built fresh from live data
    final key = DateTime(day.year, day.month, day.day);
    return map[key] ?? [];
  }

  String _monthName(int month) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    return months[month - 1];
  }

  void _showMonthYearPicker() async {
    int selectedYear = _focusedDay.year;
    int selectedMonth = _focusedDay.month;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Select Month & Year'),
              content: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Year selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => setDialogState(() => selectedYear--),
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Text(
                          '$selectedYear',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => setDialogState(() => selectedYear++),
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Month grid
                    GridView.builder(
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
                          onTap: () => setDialogState(() => selectedMonth = month),
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
                                _monthName(month),
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
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      daysOfWeekHeight: 26,

      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        widget.notifier.getTasks(date: focusedDay);
        widget.notifier.selectedDate = selectedDay;

      },
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
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronVisible: false,  // 👈 Hidden — using custom header
        rightChevronVisible: false,
        headerPadding: EdgeInsets.zero,
      ),
      calendarBuilders: CalendarBuilders(

        // 🗓 Custom header with dividers + clickable title
        headerTitleBuilder: (context, day) {
          return Column(
            children: [
              // const AppDivider(height: 1,thickness: 1,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => setState(() {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month - 1,
                      );
                    }),
                    icon: const Icon(Icons.chevron_left,size: 30),
                  ),

                  // 👆 Tap to pick month/year
                  GestureDetector(
                    onTap: _showMonthYearPicker,
                    child: Row(
                      children: [
                        Text(
                          '${_monthName(day.month)}  ${day.year}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () => setState(() {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month + 1,
                      );
                    }),
                    icon: const Icon(Icons.chevron_right,size: 30),
                  ),
                ],
              ),
              5.ph,
              const AppDivider(height: 1,thickness: 1,),
              16.ph,
            ],
          );
        },

        // 🔵 Multi dot day builder
        defaultBuilder: (context, day, focusedDay) {
          final colors = _getColorsForDay(day);
          if (colors.isEmpty) return null;
          return _buildMultiDotDay(day.day.toString(), colors);
        },
      ),
    );
  }

  Widget _buildMultiDotDay(String day, List<Color> colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          day,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: colors.take(4).map((color) => Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          )).toList(),
        ),
      ],
    );
  }
}

