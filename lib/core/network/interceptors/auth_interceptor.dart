import 'package:dio/dio.dart';
import 'package:esoi/common/data/app_data.dart';
import 'package:esoi/config/app_config.dart';
import 'package:esoi/locator.dart';
import 'package:esoi/app/services/authentication_service/authentication_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await AppData.getAccessToken();
    final config = locator<AppConfig>();
    
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    if (config.api.apiKey != null) {
      options.headers['x-api-key'] = config.api.apiKey;
    }
    
    // Add other common headers like x-locale if needed later
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Notify the authentication layer to handle logout and navigation
      locator<AuthenticationService>().handleUnauthorized();
    }
    return super.onError(err, handler);
  }
}
