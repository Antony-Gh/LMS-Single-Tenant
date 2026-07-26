import 'dart:convert';

import 'package:esoi/app/models/academic_model.dart';
import 'package:esoi/common/utils/constants.dart';
import 'package:esoi/common/utils/http_handler.dart';

class AcademicService {
  static Future<List<AcademicLevelModel>> levels() async {
    try {
      final res = await httpGet('${Constants.baseUrl}academic/levels');
      final jsonResponse = jsonDecode(res.body);
      final items = (jsonResponse['data'] ?? []) as List<dynamic>;

      return items.map((item) => AcademicLevelModel.fromJson(item)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<AcademicYearModel?> currentYear() async {
    try {
      final res = await httpGet('${Constants.baseUrl}academic/current-year');
      final jsonResponse = jsonDecode(res.body);
      final data = jsonResponse['data'];

      return data == null ? null : AcademicYearModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }
}
