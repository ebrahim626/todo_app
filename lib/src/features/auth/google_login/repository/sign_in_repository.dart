import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.export.dart';
import '../model/request/sign_in_request.dart';


final signInRepository = Provider<SignInRepository>((ref) {
  return SignInRepository(apiClient: ref.watch(apiClientProvider));
});

class SignInRepository {
  final ApiClient apiClient;

  SignInRepository({required this.apiClient});

  Future<ApiResponse<dynamic>> sign(SignInRequest signInRequest) async {
    return await apiClient.post(
      apiType: APIType.public,
      path: ApiEndpoints.googleSignInEndpoint,
      data: signInRequest.toJson(),
    );
  }
}