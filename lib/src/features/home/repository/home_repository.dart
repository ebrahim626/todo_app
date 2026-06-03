import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/src/core/network/api_client.export.dart';

final homeRepository = Provider<HomeRepository>((ref) {
  return HomeRepository(apiClient: ref.read(apiClientProvider));
});

class HomeRepository {
  HomeRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<ApiResponse<dynamic>> getAllTasks() async {
    return await apiClient.get(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.getAllTasksEndpoint,
    );
  }

}