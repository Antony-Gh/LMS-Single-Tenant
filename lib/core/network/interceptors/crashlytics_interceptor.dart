import 'package:dio/dio.dart';
import '../../error/crash_handler.dart';

class CrashlyticsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['start_time'] = DateTime.now().millisecondsSinceEpoch;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['start_time'] as int?;
    final duration = startTime != null ? DateTime.now().millisecondsSinceEpoch - startTime : 0;
    
    CrashHandler.instance.logBreadcrumb(
      'API [${response.requestOptions.method}] ${response.requestOptions.uri.path} '
      '-> ${response.statusCode} (${duration}ms)'
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.extra['start_time'] as int?;
    final duration = startTime != null ? DateTime.now().millisecondsSinceEpoch - startTime : 0;
    
    CrashHandler.instance.logBreadcrumb(
      'API ERROR [${err.requestOptions.method}] ${err.requestOptions.uri.path} '
      '-> ${err.response?.statusCode ?? 'No Response'} (${duration}ms): ${err.message}'
    );
    
    // Only record error if it is a 5xx or unhandled exception.
    // 4xx are usually user errors (wrong password, etc) and shouldn't trigger a full crash report.
    if (err.response == null || (err.response!.statusCode != null && err.response!.statusCode! >= 500)) {
      CrashHandler.instance.recordError(err, err.stackTrace, reason: 'Dio Exception on ${err.requestOptions.uri.path}');
    }
    
    super.onError(err, handler);
  }
}
