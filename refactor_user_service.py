import re

file_path = r'e:\Projects\LMS_APP\lms-single-tenant-app-main\lib\app\services\user_service\user_service.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace class definition
content = content.replace('class UserService {', 'import \'package:esoi/core/network/api/user_api.dart\';\n\nclass UserService {\n  final UserApi _userApi;\n\n  UserService(this._userApi);\n')

# Remove static from methods
content = re.sub(r'static Future<', 'Future<', content)

# 1. getPurchaseCourse
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/webinars/purchases';\s+Response res = await httpGetWithToken\(\s*url,\s*\);\s+var jsonResponse = jsonDecode\(res\.body\);",
    r"dio.Response res = await _userApi.getPurchaseCourse();\n    var jsonResponse = res.data;",
    content
)

# 2. getPurchaseCourseJSON
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/webinars/purchases';\s+Response res = await httpGetWithToken\(\s*url,\s*\);\s+var jsonResponse = jsonDecode\(res\.body\);",
    r"dio.Response res = await _userApi.getPurchaseCourse();\n      var jsonResponse = res.data;",
    content
)

# 3. getAllNotification
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/notifications';\s+Response res = await httpGetWithToken\(\s*url,\s*\);\s+var jsonResponse = jsonDecode\(res\.body\);",
    r"dio.Response res = await _userApi.getAllNotification();\n      var jsonResponse = res.data;",
    content
)

# 4. getFavorites
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/favorites';\s+Response res = await httpGetWithToken\(\s*url,\s*\);\s+var jsonResponse = jsonDecode\(res\.body\);",
    r"dio.Response res = await _userApi.getFavorites();\n      var jsonResponse = res.data;",
    content
)

# 5. getLoginHistory
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/users/login-history';\s+Response res = await httpGetWithToken\(\s*url,\s*\);\s+var jsonResponse = jsonDecode\(res\.body\);",
    r"dio.Response res = await _userApi.getLoginHistory();\n      var jsonResponse = res.data;",
    content
)

# 6. deleteFavorite
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/favorites/\$id';\s+Response res = await httpDeleteWithToken\(url\);\s+var jsonResponse = jsonDecode\(res\.body\);",
    r"dio.Response res = await _userApi.deleteFavorite(id);\n      var jsonResponse = res.data;",
    content
)

# 7. deleteAccount
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/users/delete-account';\s+Response res = await httpPostWithToken\(url, \{\}\);\s+var jsonResponse = jsonDecode\(res\.body\);",
    r"dio.Response res = await _userApi.deleteAccount();\n      var jsonResponse = res.data;",
    content
)

# 8. registerBadge
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/users/register-badge';\s+Response res = await httpPostWithToken\(url, \{\}\);\s+var jsonResponse = jsonDecode\(res\.body\);",
    r"dio.Response res = await _userApi.registerBadge();\n      var jsonResponse = res.data;",
    content
)

# 9. getProfile
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/profile';\s+Response res = await httpGetWithToken\(url\);\s+var jsonResponse = jsonDecode\(res\.body\);",
    r"dio.Response res = await _userApi.getProfile();\n      var jsonResponse = res.data;",
    content
)

# 10. getDashboardData
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel';\s+Response res = await httpGetWithToken\(url\);\s+var jsonResponse = jsonDecode\(res\.body\);",
    r"dio.Response res = await _userApi.getDashboardData();\n      var jsonResponse = res.data;",
    content
)

# 11. getRewardPointsData
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/rewards';\s+Response res = await httpGetWithToken\(url\);\s+var jsonResponse = jsonDecode\(res\.body\);",
    r"dio.Response res = await _userApi.getRewardPointsData();\n      var jsonResponse = res.data;",
    content
)

# 12. seenNotification
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/notifications/\$id/seen';\s+Response res = await httpPostWithToken\(url, \{\}\);\s+var jsonResponse = jsonDecode\(res\.body\);",
    r"dio.Response res = await _userApi.seenNotification(id);\n      var jsonResponse = res.data;",
    content
)

