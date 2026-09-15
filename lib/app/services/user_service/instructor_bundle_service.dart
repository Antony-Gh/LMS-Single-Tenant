import 'dart:convert';
import 'package:http/http.dart';
import 'package:esoi/common/enums/error_enum.dart';
import 'package:esoi/common/utils/constants.dart';
import 'package:esoi/common/utils/error_handler.dart';
import 'package:esoi/common/utils/http_handler.dart';

import 'package:esoi/app/models/bundle_model.dart';

class InstructorBundleService {
  static Future<List<BundleModel>> getBundles() async {
    List<BundleModel> data = [];
    try {
      String url = '${Constants.baseUrl}instructor/bundles';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
        if (jsonResponse['data'] is List) {
          data = (jsonResponse['data'] as List).map((e) => BundleModel.fromJson(e)).toList();
        } else if (jsonResponse['data'] != null && jsonResponse['data']['bundles'] != null) {
          data = (jsonResponse['data']['bundles'] as List).map((e) => BundleModel.fromJson(e)).toList();
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

  static Future<bool> storeBundle(Map<String, dynamic> body) async {
    try {
      String url = '${Constants.baseUrl}instructor/bundles';
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

  static Future<BundleModel?> getBundle(int bundleId) async {
    try {
      String url = '${Constants.baseUrl}instructor/bundles/$bundleId';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
        return BundleModel.fromJson(jsonResponse['data']);
      } else {
        ErrorHandler().showError(ErrorEnum.error, jsonResponse);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateBundle(int bundleId, Map<String, dynamic> body) async {
    try {
      String url = '${Constants.baseUrl}instructor/bundles/$bundleId';
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

  static Future<bool> deleteBundle(int bundleId) async {
    try {
      String url = '${Constants.baseUrl}instructor/bundles/$bundleId';
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

  static Future<dynamic> exportBundle(int bundleId) async {
    try {
      String url = '${Constants.baseUrl}instructor/bundles/$bundleId/export';
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

  static Future<List<dynamic>> getBundleWebinars(int bundleId) async {
    List<dynamic> data = [];
    try {
      String url = '${Constants.baseUrl}instructor/bundles/$bundleId/webinars';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
        if (jsonResponse['data'] is List) {
          data = jsonResponse['data'];
        } else if (jsonResponse['data'] != null && jsonResponse['data']['webinars'] != null) {
          data = jsonResponse['data']['webinars'];
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
}
