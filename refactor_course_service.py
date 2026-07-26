import re

file_path = r'e:\Projects\LMS_APP\lms-single-tenant-app-main\lib\app\services\guest_service\course_service.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace class definition
content = content.replace('class CourseService {', 'import \'package:esoi/core/network/api/course_api.dart\';\nimport \'package:dio/dio.dart\' as dio;\n\nclass CourseService {\n  final CourseApi _courseApi;\n\n  CourseService(this._courseApi);\n')

# Remove static from methods
content = re.sub(r'static Future<', 'Future<', content)

# 1. getAll
# We need to construct queryParameters dict
get_all_replacement = '''
      Map<String, dynamic> queryParameters = {
        'offset': offset,
        'limit': 10,
      };
      if (upcoming) queryParameters['upcoming'] = 1;
      if (free) queryParameters['free'] = 1;
      if (discount) queryParameters['discount'] = 1;
      if (downloadable) queryParameters['downloadable'] = 1;
      if (reward) queryParameters['reward'] = 1;
      if (sort != null) queryParameters['sort'] = sort;
      if (cat != null) queryParameters['cat'] = cat;
      if (filterOption != null && filterOption.isNotEmpty) {
        queryParameters['filter_option'] = filterOption;
      }
      
      dio.Response res = await _courseApi.getAll(bundle, queryParameters);
      var jsonRes = res.data;
'''
content = re.sub(
    r"String url =\s*'\$\{Constants\.baseUrl\}\$\{bundle \? 'bundles' : 'courses'\}\?offset=\$offset&limit=10';.*?Response res = await httpGet\(url\);\s*var jsonRes = jsonDecode\(res\.body\);",
    get_all_replacement,
    content,
    flags=re.DOTALL
)

# 2. getOverviewCourseData
get_overview_replacement = '''
      dio.Response res = await _courseApi.getOverviewCourseData(id, isBundle, isPrivate);
      var jsonRes = res.data;
'''
content = re.sub(
    r"String url =\s*'\$\{Constants\.baseUrl\}\$\{isPrivate \? 'panel/webinars' : isBundle \? 'panel/bundles' : 'panel/webinars'\}/\$id';\s*Response res = await httpGet\(url, isSendToken: true\);\s*var jsonRes = jsonDecode\(res\.body\);",
    get_overview_replacement,
    content,
    flags=re.DOTALL
)

# 3. getSingleCourseData
get_single_replacement = '''
      dio.Response res = await _courseApi.getSingleCourseData(id, isBundle);
      var jsonRes = res.data;
'''
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}\$\{isBundle \? 'bundles' : 'courses'\}/\$id';\s*Response res = await httpGet\(url, isSendToken: true\);\s*var jsonRes = jsonDecode\(res\.body\);",
    get_single_replacement,
    content,
    flags=re.DOTALL
)

# 4. featuredCourse
featured_replacement = '''
      Map<String, dynamic> queryParameters = {};
      if (cat != null) queryParameters['cat'] = cat;
      dio.Response res = await _courseApi.featuredCourse(queryParameters);
      var jsonRes = res.data;
'''
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}courses/reports/featured';\s*if \(cat != null\) url \+= '\?cat=\$cat';\s*Response res = await httpGet\(url\);\s*var jsonRes = jsonDecode\(res\.body\);",
    featured_replacement,
    content,
    flags=re.DOTALL
)

# 5. getBundleWebinars
bundle_webinars_replacement = '''
      dio.Response res = await _courseApi.getBundleWebinars(bundleId);
      var jsonRes = res.data;
'''
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}bundles/\$bundleId/webinars';\s*Response res = await httpGet\(url\);\s*var jsonRes = jsonDecode\(res\.body\);",
    bundle_webinars_replacement,
    content,
    flags=re.DOTALL
)

# 6. bundleCourses
bundle_courses_replacement = '''
      dio.Response res = await _courseApi.bundleCourses(bundleId);
      var jsonRes = res.data;
'''
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}bundles/\$bundleId/webinars';\s*Response res = await httpGet\(url\);\s*var jsonRes = jsonDecode\(res\.body\);",
    bundle_courses_replacement,
    content,
    flags=re.DOTALL
)

# 7. getReasons
reasons_replacement = '''
      dio.Response res = await _courseApi.getReasons();
      var jsonRes = res.data;
'''
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/reviews/reports/reasons';\s*Response res = await httpGetWithToken\(url\);\s*var jsonRes = jsonDecode\(res\.body\);",
    reasons_replacement,
    content,
    flags=re.DOTALL
)

