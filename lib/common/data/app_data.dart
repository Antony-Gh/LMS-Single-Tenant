import 'package:shared_preferences/shared_preferences.dart';
import 'package:esoi/common/data/api_public_data.dart';
import 'package:esoi/core/storage/secure_storage_helper.dart';
import 'package:esoi/locator.dart';

class AppData {
  static Future saveAccessToken(String data) async {
    // Save to secure storage ONLY
    return await locator<SecureStorageHelper>().saveToken(data);
  }

  static Future<String> getAccessToken() async {
    String? token = await locator<SecureStorageHelper>().getToken();
    if (token != null && token.isNotEmpty) {
      return token;
    }
    // Fallback to shared preferences if not in secure storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('access_token') ?? '';
    
    // One-way migration: if token exists in SharedPreferences, move to SecureStorage and delete
    if (data.isNotEmpty) {
      await locator<SecureStorageHelper>().saveToken(data);
      await prefs.remove('access_token');
    }
    
    return data;
  }

  static Future saveName(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('name', data);
  }

  static Future getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('name') ?? '';
    return data;
  }

  static Future saveCurrency(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('currency', data);
  }

  static Future getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('currency') ??
        (PublicData.apiConfigData?['currency']?['name'] ?? 'USD');

    if (data.isEmpty) {
      data = (PublicData.apiConfigData?['currency']?['name'] ?? 'USD');
    }
    return data;
  }

  static Future saveIsFirst(bool data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool('is_first', data);
  }

  static Future getIsFirst() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_first') ?? true;
  }

  static Future saveIsLightMode(bool data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool('theme', data);
  }

  static Future getIsLightMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('theme') ?? true;
  }

  // static String appName = 'Webinar';
  static bool canShowFinalizeSheet = true;
}
