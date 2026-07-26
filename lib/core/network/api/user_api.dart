import 'dart:io';
import 'package:dio/dio.dart';
import 'package:esoi/core/network/api_client.dart';
import 'package:esoi/locator.dart';

class UserApi {
  final ApiClient _apiClient = locator<ApiClient>();

  Future<Response> getPurchaseCourse() {
    return _apiClient.dio.get('panel/webinars/purchases');
  }

  Future<Response> getAllNotification() {
    return _apiClient.dio.get('panel/notifications');
  }

  Future<Response> getFavorites() {
    return _apiClient.dio.get('panel/favorites');
  }

  Future<Response> getLoginHistory() {
    return _apiClient.dio.get('panel/users/login-history');
  }

  Future<Response> deleteFavorite(int id) {
    return _apiClient.dio.delete('panel/favorites/$id');
  }

  Future<Response> deleteAccount() {
    return _apiClient.dio.post('panel/users/delete-account');
  }
  
  Future<Response> registerBadge() {
    return _apiClient.dio.post('panel/users/register-badge');
  }
  
  Future<Response> getCsrfToken() {
    return _apiClient.dio.get('panel/csrf-token');
  }

  Future<Response> getTeacherClasses() {
    return _apiClient.dio.get('panel/classes');
  }

  Future<Response> getProfile() {
    return _apiClient.dio.get('panel/profile');
  }

  Future<Response> getDashboardData() {
    return _apiClient.dio.get('panel');
  }

  Future<Response> getRewardPointsData() {
    return _apiClient.dio.get('panel/rewards');
  }

  Future<Response> seenNotification(int id) {
    return _apiClient.dio.post('panel/notifications/$id/seen');
  }

  Future<Response> storeReview(Map<String, dynamic> data) {
    return _apiClient.dio.post('panel/reviews/store', data: data);
  }

  Future<Response> updateInfo(Map<String, dynamic> data) {
    return _apiClient.dio.post('panel/profile/setting', data: data);
  }

  Future<Response> updatePassword(Map<String, dynamic> data) {
    return _apiClient.dio.post('panel/profile/setting/password', data: data);
  }

  Future<Response> sendFirebaseToken(Map<String, dynamic> data) {
    return _apiClient.dio.post('device-tokens', data: data);
  }

  Future<Response> updateImage(FormData data) {
    return _apiClient.dio.post('panel/profile/setting/images', data: data);
  }
}
