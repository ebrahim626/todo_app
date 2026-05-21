part of '../api_client.export.dart';

enum APIType { public, private }

class ApiResponse<T> {
  ApiResponse.success(this.data, this.statusCode) : error = null;
  ApiResponse.failure(this.error, this.statusCode) : data = null;
  final T? data;
  final int? statusCode;
  final DioException? error;

  bool get isSuccess => error == null;
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final cacheService = ref.watch(cacheServiceProvider);
  return ApiClient()..init(
    baseUrl: ApiEndpoints.baseUrl,
    cacheService: cacheService,
    refreshTokenUrl: '',
    onTokenRefresh: (json) => json['accessToken'] as String,
  );
});

// final ipLocatorApiClientProvider = Provider<ApiClient>((ref) {
//   final cacheService = ref.watch(cacheServiceProvider);
//   return ApiClient()
//     ..init(baseUrl: ApiEndpoints.ipLocatorBaseUrl, cacheService: cacheService);
// });

class ApiClient {
  ApiClient(); // Removed singleton pattern

  late Dio _dio;
  late String baseUrl;
  late CacheService _cacheService;

  void init({
    required String baseUrl,
    required CacheService cacheService,
    int connectionTimeout = 100000,
    int receiveTimeout = 100000,
    String? refreshTokenUrl,
    String Function(Map<String, dynamic>)? onTokenRefresh,
  }) {
    this.baseUrl = baseUrl;
    _cacheService = cacheService;

    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: connectionTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
      validateStatus: (status) => true,
    );

    _dio = Dio(options)
      ..interceptors.addAll([
        PrettyDioLogger(requestHeader: true, requestBody: true),
        DynamicInterceptor(
          baseUrl: baseUrl,
          cacheService: cacheService,
          refreshTokenUrl: refreshTokenUrl,
          onTokenRefresh: onTokenRefresh,
        ),
      ]);
  }

  /// GET
  Future<ApiResponse<dynamic>> get({
    required APIType apiType,
    required String path,
    TokenType? tokenType,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final options = await _getOptions(
        apiType: apiType,
        extraHeaders: headers,
        tokenType: tokenType,
      );
      final response = await _dio.get(
        path,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
      );
      return ApiResponse.success(response.data, response.statusCode);
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  /// POST
  Future<ApiResponse<dynamic>> post({
    required APIType apiType,
    required String path,
    TokenType? tokenType,
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final options = await _getOptions(
        apiType: apiType,
        extraHeaders: headers,
        tokenType: tokenType,
      );
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
      );
      return ApiResponse.success(response.data, response.statusCode);
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  /// PUT
  Future<ApiResponse<dynamic>> put({
    required APIType apiType,
    required String path,
    TokenType? tokenType,
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final options = await _getOptions(
        apiType: apiType,
        extraHeaders: headers,
        tokenType: tokenType,
      );
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
      );
      return ApiResponse.success(response.data, response.statusCode);
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  /// PATCH
  Future<ApiResponse<dynamic>> patch({
    required APIType apiType,
    required String path,
    TokenType? tokenType,
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final options = await _getOptions(
        apiType: apiType,
        extraHeaders: headers,
        tokenType: tokenType,
      );
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
      );
      return ApiResponse.success(response.data, response.statusCode);
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  /// PATCH
  Future<ApiResponse<dynamic>> patchFormData({
    required APIType apiType,
    required String path,
    Map<String, dynamic>? data,
    Map<String, File?>? image,
    Map<String, List<File>?>? images,
    TokenType? tokenType,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final options = await _getOptions(
        apiType: apiType,
        // extraHeaders: {...?headers, 'Content-Type': 'multipart/form-data'},
        tokenType: tokenType,
      );

      final response = await _dio.patch(
        path,
        data: FormData.fromMap({...(data ?? {})}),
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
      );
      return ApiResponse.success(response.data, response.statusCode);
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  /// DELETE
  Future<ApiResponse<dynamic>> delete({
    required APIType apiType,
    required String path,
    TokenType? tokenType,
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final options = await _getOptions(
        apiType: apiType,
        extraHeaders: headers,
        tokenType: tokenType,
      );
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
      );
      return ApiResponse.success(response.data, response.statusCode);
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  /// Form data (for image upload etc.)
  Future<ApiResponse<dynamic>> postFormData({
    required APIType apiType,
    required String path,
    Map<String, dynamic>? data,
    Map<String, File?>? image,
    Map<String, List<File>?>? images,
    TokenType? tokenType,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final options = await _getOptions(
        apiType: apiType,
        extraHeaders: {...?headers, 'Content-Type': 'multipart/form-data'},
        tokenType: tokenType,
      );

      final response = await _dio.post(
        path,
        data: FormData.fromMap({...(data ?? {})}),
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
      );
      return ApiResponse.success(response.data, response.statusCode);
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  /// S3 file upload
  Future<ApiResponse<dynamic>> fileUploadInS3Bucket({
    required String preAssignedUrl,
    required File file,
  }) async {
    try {
      final response = await _dio.put(
        preAssignedUrl,
        data: file.openRead(),
        options: Options(
          headers: {Headers.contentLengthHeader: await file.length()},
        ),
      );
      return ApiResponse.success(response.data, response.statusCode);
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  Future<Options> _getOptions({
    required APIType apiType,
    TokenType? tokenType,
    Map<String, dynamic>? extraHeaders,
  }) async {
    final baseOptions = switch (apiType) {
      APIType.public => PublicApiOptions().options,
      APIType.private => await ProtectedApiOptions(
        cacheService: _cacheService,
        tokenType: tokenType,
      ).options,
    };

    if (extraHeaders != null) {
      baseOptions.headers?.addAll(extraHeaders);
    }

    return baseOptions;
  }

  ApiResponse<T> _handleDioException<T>(DioException e) {
    // Log.error('DioExceptionType → ${e.type}');
    // Log.error('Error response → ${e.response?.data}');
    final backendMessage =
        e.response?.data['message'] ?? 'Something went wrong';

    return ApiResponse.failure(
      DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        type: e.type,
        error: backendMessage,
      ), e.response?.statusCode ?? 500
    );
  }
}