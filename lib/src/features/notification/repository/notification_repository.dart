import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/src/core/network/api_client.export.dart';
import 'package:todo_app/src/core/service/local_time_formatter.dart';

final notificationRepository = Provider<NotificationRepository>((ref) {
  return NotificationRepository(apiClient: ref.read(apiClientProvider));
});

class NotificationRepository {
  NotificationRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<ApiResponse<dynamic>> getNotifications({required int pageKey, int? pageSize}) async {
    return await apiClient.get(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.getNotificationsEndpoint,
      query: {
        "pageNumber" : pageKey,
        "pageSize" : pageSize ?? 15,

      }
    );
  }
}
