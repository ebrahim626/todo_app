import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/src/core/network/api_client.export.dart';

final profileRepository = Provider<ProfileRepository>((ref) {
  return ProfileRepository(apiClient: ref.read(apiClientProvider));
});

class ProfileRepository {
  ProfileRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<ApiResponse<dynamic>> getProfile() async {
    return await apiClient.get(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.getProfileEndpoint,
    );
  }
}