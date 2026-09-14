import 'package:dio/dio.dart';
import 'package:esoi/config/app_config.dart';
import 'package:esoi/locator.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/crashlytics_interceptor.dart';

class ApiClient {
  late Dio _dio;

  Dio get dio => _dio;

  ApiClient() {
    final config = locator<AppConfig>();
    _dio = Dio(BaseOptions(
      baseUrl: config.api.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(CrashlyticsInterceptor());
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }
}
