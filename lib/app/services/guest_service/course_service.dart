import 'dart:convert';
import 'dart:developer';

import 'package:esoi/app/models/content_model.dart';
import 'package:esoi/app/models/course_model.dart';
import 'package:esoi/app/models/notice_model.dart';
import 'package:esoi/app/models/single_course_model.dart';
import 'package:esoi/app/models/user_model.dart';
import 'package:esoi/common/data/api_public_data.dart';
import 'package:esoi/common/utils/app_text.dart';
import 'package:esoi/common/utils/constants.dart';
import 'package:http/http.dart';
import 'package:esoi/common/utils/http_handler.dart';

import '../../../common/enums/error_enum.dart';
import '../../../common/utils/error_handler.dart';
import '../../../common/components.dart';
import '../../models/single_content_model.dart';

class CourseService {
  static Future<List<CourseModel>> getAll({
    required int offset,
    bool upcoming = false,
    bool free = false,
    bool discount = false,
    bool downloadable = false,
    String? sort,
    String? type,
    String? cat,
    bool reward = false,
    bool bundle = false,
    List<int>? filterOption,
  }) async {
    List<CourseModel> data = [];
    try {
      String url =
          '${Constants.baseUrl}${bundle ? 'bundles' : 'courses'}?offset=$offset&limit=10';

      if (upcoming) url += '&upcoming=1';
      if (free) url += '&free=1';
      if (discount) url += '&discount=1';
      if (downloadable) url += '&downloadable=1';
      if (reward) url += '&reward=1';

      if (sort != null) url += '&sort=$sort';
      if (cat != null) url += '&cat=$cat';

      if (filterOption != null && filterOption.isNotEmpty) {
        for (int i = 0; i < filterOption.length; i++) {
          url += '&filter_option=${filterOption[i]}';
        }
      }

      Response res = await httpGet(url);

      var jsonRes = jsonDecode(res.body);

      if (jsonRes['success'] ?? false) {
        if (bundle) {
          jsonRes['data']['bundles'].forEach((json) {
            data.add(CourseModel.fromJson(json));
          });
        } else {
          jsonRes['data'].forEach((json) {
            data.add(CourseModel.fromJson(json));
          });
        }
        log('link from url:${url}');
        log('course count : ${data.length}');
        return data;
      } else {
        return data;
      }
    } catch (e) {
      return data;
    }
  }

