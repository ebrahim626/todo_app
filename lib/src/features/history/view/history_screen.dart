import 'package:flutter/material.dart';
import 'package:todo_app/src/core/utils/extensions/context.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const String name = 'history-screen';

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("History", style: context.text.titleLarge,));
  }
}