# 13. storeReview
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/reviews/store';\s+Response res =\s*await httpPostWithToken\(url, \{\s*'webinar_id': courseId\.toString\(\),\s*'content_quality': contentQuality\.toString\(\),\s*'instructor_skills': instructorSkills\.toString\(\),\s*'purchase_worth': purchaseWorth\.toString\(\),\s*'support_quality': supportQuality\.toString\(\),\s*'description': description\s*\}\);\s+var jsonResponse = jsonDecode\(res\.body\);",
    r"dio.Response res = await _userApi.storeReview({\n        'webinar_id': courseId.toString(),\n        'content_quality': contentQuality.toString(),\n        'instructor_skills': instructorSkills.toString(),\n        'purchase_worth': purchaseWorth.toString(),\n        'support_quality': supportQuality.toString(),\n        'description': description\n      });\n      var jsonResponse = res.data;",
    content
)

# 14. updateInfo
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/profile/setting';\s+Response res = await httpPostWithToken\(\s*url,\s*\{\s*'full_name': name,\s*'email': email,\s*'mobile': mobile,\s*'language': language,\s*'biography': bio,\s*'newsletter': newsletter \? '1' : '0',\s*'account_type': accountType,\s*'iban': iban,\s*'account_id': accountId,\s*\}\);\s+var jsonResponse = jsonDecode\(res\.body\);",
    r"dio.Response res = await _userApi.updateInfo({\n        'full_name': name,\n        'email': email,\n        'mobile': mobile,\n        'language': language,\n        'biography': bio,\n        'newsletter': newsletter ? '1' : '0',\n        'account_type': accountType,\n        'iban': iban,\n        'account_id': accountId,\n      });\n      var jsonResponse = res.data;",
    content
)

# 15. updatePassword
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/profile/setting/password';\s+Response res = await httpPostWithToken\(\s*url,\s*\{\s*'current_password': currentPassword,\s*'new_password': newPassword,\s*'new_password_confirmation': retypePassword,\s*\}\);\s+var jsonResponse = jsonDecode\(res\.body\);",
    r"dio.Response res = await _userApi.updatePassword({\n        'current_password': currentPassword,\n        'new_password': newPassword,\n        'new_password_confirmation': retypePassword,\n      });\n      var jsonResponse = res.data;",
    content
)

# 16. sendFirebaseToken
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}device-tokens';\s+Response res = await httpPostWithToken\(url, \{'device_token': token\}\);\s+var jsonResponse = jsonDecode\(res\.body\);",
    r"dio.Response res = await _userApi.sendFirebaseToken({'device_token': token});\n      var jsonResponse = res.data;",
    content
)

# 17. updateImage
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/profile/setting/images';\s*var request = MultipartRequest\('POST', Uri\.parse\(url\)\);\s*request\.headers\['Authorization'\] = 'Bearer \$token';\s*if \(profile != null\) \{\s*request\.files\.add\(\s*await MultipartFile\.fromPath\('profile_image', profile\.path\)\);\s*\}\s*if \(indentity != null\) \{\s*request\.files\.add\(await MultipartFile\.fromPath\(\s*'identity_scan', indentity\.path\)\);\s*\}\s*if \(certificate != null\) \{\s*request\.files\.add\(\s*await MultipartFile\.fromPath\('certificate', certificate\.path\)\);\s*\}\s*var res = await request\.send\(\);\s*var responseData = await res\.stream\.toBytes\(\);\s*var jsonResponse = jsonDecode\(String\.fromCharCodes\(responseData\)\);",
    r"dio.FormData formData = dio.FormData();\n      if (profile != null) {\n        formData.files.add(MapEntry('profile_image', await dio.MultipartFile.fromFile(profile.path)));\n      }\n      if (indentity != null) {\n        formData.files.add(MapEntry('identity_scan', await dio.MultipartFile.fromFile(indentity.path)));\n      }\n      if (certificate != null) {\n        formData.files.add(MapEntry('certificate', await dio.MultipartFile.fromFile(certificate.path)));\n      }\n      dio.Response res = await _userApi.updateImage(formData);\n      var jsonResponse = res.data;",
    content
)

content = re.sub(r'import \'package:http/http.dart\';\n', '', content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
