part of '../api_client.export.dart';

class ApiEndpoints {

  ///base url
  static const String baseUrl = 'https://moderntodoappapi-production.up.railway.app';

  static const String googleSignInEndpoint = '/api/user/google-login';
  static const String getAllTasksEndpoint = '/api/todo';
  static const String getNotificationsEndpoint = '/api/notifications';
  static const String markAsReadEndpoint = '/api/notifications/mark-as-read';
  static String editTaskEndPoint({required int slotId}) =>
      "$getAllTasksEndpoint/$slotId";

}