  static Future<SingleCourseModel?> getOverviewCourseData(int id, bool isBundle,
      {bool isPrivate = false}) async {
    try {
      String url =
          '${Constants.baseUrl}${isPrivate ? 'panel/webinars' : isBundle ? 'panel/bundles' : 'panel/webinars'}/$id';

      Response res = await httpGet(url, isSendToken: true);

      var jsonRes = jsonDecode(res.body);

      if (jsonRes['success'] ?? false) {
        return SingleCourseModel.fromJson(
            isBundle ? jsonRes['data']['bundle'] : jsonRes['data']);
      } else {
        ErrorHandler().showError(ErrorEnum.error, jsonRes, readMessage: true);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<SingleCourseModel?> getSingleCourseData(
    int id,
    bool isBundle, {
    bool isPrivate = false,
  }) async {
    try {
      String url =
          '${Constants.baseUrl}${isPrivate ? 'panel/webinars' : isBundle ? 'bundles' : 'courses'}/$id';

      print('📡 Request URL: $url');
      print('🔐 isPrivate: $isPrivate | 📦 isBundle: $isBundle');

      Response res = await httpGet(
        url,
        isSendToken: true,
      );

      print('📥 Status Code: ${res.statusCode}');
      print('📥 Raw Response Body: ${res.body}');

      var jsonRes = jsonDecode(res.body);
      print('📦 Decoded JSON: $jsonRes');

      if (jsonRes['success'] ?? false) {
        return SingleCourseModel.fromJson(
            isBundle ? jsonRes['data']['bundle'] : jsonRes['data']);
      } else {
        print('❌ Success = false');
        print('❗ Error Response: $jsonRes');

        ErrorHandler().showError(ErrorEnum.error, jsonRes, readMessage: true);
        return null;
      }
    } catch (e, stack) {
      print('🔥 Exception occurred: $e');
      print('📌 StackTrace: $stack');

      showSnackBar(
        ErrorEnum.error,
        null,
        desc: appText.serverExceptionError,
      );
      return null;
    }
  }

  static Future<List<CourseModel>> featuredCourse({String? cat}) async {
    List<CourseModel> data = [];
    try {
      String url = '${Constants.baseUrl}featured-courses';
      if (cat != null) url += '?cat=$cat';

      print('📡 featuredCourse URL: $url');

      Response res = await httpGet(url, isMaintenance: true);

      print('📥 Status Code: ${res.statusCode}');
      print('📥 Raw Response: ${res.body}');

      var jsonRes = jsonDecode(res.body);
      print('📦 Decoded JSON: $jsonRes');

      if (jsonRes['success'] == true) {
        jsonRes['data'].forEach((json) {
          print('📄 Course JSON: $json');
          data.add(CourseModel.fromJson(json));
        });

        log('⭐ featured course count: ${data.length}');
      } else {
        print('❌ featuredCourse success = false');
      }

      return data;
    } catch (e, stack) {
      print('🔥 featuredCourse Exception: $e');
      print('📌 StackTrace: $stack');
      return data;
    }
  }

  static Future<List<CourseModel>> getBundleWebinars(int bundleId) async {
    List<CourseModel> data = [];
    try {
      String url = '${Constants.baseUrl}bundles/$bundleId/webinars';
      print('📡 getBundleWebinars URL: $url');

      Response res = await httpGet(url, isMaintenance: true);

      print('📥 Status Code: ${res.statusCode}');
      print('📥 Raw Response: ${res.body}');

      var jsonRes = jsonDecode(res.body);
      print('📦 Decoded JSON: $jsonRes');

      if (jsonRes['success'] == true) {
        jsonRes['data']['webinars'].forEach((json) {
          print('📄 Webinar JSON: $json');
          data.add(CourseModel.fromJson(json));
        });

        print('✅ Webinars Count: ${data.length}');
      } else {
        print('❌ getBundleWebinars success = false');
      }

      return data;
    } catch (e, stack) {
      print('🔥 getBundleWebinars Exception: $e');
      print('📌 StackTrace: $stack');
      return data;
    }
  }

  static Future<List<CourseModel>> bundleCourses(int bundleId) async {
    List<CourseModel> data = [];
    try {
      String url = '${Constants.baseUrl}bundles/$bundleId/webinars';
      print('📡 bundleCourses URL: $url');

      Response res = await httpGet(url);

      print('📥 Status Code: ${res.statusCode}');
      print('📥 Raw Response: ${res.body}');

      var jsonRes = jsonDecode(res.body);
      print('📦 Decoded JSON: $jsonRes');

      if (jsonRes['success'] == true) {
        jsonRes['data']['webinars'].forEach((json) {
          print('📄 Course JSON: $json');
          data.add(CourseModel.fromJson(json));
        });

        log('🎓 bundle course count: ${data.length}');
      } else {
        print('❌ bundleCourses success = false');
      }

      return data;
    } catch (e, stack) {
      print('🔥 bundleCourses Exception: $e');
      print('📌 StackTrace: $stack');
      return data;
    }
  }

  static Future<List<String>> getReasons() async {
    List<String> data = [];
    try {
      String url = '${Constants.baseUrl}courses/reports/reasons';
      print('📡 getReasons URL: $url');

      Response res = await httpGet(url);

      print('📥 Status Code: ${res.statusCode}');
      print('📥 Raw Response: ${res.body}');

      var jsonRes = jsonDecode(res.body);
      print('📦 Decoded JSON: $jsonRes');

      if (jsonRes['success'] == true) {
        jsonRes['data'].forEach((json) {
          print('📄 Reason: $json');
          data.add(json);
        });

        PublicData.reasonsData = data;
        print('✅ Reasons Count: ${data.length}');
      } else {
        print('❌ getReasons success = false');
      }

      return data;
    } catch (e, stack) {
      print('🔥 getReasons Exception: $e');
      print('📌 StackTrace: $stack');
      return data;
    }
  }

  static Future<List<NoticeModel>> getNotices(int id) async {
    List<NoticeModel> data = [];
    try {
      String url = '${Constants.baseUrl}panel/webinars/$id/noticeboards';

      Response res = await httpGetWithToken(url);

      var jsonRes = jsonDecode(res.body);

      if (jsonRes['success']) {
        jsonRes['data'].forEach((json) {
          data.add(NoticeModel.fromJson(json));
        });

        return data;
      } else {
        return data;
      }
    } catch (e) {
      return data;
    }
  }

  static Future<bool> reportCourse(
      String reason, int courseId, String message) async {
    try {
      String url = '${Constants.baseUrl}courses/$courseId/report';

      Response res =
          await httpPostWithToken(url, {"reason": reason, "message": message});

      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success']) {
        showSnackBar(ErrorEnum.success, jsonResponse['message']?.toString());
        return true;
      } else {
        ErrorHandler().showError(ErrorEnum.error, jsonResponse);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> toggle(
      int courseId, String itemName, String itemId, bool status) async {
    try {
      String url = '${Constants.baseUrl}courses/$courseId/toggle';

      Response res = await httpPostWithToken(
          url, {"item": itemName, "item_id": itemId, "status": status});

      var jsonResponse = jsonDecode(res.body);
      print(jsonResponse);

      if (jsonResponse['success']) {
        return true;
      } else {
        ErrorHandler().showError(ErrorEnum.error, jsonResponse);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addFavorite(int courseId, bool isBundle) async {
    try {
      String url = '${Constants.baseUrl}panel/favorites/toggle2';

      Response res = await httpPostWithToken(
          url, {"item": isBundle ? 'bundle' : 'webinar', "id": courseId});

      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success']) {
        ErrorHandler()
            .showError(ErrorEnum.success, jsonResponse, readMessage: true);
        return true;
      } else {
        ErrorHandler()
            .showError(ErrorEnum.error, jsonResponse, readMessage: true);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<
      (
        List<CourseModel> courseData,
        List<UserModel> usersData
      )> search(String text) async {
    List<CourseModel> courseData = [];
    List<UserModel> usersData = [];

    try {
      String url = '${Constants.baseUrl}search?search=$text';

      Response res = await httpGet(url);

      var jsonRes = jsonDecode(res.body);

      if (jsonRes['success']) {
        jsonRes['data']['webinars']['webinars'].forEach((json) {
          courseData.add(CourseModel.fromJson(json));
        });

        jsonRes['data']['users']['users'].forEach((json) {
          usersData.add(UserModel.fromJson(json));
        });

        return (courseData, usersData);
      } else {
        return (courseData, usersData);
      }
    } catch (e) {
      return (courseData, usersData);
    }
  }

  static Future<List<ContentModel>> getContent(int courseId) async {
    List<ContentModel> data = [];

    try {
      String url = '${Constants.baseUrl}courses/$courseId/content';
      print('📡 getContent URL: $url');

      Response res = await httpGetWithToken(
        url,
        isRedirectingStatusCode: false,
      );

      print('📥 Status Code: ${res.statusCode}');
      print('📥 Raw Response: ${res.body}');

      var jsonResponse = jsonDecode(res.body);
      print('📦 Decoded JSON: $jsonResponse');

      if (jsonResponse['success'] == true) {
        print('✅ Success = true');
        print('📚 Content Count: ${jsonResponse['data']?.length}');

        jsonResponse['data'].forEach((json) {
          print('📄 Content Item JSON: $json');
          data.add(ContentModel.fromJson(json));
        });

        print('✅ Parsed ContentModel Count: ${data.length}');
        return data;
      } else {
        print('❌ Success = false');
        print('❗ Error JSON: $jsonResponse');

        ErrorHandler().showError(ErrorEnum.error, jsonResponse);
        return data;
      }
    } catch (e, stack) {
      print('🔥 Exception in getContent: $e');
      print('📌 StackTrace: $stack');
      return data;
    }
  }

  static Future<String?> getContentJSON(int courseId) async {
    try {
      String url = '${Constants.baseUrl}courses/$courseId/content';
      print('📡 getContentJSON URL: $url');

      Response res = await httpGetWithToken(
        url,
        isRedirectingStatusCode: false,
      );

      print('📥 Status Code: ${res.statusCode}');
      print('📥 Raw Response: ${res.body}');

      var jsonResponse = jsonDecode(res.body);
      print('📦 Decoded JSON: $jsonResponse');

      if (jsonResponse['success'] == true) {
        final encoded = jsonEncode(jsonResponse['data'] ?? {});
        print('✅ Success = true');
        print('🧾 Encoded JSON Length: ${encoded.length}');
        print(
            '🧾 Encoded JSON Preview: ${encoded.substring(0, encoded.length > 300 ? 300 : encoded.length)}');

        return encoded;
      } else {
        print('❌ Success = false');
        print('❗ Error JSON: $jsonResponse');

        ErrorHandler().showError(ErrorEnum.error, jsonResponse);
        return null;
      }
    } catch (e, stack) {
      print('🔥 Exception in getContentJSON: $e');
      print('📌 StackTrace: $stack');
      return null;
    }
  }

  static Future<SingleContentModel?> getSingleContent(String url) async {
    try {
      Response res =
          await httpGetWithToken(url, isRedirectingStatusCode: false);

      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] ?? false) {
        return SingleContentModel.fromJson(jsonResponse['data']);
      } else {
        ErrorHandler().showError(ErrorEnum.error, jsonResponse);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getSingleContentJSON(String url) async {
    try {
      Response res =
          await httpGetWithToken(url, isRedirectingStatusCode: false);

      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] ?? false) {
        return res.body;
      } else {
        ErrorHandler().showError(ErrorEnum.error, jsonResponse);
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
