import 'package:dio/dio.dart';
import 'package:collection_agent/core/network/api_endpoints.dart';
import 'package:collection_agent/core/storage/secure_storage.dart';
import 'package:collection_agent/core/utils/logger.dart';

/// Custom API Exception
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic data;

  const ApiException({
    required this.statusCode,
    required this.message,
    this.data,
  });

  @override
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';
}

/// Central Network Client for Titanstay Collector API built with Dio
class ApiClient {
  ApiClient._() {
    _initDio();
  }

  static final ApiClient instance = ApiClient._();

  late final Dio _dio;
  String? _tenantId = '0eb298b6-0e52-434c-878e-b369839e9720';

  String get baseUrl => _dio.options.baseUrl;
  String? get tenantId => _tenantId;

  /// Global storage keys
  static const String keyToken = 'jwt_token';
  static const String keyTenantId = 'tenant_id';
  static const String keyCollectorProfile = 'collector_profile';

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.defaultBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
        responseType: ResponseType.json,
        headers: const {
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptor for dynamic auth token injection, tenant routing, and error mapping
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          // 1. Inject Tenant ID header
          final storedTenantId = await SecureStorage.instance.read(keyTenantId);
          final activeTenantId = storedTenantId ?? _tenantId;
          if (activeTenantId != null && activeTenantId.isNotEmpty) {
            options.headers['tenant_id'] = activeTenantId;
          }

          // 2. Inject JWT Token if not explicitly bypassed
          final requiresAuth = options.extra['requiresAuth'] as bool? ?? true;
          if (requiresAuth) {
            final token = await SecureStorage.instance.read(keyToken);
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          AppLogger.info('Dio [${options.method}] -> ${options.uri}');
          if (options.data != null) {
            AppLogger.info('Payload: ${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.info('Dio [${response.statusCode}] <- ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          AppLogger.error('Dio Error [${error.response?.statusCode}]: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  void setBaseUrl(String url) {
    final cleanUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    _dio.options.baseUrl = cleanUrl;
  }

  void setTenantId(String tenantId) {
    _tenantId = tenantId;
  }

  /// Performs GET request via Dio
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        statusCode: 0,
        message: 'Network connection failed: $e',
      );
    }
  }

  /// Performs POST request via Dio
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        statusCode: 0,
        message: 'Network connection failed: $e',
      );
    }
  }

  /// Performs PUT request via Dio
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: body,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        statusCode: 0,
        message: 'Network connection failed: $e',
      );
    }
  }

  Map<String, dynamic> _processResponse(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data;
    }
    return {'data': data};
  }

  ApiException _handleDioError(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode ?? 0;
    final data = response?.data;

    String errorMsg = 'Network connection failed. Please check backend server.';

    if (data is Map<String, dynamic>) {
      errorMsg = (data['msg'] ?? data['message'] ?? errorMsg).toString();
    } else if (response?.statusMessage != null && response!.statusMessage!.isNotEmpty) {
      errorMsg = response.statusMessage!;
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      errorMsg = 'Connection timed out. Please verify backend is running.';
    } else if (error.type == DioExceptionType.connectionError) {
      errorMsg = 'Could not connect to backend server at $baseUrl';
    }

    return ApiException(
      statusCode: statusCode,
      message: errorMsg,
      data: data,
    );
  }
}
