part of '../api_client.export.dart';

class DynamicInterceptor extends Interceptor {
  DynamicInterceptor({
    required this.baseUrl,
    required this.cacheService,
    this.refreshTokenUrl,
    this.onTokenRefresh,
  });

  final String baseUrl;
  final CacheService cacheService;
  final String? refreshTokenUrl;
  final String Function(Map<String, dynamic>)? onTokenRefresh;

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    try {
      final token = await cacheService.bearerToken;

      if (token != null && options.path.contains(baseUrl)) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      handler.next(options); // Proceed with the request
    } catch (e) {
      // If any error occurs, proceed anyway
      handler.next(options);
    }
  }

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    if (_shouldAttemptRefresh(err)) {
      try {
        final newToken = await _refreshToken();

        if (newToken != null) {
          // Save new token using CacheService
          await cacheService.setBearerToken(newToken);

          // Retry the original request with the new token
          final newRequest = await _retryRequest(err.requestOptions, newToken);
          return handler.resolve(newRequest);
        }
      } catch (e) {
        // If token refresh or retry fails, continue with the original error
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  Future<Response<dynamic>> _retryRequest(
      RequestOptions requestOptions,
      String newToken,
      ) {
    final options = Options(
      method: requestOptions.method,
      headers: {...requestOptions.headers, 'Authorization': 'Bearer $newToken'},
    );

    return Dio().request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<String?> _refreshToken() async {
    if (refreshTokenUrl == null) return null;

    try {
      final refreshToken = await cacheService.refreshToken;
      if (refreshToken == null) return null;

      final response = await Dio().post(
        refreshTokenUrl!,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final newToken = onTokenRefresh?.call(
          response.data as Map<String, dynamic>,
        );
        return newToken;
      }
    } catch (e) {
      // Optionally log or handle the error
      return null;
    }

    return null;
  }

  bool _shouldAttemptRefresh(DioException err) {
    return err.response?.statusCode == 401;
  }
}