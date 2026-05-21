import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import '../config/constant/app_constants.dart';

final cacheServiceProvider = Provider<CacheService>((ref) {
  final box = Hive.box(AppConstants.hiveKey);
  final cacheService = CacheService(box);
  cacheService.init();
  return cacheService;
});

final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final cacheService = ref.watch(cacheServiceProvider);
  return await cacheService.isLoggedIn;
});

class CacheService {
  CacheService(this._box);

  final Box<dynamic> _box;

  // Initialize favorites box
  Future<void> init() async {
    log('Initializing CacheService and opening favorites box');
  }

  static const _isLoggedIn = 'isLoggedIn';
  static const _bearerToken = 'bearerToken';
  static const _refreshToken = 'refreshToken';

  Future<String?> get bearerToken async => read<String>(_bearerToken);
  Future<void> setBearerToken(String value) async => save(_bearerToken, value);


  Future<String?> get refreshToken async => read<String>(_refreshToken);
  Future<void> setRefreshToken(String value) async => save(_refreshToken, value);

  Future<bool> get isLoggedIn async => await read<bool>(_isLoggedIn) ?? false;
  Future<void> setLoggedIn(bool value) async => save(_isLoggedIn, value);

  Future<void> delete(String key) async {
    try {
      await _box.delete(key);
    } catch (e) {
      // Optionally log
    }
  }

  Future<void> save(String key, dynamic value) async {
    try {
      await _box.put(key, value);
    } catch (e) {
      // Optionally log
    }
  }

  Future<T?> read<T>(String key) async {
    try {
      final value = _box.get(key);
      if (value is T) return value;
    } catch (e) {
      // Optionally log
    }
    return null;
  }

  Future<void> clearAuthTokens() async {
    await delete(_isLoggedIn);
    await delete(_bearerToken);
    await delete(_refreshToken);
  }
}