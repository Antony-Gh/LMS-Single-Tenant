import 'package:esoi/common/utils/app_text.dart';

String roleTranslator(String role) {
  Map<String, String> data = {
    'student': appText.student,
    'teacher': appText.teacher,
    'admin': appText.admin
  };

  return data[role.toLowerCase()] ?? '';
}
