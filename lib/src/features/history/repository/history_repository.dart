import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/src/core/network/api_client.export.dart';
import 'package:todo_app/src/core/service/local_time_formatter.dart';

final historyRepository = Provider<HistoryRepository>((ref) {
  return HistoryRepository(apiClient: ref.read(apiClientProvider));
});

class HistoryRepository {
  HistoryRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<ApiResponse<dynamic>> getHistoryTasks({
    required int pageSize,
    required int page
  }) async {
    final offset = DateTime.now().timeZoneOffset; // e.g. Duration(hours: 6) for BD
    return await apiClient.get(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.getAllTasksEndpoint,
      query: {
        'History': true,
        'pageSize' : pageSize,
        "PageNumber" : page,
      },
    );
  }
}
