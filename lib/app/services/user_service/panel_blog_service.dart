import 'dart:convert';
import 'package:http/http.dart';
import 'package:esoi/app/models/blog_model.dart';
import 'package:esoi/common/enums/error_enum.dart';
import 'package:esoi/common/utils/constants.dart';
import 'package:esoi/common/utils/error_handler.dart';
import 'package:esoi/common/utils/http_handler.dart';

class PanelBlogService {
  // === Panel Blogs ===

  static Future<List<BlogModel>> getBlogs() async {
    List<BlogModel> data = [];
    try {
      String url = '${Constants.baseUrl}panel/blogs';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
        if (jsonResponse['data'] is List) {
          jsonResponse['data'].forEach((json) {
            data.add(BlogModel.fromJson(json));
          });
        } else if (jsonResponse['data'] != null && jsonResponse['data']['blogs'] != null) {
          jsonResponse['data']['blogs'].forEach((json) {
            data.add(BlogModel.fromJson(json));
          });
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

  static Future<bool> storeBlog(Map<String, dynamic> body) async {
    try {
      String url = '${Constants.baseUrl}panel/blogs';
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

  static Future<BlogModel?> getBlog(int blogId) async {
    try {
      String url = '${Constants.baseUrl}panel/blogs/$blogId';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
        return BlogModel.fromJson(jsonResponse['data']);
      } else {
        ErrorHandler().showError(ErrorEnum.error, jsonResponse);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateBlog(int blogId, Map<String, dynamic> body) async {
    try {
      String url = '${Constants.baseUrl}panel/blogs/$blogId';
      Response res = await httpPutWithToken(url, body); // Assuming httpPutWithToken exists or use httpPost
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

  static Future<bool> deleteBlog(int blogId) async {
    try {
      String url = '${Constants.baseUrl}panel/blogs/$blogId';
      Response res = await httpDeleteWithToken(url); // Assuming httpDeleteWithToken exists
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

  // === Panel Blog Comments ===

  static Future<List<dynamic>> getBlogComments() async {
    List<dynamic> data = [];
    try {
      String url = '${Constants.baseUrl}panel/blogs/comments';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
        if (jsonResponse['data'] is List) {
          data = jsonResponse['data'];
        } else if (jsonResponse['data'] != null && jsonResponse['data']['comments'] != null) {
          data = jsonResponse['data']['comments'];
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

  static Future<bool> storeBlogComment(Map<String, dynamic> body) async {
    try {
      String url = '${Constants.baseUrl}panel/blogs/comments';
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

  static Future<Map<String, dynamic>?> getBlogComment(int commentId) async {
    try {
      String url = '${Constants.baseUrl}panel/blogs/comments/$commentId';
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

  static Future<bool> updateBlogComment(int commentId, Map<String, dynamic> body) async {
    try {
      String url = '${Constants.baseUrl}panel/blogs/comments/$commentId';
      Response res = await httpPutWithToken(url, body);
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

  static Future<bool> deleteBlogComment(int commentId) async {
    try {
      String url = '${Constants.baseUrl}panel/blogs/comments/$commentId';
      Response res = await httpDeleteWithToken(url);
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
