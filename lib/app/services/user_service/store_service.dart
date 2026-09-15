import 'dart:convert';
import 'package:http/http.dart';
import 'package:esoi/common/enums/error_enum.dart';
import 'package:esoi/common/utils/constants.dart';
import 'package:esoi/common/utils/error_handler.dart';
import 'package:esoi/common/utils/http_handler.dart';

import 'package:esoi/app/models/store_product_model.dart';
import 'package:esoi/app/models/sales_model.dart';

class StoreService {
  static Future<List<StoreProductModel>> getProducts() async {
    List<StoreProductModel> data = [];
    try {
      String url = '${Constants.baseUrl}panel/store/products';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
        if (jsonResponse['data'] is List) {
          data = (jsonResponse['data'] as List).map((e) => StoreProductModel.fromJson(e)).toList();
        } else if (jsonResponse['data'] != null && jsonResponse['data']['products'] != null) {
          data = (jsonResponse['data']['products'] as List).map((e) => StoreProductModel.fromJson(e)).toList();
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

  static Future<List<Sales>> getSales() async {
    List<Sales> data = [];
    try {
      String url = '${Constants.baseUrl}panel/store/sales';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
         if (jsonResponse['data'] is List) {
          data = (jsonResponse['data'] as List).map((e) => Sales.fromJson(e)).toList();
        } else if (jsonResponse['data'] != null && jsonResponse['data']['sales'] != null) {
          data = (jsonResponse['data']['sales'] as List).map((e) => Sales.fromJson(e)).toList();
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

  static Future<List<Sales>> getPurchases() async {
    List<Sales> data = [];
    try {
      String url = '${Constants.baseUrl}panel/store/purchases';
      Response res = await httpGetWithToken(url);
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success'] == true) {
         if (jsonResponse['data'] is List) {
          data = (jsonResponse['data'] as List).map((e) => Sales.fromJson(e)).toList();
        } else if (jsonResponse['data'] != null && jsonResponse['data']['purchases'] != null) {
          data = (jsonResponse['data']['purchases'] as List).map((e) => Sales.fromJson(e)).toList();
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
