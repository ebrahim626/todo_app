import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/src/core/network/api_client.export.dart';
import 'package:todo_app/src/features/add_task/model/request/create_task_request_model.dart';

final addTaskRepository = Provider<AddTaskRepository>((ref) {
  return AddTaskRepository(apiClient: ref.read(apiClientProvider));
});

class AddTaskRepository {
  AddTaskRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<ApiResponse<dynamic>> addTask({
    required CreateTaskRequest createTaskModel,
  }) async {
    return await apiClient.post(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.getAllTasksEndpoint,
      data: createTaskModel.toJson(),
    );
  }
}
