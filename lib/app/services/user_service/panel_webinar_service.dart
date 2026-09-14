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

  static Future<dynamic> getFile(int fileId) async {
    try {
      String url = '${Constants.baseUrl}panel/files/$fileId';
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

  static Future<dynamic> getSession(int sessionId) async {
    try {
      String url = '${Constants.baseUrl}panel/sessions/$sessionId';
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

  static Future<dynamic> getTextLesson(int lessonId) async {
    try {
      String url = '${Constants.baseUrl}panel/text-lessons/$lessonId';
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

  static Future<dynamic> getTextLessonNavigation(int lessonId) async {
    try {
      String url = '${Constants.baseUrl}panel/text-lessons/$lessonId/navigation';
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

  static Future<dynamic> joinAgora(int sessionId) async {
    try {
      String url = '${Constants.baseUrl}panel/webinars/session/agora/$sessionId';
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

  static Future<List<dynamic>> getPersonalNotes(int itemId, String type) async {
    List<dynamic> data = [];
    try {
      String url = '${Constants.baseUrl}panel/webinars/personal-notes?item=$itemId&type=$type';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
        if (jsonResponse['data'] is List) {
          data = jsonResponse['data'];
        } else if (jsonResponse['data'] != null && jsonResponse['data']['notes'] != null) {
          data = jsonResponse['data']['notes'];
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

  static Future<bool> storePersonalNote(Map<String, dynamic> body) async {
    try {
      String url = '${Constants.baseUrl}panel/webinars/personal-notes';
      Response res = await httpPostWithToken(url, body);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
        ErrorHandler().showError(ErrorEnum.success, jsonResponse, readMessage: true);
        return true;
      } else {
        ErrorHandler().showError(ErrorEnum.error, jsonResponse);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deletePersonalNote(int noteId) async {
    try {
      String url = '${Constants.baseUrl}panel/webinars/personal-notes/delete/$noteId';
      Response res = await httpDeleteWithToken(url, {});
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
        ErrorHandler().showError(ErrorEnum.success, jsonResponse, readMessage: true);
        return true;
      } else {
        ErrorHandler().showError(ErrorEnum.error, jsonResponse);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<List<dynamic>> getWebinarNoticeboards(int courseId) async {
    List<dynamic> data = [];
    try {
      String url = '${Constants.baseUrl}panel/webinars/$courseId/noticeboards';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
        if (jsonResponse['data'] is List) {
          data = jsonResponse['data'];
        } else if (jsonResponse['data'] != null && jsonResponse['data']['noticeboards'] != null) {
          data = jsonResponse['data']['noticeboards'];
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

  static Future<bool> storeInstructorWebinar(Map<String, dynamic> body) async {
    try {
      String url = '${Constants.baseUrl}instructor/webinar';
      Response res = await httpPostWithToken(url, body);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
        ErrorHandler().showError(ErrorEnum.success, jsonResponse, readMessage: true);
        return true;
      } else {
        ErrorHandler().showError(ErrorEnum.error, jsonResponse);
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
