import 'package:dio/dio.dart';
import 'package:esoi/core/network/api_client.dart';
import 'package:esoi/locator.dart';

class AuthApi {
  final ApiClient _apiClient = locator<ApiClient>();

  Future<Response> login(Map<String, dynamic> data) {
    return _apiClient.dio.post('login', data: data);
  }
  
  Future<Response> registerStep1(Map<String, dynamic> data) {
    return _apiClient.dio.post('register/step/1', data: data);
  }

  Future<Response> verifyCode(Map<String, dynamic> data) {
    return _apiClient.dio.post('register/step/2', data: data);
  }

  Future<Response> registerStep3(Map<String, dynamic> data) {
    return _apiClient.dio.post('register/step/3', data: data);
  }

  Future<Response> forgetPassword(Map<String, dynamic> data) {
    return _apiClient.dio.post('forget-password', data: data);
  }
  
  Future<Response> googleCallback(Map<String, dynamic> data) {
    return _apiClient.dio.post('google/callback', data: data);
  }
  
  Future<Response> facebookCallback(Map<String, dynamic> data) {
    return _apiClient.dio.post('facebook/callback', data: data);
  }
}
