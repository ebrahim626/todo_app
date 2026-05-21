import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../database/hive_storage.dart';
part 'dio/api_client.dart';
part 'dio/api_endpoints.dart';
part 'dio/api_options.dart';
part 'dio/interceptor.dart';
