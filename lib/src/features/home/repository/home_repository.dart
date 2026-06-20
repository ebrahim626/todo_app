import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
    int? pageSize,
    int? page
  }) async {
    final offset = DateTime.now().timeZoneOffset; // e.g. Duration(hours: 6) for BD
    return await apiClient.get(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.getAllTasksEndpoint,
      query: {
        if (date != null) 'dueDateFrom': DateFormat("yyyy-MM-dd").format(date), // ✅ full UTC range
        if (date != null) 'dueDateTo': DateFormat("yyyy-MM-dd").format(date),
        'utcOffsetMinutes': offset.inMinutes.toString(), // ✅ "360"
        'History': isHistory,
        'pageSize' : pageSize ?? 1000,
        "page" : page ?? 1,
      },
    );
  }
}
