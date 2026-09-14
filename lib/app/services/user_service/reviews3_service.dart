import 'dart:convert';
import 'package:http/http.dart';
import 'package:esoi/common/enums/error_enum.dart';
import 'package:esoi/common/utils/constants.dart';
import 'package:esoi/common/utils/error_handler.dart';
import 'package:esoi/common/utils/http_handler.dart';

class Reviews3Service {
  static Future<List<dynamic>> getReviews() async {
    List<dynamic> data = [];
    try {
      String url = '${Constants.baseUrl}panel/reviews3';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
        if (jsonResponse['data'] is List) {
          data = jsonResponse['data'];
        } else if (jsonResponse['data'] != null && jsonResponse['data']['reviews'] != null) {
          data = jsonResponse['data']['reviews'];
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

  static Future<bool> storeReview(Map<String, dynamic> body) async {
    try {
      String url = '${Constants.baseUrl}panel/reviews3';
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

  static Future<bool> replyReview(int reviewId, String reply) async {
    try {
      String url = '${Constants.baseUrl}panel/reviews3/$reviewId/reply';
      Response res = await httpPostWithToken(url, {"reply": reply});
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

  static Future<bool> deleteReview(int reviewId) async {
    try {
      String url = '${Constants.baseUrl}panel/reviews3/$reviewId';
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
}
