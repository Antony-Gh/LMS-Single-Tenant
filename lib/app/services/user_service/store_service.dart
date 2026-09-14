import 'dart:convert';
import 'package:http/http.dart';
import 'package:esoi/common/enums/error_enum.dart';
import 'package:esoi/common/utils/constants.dart';
import 'package:esoi/common/utils/error_handler.dart';
import 'package:esoi/common/utils/http_handler.dart';

class StoreService {
  static Future<List<dynamic>> getProducts() async {
    List<dynamic> data = [];
    try {
      String url = '${Constants.baseUrl}panel/store/products';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
        if (jsonResponse['data'] is List) {
          data = jsonResponse['data'];
        } else if (jsonResponse['data'] != null && jsonResponse['data']['products'] != null) {
          data = jsonResponse['data']['products'];
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

  static Future<List<dynamic>> getProductComments() async {
    List<dynamic> data = [];
    try {
      String url = '${Constants.baseUrl}panel/store/products/comments';
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

  static Future<Map<String, dynamic>?> getProduct(int id) async {
    try {
      String url = '${Constants.baseUrl}panel/store/products/$id';
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

  static Future<List<dynamic>> getSales() async {
    List<dynamic> data = [];
    try {
      String url = '${Constants.baseUrl}panel/store/sales';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
         if (jsonResponse['data'] is List) {
          data = jsonResponse['data'];
        } else if (jsonResponse['data'] != null && jsonResponse['data']['sales'] != null) {
          data = jsonResponse['data']['sales'];
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

  static Future<List<dynamic>> getSalesCustomers() async {
    List<dynamic> data = [];
    try {
      String url = '${Constants.baseUrl}panel/store/sales/customers';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
         if (jsonResponse['data'] is List) {
          data = jsonResponse['data'];
        } else if (jsonResponse['data'] != null && jsonResponse['data']['customers'] != null) {
          data = jsonResponse['data']['customers'];
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

  static Future<List<dynamic>> getPurchases() async {
    List<dynamic> data = [];
    try {
      String url = '${Constants.baseUrl}panel/store/purchases';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
         if (jsonResponse['data'] is List) {
          data = jsonResponse['data'];
        } else if (jsonResponse['data'] != null && jsonResponse['data']['purchases'] != null) {
          data = jsonResponse['data']['purchases'];
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

  static Future<List<dynamic>> getPurchasesComments() async {
    List<dynamic> data = [];
    try {
      String url = '${Constants.baseUrl}panel/store/purchases/comments';
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
}
