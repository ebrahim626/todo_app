import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/src/features/add_task/view/add_task_screen.dart';
import 'package:todo_app/src/features/auth/get_started/view/get_started_screen.dart';
import 'package:todo_app/src/features/auth/google_login/view/google_login_screen.dart';
import 'package:todo_app/src/features/history/view/history_screen.dart';
import 'package:todo_app/src/features/home/view/home_screen.dart';

import '../../features/home/get_task_model/response/get_task_model.dart';
import '../../features/splash_screen/view/splash_screen.dart';
import '../../shared/bottom_nev_bar/bottom_nev_bar.dart';
import 'app_routers.dart';

part 'go_router.dart';