import 'package:dio/dio.dart';
import 'package:esoi/core/network/api_client.dart';
import 'package:esoi/locator.dart';

class CourseApi {
  final ApiClient _apiClient = locator<ApiClient>();

  Future<Response> getCourses(Map<String, dynamic> queryParameters) {
    return _apiClient.dio.get('courses', queryParameters: queryParameters);
  }

  Future<Response> getBundles(Map<String, dynamic> queryParameters) {
    return _apiClient.dio.get('bundles', queryParameters: queryParameters);
  }

  Future<Response> getCourseOverview(int id) {
    return _apiClient.dio.get('courses/$id');
  }
  
  Future<Response> getBundleOverview(int id) {
    return _apiClient.dio.get('bundles/$id');
  }

  Future<Response> getBundleWebinars(int bundleId) {
    return _apiClient.dio.get('bundles/$bundleId/webinars');
  }

  Future<Response> getBundleCourses(int bundleId) {
    return _apiClient.dio.get('bundles/$bundleId/courses');
  }

  Future<Response> getReasons() {
    return _apiClient.dio.get('reasons');
  }

  Future<Response> getNotices(int id) {
    return _apiClient.dio.get('courses/$id/notices');
  }

  Future<Response> reportCourse(int id, Map<String, dynamic> data) {
    return _apiClient.dio.post('courses/$id/report', data: data);
  }

  Future<Response> toggle(int id, Map<String, dynamic> data) {
    return _apiClient.dio.post('courses/$id/toggle', data: data);
  }

  Future<Response> addFavorite(int id, Map<String, dynamic> data) {
    return _apiClient.dio.post('courses/$id/favorite/toggle', data: data);
  }

  Future<Response> getPurchases() {
    return _apiClient.dio.get('panel/webinars/purchases');
  }

  Future<Response> getContent(int id) {
    return _apiClient.dio.get('courses/$id/content');
  }

  Future<Response> getSingleContent(String url) {
    // If the url is a full url, dio handles it correctly if it contains http
    return _apiClient.dio.get(url);
  }
}
