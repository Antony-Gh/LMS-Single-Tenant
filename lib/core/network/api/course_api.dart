import 'package:dio/dio.dart';
import 'package:esoi/core/network/api_client.dart';
import 'package:esoi/locator.dart';

class CourseApi {
  final ApiClient _apiClient = locator<ApiClient>();

  Future<Response> getAll(bool isBundle, Map<String, dynamic> queryParameters) {
    String path = isBundle ? 'bundles' : 'courses';
    return _apiClient.dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> getOverviewCourseData(int id, bool isBundle, bool isPrivate) {
    String path = isPrivate ? 'panel/webinars/$id' : isBundle ? 'panel/bundles/$id' : 'panel/webinars/$id';
    return _apiClient.dio.get(path);
  }

  Future<Response> getSingleCourseData(int id, bool isBundle) {
    String path = isBundle ? 'bundles/$id' : 'courses/$id';
    return _apiClient.dio.get(path);
  }

  Future<Response> featuredCourse(Map<String, dynamic> queryParameters) {
    return _apiClient.dio.get('courses/reports/featured', queryParameters: queryParameters);
  }

  Future<Response> getBundleWebinars(int bundleId) {
    return _apiClient.dio.get('bundles/$bundleId/webinars');
  }

  Future<Response> bundleCourses(int bundleId) {
    return _apiClient.dio.get('bundles/$bundleId/webinars');
  }

  Future<Response> getReasons() {
    return _apiClient.dio.get('panel/reviews/reports/reasons');
  }

  Future<Response> getNotices(int id) {
    return _apiClient.dio.get('panel/webinars/$id/noticeboards');
  }

  Future<Response> reportCourse(Map<String, dynamic> data) {
    return _apiClient.dio.post('panel/reviews/reports', data: data);
  }

  Future<Response> toggle(int id, Map<String, dynamic> data) {
    return _apiClient.dio.post('panel/webinars/$id/content-status', data: data);
  }

  Future<Response> addFavorite(Map<String, dynamic> data) {
    return _apiClient.dio.post('panel/favorites/toggle', data: data);
  }

  Future<Response> getFreeCourse(int id) {
    return _apiClient.dio.post('panel/webinars/$id/free');
  }

  Future<Response> getContent(int courseId) {
    return _apiClient.dio.get('panel/webinars/$courseId/content');
  }

  Future<Response> getSingleContent(String url) {
    return _apiClient.dio.get('panel/$url');
  }
}