# 8. getNotices
notices_replacement = '''
      dio.Response res = await _courseApi.getNotices(id);
      var jsonRes = res.data;
'''
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/webinars/\$id/noticeboards';\s*Response res = await httpGetWithToken\(url\);\s*var jsonRes = jsonDecode\(res\.body\);",
    notices_replacement,
    content,
    flags=re.DOTALL
)

# 9. reportCourse
report_replacement = '''
      dio.Response res = await _courseApi.reportCourse({
        'webinar_id': courseId,
        'reason_id': reasonId,
        'message': message
      });
      var jsonRes = res.data;
'''
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/reviews/reports';\s*Response res = await httpPostWithToken\(\s*url,\s*\{\s*'webinar_id': courseId\.toString\(\),\s*'reason_id': reasonId\.toString\(\),\s*'message': message\s*\}\);\s*var jsonRes = jsonDecode\(res\.body\);",
    report_replacement,
    content,
    flags=re.DOTALL
)

# 10. toggle
toggle_replacement = '''
      dio.Response res = await _courseApi.toggle(id, {'item_id': itemId, 'item': item});
      var jsonRes = res.data;
'''
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/webinars/\$id/content-status';\s*Response res = await httpPostWithToken\(\s*url,\s*\{'item_id': itemId\.toString\(\), 'item': item\},\s*\);\s*var jsonRes = jsonDecode\(res\.body\);",
    toggle_replacement,
    content,
    flags=re.DOTALL
)

# 11. addFavorite
favorite_replacement = '''
      dio.Response res = await _courseApi.addFavorite({'item_id': courseId, 'item_name': isBundle ? 'bundle' : 'webinar'});
      var jsonRes = res.data;
'''
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/favorites/toggle';\s*Response res = await httpPostWithToken\(url, \{\s*'item_id': courseId\.toString\(\),\s*'item_name': isBundle \? 'bundle' : 'webinar'\s*\}\);\s*var jsonRes = jsonDecode\(res\.body\);",
    favorite_replacement,
    content,
    flags=re.DOTALL
)

# 12. getFreeCourse
free_replacement = '''
      dio.Response res = await _courseApi.getFreeCourse(id);
      var jsonRes = res.data;
'''
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/webinars/\$id/free';\s*Response res = await httpPostWithToken\(\s*url,\s*\{\},\s*isRedirectingStatusCode: false,\s*\);\s*var jsonRes = jsonDecode\(res\.body\);",
    free_replacement,
    content,
    flags=re.DOTALL
)

# 13. getContent
content_replacement = '''
      dio.Response res = await _courseApi.getContent(courseId);
      var jsonRes = res.data;
'''
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/webinars/\$courseId/content';\s*Response res = await httpGetWithToken\(url\);\s*var jsonRes = jsonDecode\(res\.body\);",
    content_replacement,
    content,
    flags=re.DOTALL
)

# 14. getContentJSON
content_json_replacement = '''
      dio.Response res = await _courseApi.getContent(courseId);
      var jsonRes = res.data;
'''
content = re.sub(
    r"String url = '\$\{Constants\.baseUrl\}panel/webinars/\$courseId/content';\s*Response res = await httpGetWithToken\(url\);\s*var jsonRes = jsonDecode\(res\.body\);",
    content_json_replacement,
    content,
    flags=re.DOTALL
)

# 15. getSingleContent
single_content_replacement = '''
      dio.Response res = await _courseApi.getSingleContent(url);
      var jsonRes = res.data;
'''
content = re.sub(
    r"String apiUrl = '\$\{Constants\.baseUrl\}panel/\$url';\s*Response res = await httpGetWithToken\(apiUrl\);\s*var jsonRes = jsonDecode\(res\.body\);",
    single_content_replacement,
    content,
    flags=re.DOTALL
)

# 16. getSingleContentJSON
single_content_json_replacement = '''
      dio.Response res = await _courseApi.getSingleContent(url);
      var jsonRes = res.data;
'''
content = re.sub(
    r"String apiUrl = '\$\{Constants\.baseUrl\}panel/\$url';\s*Response res = await httpGetWithToken\(apiUrl\);\s*var jsonRes = jsonDecode\(res\.body\);",
    single_content_json_replacement,
    content,
    flags=re.DOTALL
)

content = re.sub(r'import \'package:http/http.dart\';\n', '', content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
