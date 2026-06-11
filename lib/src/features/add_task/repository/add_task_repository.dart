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

  Future<ApiResponse<dynamic>> updateTask({
    required CreateTaskRequest createTaskModel,
    required int taskId,
  }) async {
    return await apiClient.patch(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.editTaskEndPoint(slotId: taskId),
      data: createTaskModel.toJson(),
    );
  }

  Future<ApiResponse<dynamic>> deleteTask({
    required int taskId,
  }) async {
    return await apiClient.delete(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.editTaskEndPoint(slotId: taskId),
    );
  }

}
