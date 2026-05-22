import 'package:flutter/material.dart';
import 'package:todo_app/src/core/utils/extensions/context.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String name = 'home';

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Home", style: context.text.titleLarge,));
  }
}
