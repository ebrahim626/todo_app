import 'dart:developer';
import 'package:app_badger/app_badger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/common/providers/drawer_key_provider.dart';
import 'notification_service.dart';


class FirebaseMessagingService {
  // Private constructor for singleton pattern
  FirebaseMessagingService._internal();

  // Singleton instance
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  // Factory constructor to provide singleton instance
  factory FirebaseMessagingService.instance() => _instance;

  // Reference to local notifications service for displaying notifications
  LocalNotificationsService? _localNotificationsService;
  ProviderContainer? _container; // 👈 add this

  /// Initialize Firebase Messaging and sets up all message listeners
  Future<void> init({
    required LocalNotificationsService localNotificationsService,
    required ProviderContainer container, // 👈 add this
  }) async {
    // Init local notifications service
    _localNotificationsService = localNotificationsService;
    _container = container;

    // Handle FCM token
    _handlePushNotificationsToken();

    // Request user permission for notifications
    _requestPermission();

    // Register handler for background messages (app terminated)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listen for messages when the app is in foreground
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Listen for notification taps when the app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Remove the badge count
    AppBadger.removeBadge();

    // Check for initial message that opened the app from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }
  }

  /// Retrieves and manages the FCM token for push notifications
  Future<void> _handlePushNotificationsToken() async {
    // For iOS, we need to ensure APNS token is ready
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _waitForAPNSToken();
    }

    // Get the FCM token for the device
    final token = await FirebaseMessaging.instance.getToken();
    log('Push notifications token: $token');

    // Listen for token refresh events
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
          log('FCM token refreshed: $fcmToken');
          // TODO: optionally send token to your server for targeting this device
        })
        .onError((error) {
          // Handle errors during token refresh
          log('Error refreshing FCM token: $error');
        });
  }

  /// Wait for APNS token to be available (iOS specific)
  Future<void> _waitForAPNSToken() async {
    try {
      // Check if we're on iOS and try to get APNS token
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        log('APNS Token: $apnsToken');

        // If no APNS token, wait and retry
        if (apnsToken == null) {
          log('APNS token not ready, waiting...');
          await Future.delayed(const Duration(seconds: 2));
          // Retry once
          final retryToken = await FirebaseMessaging.instance.getAPNSToken();
          if (retryToken == null) {
            log('APNS token still not available, proceeding anyway...');
          }
        }
      }
    } catch (e) {
      log('Error checking APNS token: $e');
      // Continue anyway after a delay
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  /// Requests notification permission from the user
  Future<void> _requestPermission() async {
    // Request permission for alerts, badges, and sounds
    final result = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Log the user's permission decision
    log('User granted permission: ${result.authorizationStatus}');
  }

  /// Updates badge count based on message data
  // Future<void> _updateBadgeCount(int badgeCount, String context) async {
  //   try {
  //     bool isBadgeSupported = await FlutterAppBadgeControl.isAppBadgeSupported();
  //     if (!isBadgeSupported) {
  //       log('Badges not supported on this device for $context');
  //       return;
  //     }
  //     await FlutterAppBadgeControl.updateBadgeCount(badgeCount);
  //     log('Badge updated to $badgeCount for $context');
  //   } catch (e) {
  //     log('Error updating badge count for $context: $e');
  //   }
  // }

  /// Handles messages received while the app is in the foreground
  void _onForegroundMessage(RemoteMessage message) async {
    log('Foreground message received: ${message.data.toString()}');

    // ✅ Increment unread count instantly
    _container?.read(unreadCountProvider.notifier).state++;

    //await _updateBadgeCount(30, 'foreground');
    //final messageController = Get.find<MessageController>();
    //await messageController.fetchMessages();
    final notificationData = message.notification;
    if (notificationData != null) {
      // Display a local notification using the service
      _localNotificationsService?.showNotification(
        notificationData.title,
        notificationData.body,
        message.data.toString(),
      );
    }
  }

  /// Handles notification taps when app is opened from the background or terminated state
  void _onMessageOpenedApp(RemoteMessage message) async {
    log('Notification caused the app to open: ${message.data.toString()}');
    // TODO: Add navigation or specific handling based on message data
    //await _updateBadgeCount(10, 'notification tap');
  }
}

/// Background message handler (must be top-level function or static)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Background message received: ${message.data}');
  try {
    // bool isBadgeSupported = await FlutterAppBadgeControl.isAppBadgeSupported();
    // if (!isBadgeSupported) {
    //   log('Badges not supported on this device for background');
    //   return;
    // }
    // final messageController = Get.find<MessageController>();
    // await messageController.fetchMessages();
    //await FlutterAppBadgeControl.updateBadgeCount(20);
    log('Background badge updated to 20');
  } catch (e) {
    log('Error updating badge in background: $e');
  }
}
