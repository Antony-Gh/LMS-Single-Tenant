import 'dart:convert';
import 'package:http/http.dart';
import 'package:esoi/common/enums/error_enum.dart';
import 'package:esoi/common/utils/constants.dart';
import 'package:esoi/common/utils/error_handler.dart';
import 'package:esoi/common/utils/http_handler.dart';
import 'package:esoi/app/models/course_model.dart';

class PanelWebinarService {
  static Future<CourseModel?> getWebinar(int courseId) async {
    try {
      String url = '${Constants.baseUrl}panel/webinars/$courseId';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
        return CourseModel.fromJson(jsonResponse['data']);
      } else {
        ErrorHandler().showError(ErrorEnum.error, jsonResponse);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<dynamic>> getWebinarChapters(int courseId) async {
    List<dynamic> data = [];
    try {
      String url = '${Constants.baseUrl}panel/webinars/$courseId/chapters';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
        if (jsonResponse['data'] is List) {
          data = jsonResponse['data'];
        } else if (jsonResponse['data'] != null && jsonResponse['data']['chapters'] != null) {
          data = jsonResponse['data']['chapters'];
        }
        return data;
      } else {
        ErrorHandler().showError(ErrorEnum.error, jsonResponse);
        return data;
      }
    } catch (e) {
      return data;
    }
  }

  static Future<dynamic> getWebinarChapter(int courseId, int chapterId) async {
    try {
      String url = '${Constants.baseUrl}panel/webinars/$courseId/chapters/$chapterId';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
        return jsonResponse['data'];
      } else {
        ErrorHandler().showError(ErrorEnum.error, jsonResponse);
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
