import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/src/core/network/api_client.export.dart';
import 'package:todo_app/src/core/service/local_time_formatter.dart';

final homeRepository = Provider<HomeRepository>((ref) {
  return HomeRepository(apiClient: ref.read(apiClientProvider));
});

class HomeRepository {
  HomeRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<ApiResponse<dynamic>> getAllTasks({
    DateTime? date,
    bool isHistory = false,
  }) async {
    final range = date != null ? LocalTimeFormatter.dayRangeUtc(date) : null;
    return await apiClient.get(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.getAllTasksEndpoint,
      query: {
        if (range != null) 'DueDateFrom': range.from, // ✅ full UTC range
        if (range != null) 'DueDateTo': range.to,
        'History': isHistory,
        'pageSize' : 100
      },
    );
  }
}
