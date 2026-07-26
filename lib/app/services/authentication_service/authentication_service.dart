import 'package:esoi/core/network/api/auth_api.dart';
import 'package:esoi/common/data/app_data.dart';
import 'package:esoi/common/enums/error_enum.dart';
import 'package:esoi/common/utils/error_handler.dart';
import 'package:esoi/app/models/register_config_model.dart';
import 'package:dio/dio.dart';
import 'package:esoi/common/common.dart';
import 'package:esoi/app/pages/authentication_page/login_page.dart';

class AuthenticationService {
  final AuthApi _authApi;

  AuthenticationService(this._authApi);

  Future<void> handleUnauthorized() async {
    await AppData.saveAccessToken('');
    nextRoute(LoginPage.pageName, isClearBackRoutes: true);
  }

  Future<bool> logout() async {
    try {
      await _authApi.logout();
      // Clear local storage and navigate to login regardless of server response
      await handleUnauthorized();
      return true;
    } catch (e) {
      // Even if API fails, clear local state
      await handleUnauthorized();
      return false;
    }
  }

  Future<bool> google(String email, String token, String name) async {
    try {
      final data = {
        'email': email,
        'name': name,
        'id': token,
      };

      Response res = await _authApi.googleCallback(data);

      if (res.statusCode == 200) {
        await AppData.saveAccessToken(res.data['data']['token']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> facebook(String email, String token, String name) async {
    try {
      final data = {'id': token, 'name': name, 'email': email};
      Response res = await _authApi.facebookCallback(data);

      if (res.data['success'] == true) {
        await AppData.saveAccessToken(res.data['data']['token']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final data = {'username': username, 'password': password};
      Response res = await _authApi.login(data);

      if (res.data['success'] == true) {
        await AppData.saveAccessToken(res.data['data']['token']);
        await AppData.saveName('');
        return true;
      } else {
        ErrorHandler().showError(ErrorEnum.error, res.data, readMessage: true);
        return false;
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        ErrorHandler().showError(ErrorEnum.error, e.response!.data, readMessage: true);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<Map?> registerWithEmail(
      String registerMethod,
      String email,
      String password,
      String repeatPassword,
      int academicLevelId,
      String? accountType,
      List<Fields>? fields) async {
    try {
      Map<String, dynamic> data = {
        "register_method": registerMethod,
        "country_code": null,
        'email': email,
        'password': password,
        'password_confirmation': repeatPassword,
        'academic_level_id': academicLevelId,
      };

      if (fields != null) {
        Map bodyFields = {};
        for (var i = 0; i < fields.length; i++) {
          if (fields[i].type != 'upload') {
            bodyFields[fields[i].id!] = (fields[i].type == 'toggle')
                ? fields[i].userSelectedData == null ? 0 : 1
                : fields[i].userSelectedData;
          }
        }
        data['fields'] = bodyFields.toString();
      }
      
      Response res = await _authApi.registerStep1(data);

      if (res.data['success'] == true ||
          res.data['status'] == 'go_step_2' ||
          res.data['status'] == 'go_step_3') {
        return {
          'user_id': res.data['data']['user_id'],
          'step': res.data['status']
        };
      } else {
        ErrorHandler().showError(ErrorEnum.error, res.data);
        return null;
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        ErrorHandler().showError(ErrorEnum.error, e.response!.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map?> registerWithPhone(
      String registerMethod,
      String countryCode,
      String mobile,
      String password,
      String repeatPassword,
      int academicLevelId,
      String? accountType,
      List<Fields>? fields) async {
    try {
      Map<String, dynamic> data = {
        "register_method": registerMethod,
        "country_code": countryCode,
        'mobile': mobile,
        'password': password,
        'password_confirmation': repeatPassword,
        'academic_level_id': academicLevelId,
      };

      if (fields != null) {
        Map bodyFields = {};
        for (var i = 0; i < fields.length; i++) {
          if (fields[i].type != 'upload') {
            bodyFields[fields[i].id!] = (fields[i].type == 'toggle')
                ? fields[i].userSelectedData == null ? 0 : 1
                : fields[i].userSelectedData;
          }
        }
        data['fields'] = bodyFields.toString();
      }

      Response res = await _authApi.registerStep1(data);

      if (res.data['success'] == true ||
          res.data['status'] == 'go_step_2' ||
          res.data['status'] == 'go_step_3') {
        return {
          'user_id': res.data['data']['user_id'],
          'step': res.data['status']
        };
      } else {
        ErrorHandler().showError(ErrorEnum.error, res.data);
        return null;
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        ErrorHandler().showError(ErrorEnum.error, e.response!.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> forgetPassword(String? countryCode, String mobileOrEmail) async {
    try {
      Map<String, dynamic> data = {
        'type': countryCode == null ? 'email' : 'mobile',
        if (countryCode == null)
          "email": mobileOrEmail
        else ...{
          "country_code": countryCode,
          "mobile": mobileOrEmail,
        }
      };

      Response res = await _authApi.forgetPassword(data);

      if (res.data['success'] == true) {
        ErrorHandler().showError(ErrorEnum.success, res.data, readMessage: true);
        return true;
      } else {
        ErrorHandler().showError(ErrorEnum.error, res.data);
        return false;
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        ErrorHandler().showError(ErrorEnum.error, e.response!.data);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyCode(int userId, String code) async {
    try {
      final data = {
        "user_id": userId.toString(),
        "code": code,
      };

      Response res = await _authApi.verifyCode(data);

      if (res.data['success'] == true) {
        return true;
      } else {
        ErrorHandler().showError(ErrorEnum.error, res.data);
        return false;
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        ErrorHandler().showError(ErrorEnum.error, e.response!.data);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> registerStep3(int userId, String name, String referralCode) async {
    try {
      final data = {
        "user_id": userId.toString(),
        "full_name": name,
        "referral_code": referralCode
      };

      Response res = await _authApi.registerStep3(data);

      if (res.data['success'] == true) {
        await AppData.saveAccessToken(res.data['data']['token']);
        await AppData.saveName(name);
        return true;
      } else {
        ErrorHandler().showError(ErrorEnum.error, res.data);
        return false;
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        ErrorHandler().showError(ErrorEnum.error, e.response!.data);
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
