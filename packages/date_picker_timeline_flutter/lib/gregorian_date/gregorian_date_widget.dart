/// ***
/// This class consists of the DateWidget that is used in the ListView.builder
///
/// Author: Vivek Kaushik <me@vivekkasuhik.com>
/// github: https://github.com/iamvivekkaushik/
/// ***

import 'package:date_picker_timeline/gestures/tap.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GregorianDateWidget extends StatelessWidget {
  final double? width;
  final DateTime date;
  final TextStyle? monthTextStyle, dayTextStyle, dateTextStyle;
  final Color selectionColor;
  final DateSelectionCallback? onDateSelected;
  final String? locale;
  final num? indicatorCount; // New property for the indicator count

  const GregorianDateWidget({
    Key? key,
    required this.date,
    required this.monthTextStyle,
    required this.dayTextStyle,
    required this.dateTextStyle,
    required this.selectionColor,
    this.width,
    this.onDateSelected,
    this.locale,
    this.indicatorCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Stack(
        children: [
          Container(
            width: width,
            margin: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              //color: selectionColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                      DateFormat("MMM", locale)
                          .format(date)
                          .toUpperCase(), // Month
                      style: monthTextStyle),
                  // Text(date.day.toString(), // Date
                  //     style: dateTextStyle),
                  Container(
                    width: 50, // or use padding for dynamic sizing
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selectionColor, // Background color
                      // Optional: add border
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: dateTextStyle,
                      ),
                    ),
                  ),
                  Text(
                      DateFormat("E", locale)
                          .format(date)
                          .toUpperCase(), // WeekDay
                      style: dayTextStyle)
                ],
              ),
            ),
          ),
          if (indicatorCount != null && indicatorCount! > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectionColor, // Indicator color
                ),
                child: Center(
                  child: Text(
                    "$indicatorCount",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
      onTap: () {
        onDateSelected?.call(this.date);
      },
    );
  }
}
