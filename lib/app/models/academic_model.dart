class AcademicLevelModel {
  int? id;
  int? academicYearId;
  String? name;
  int? gradeOrder;

  AcademicLevelModel({this.id, this.academicYearId, this.name, this.gradeOrder});

  AcademicLevelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    academicYearId = json['academic_year_id'];
    name = json['name'];
    gradeOrder = json['grade_order'];
  }
}

class AcademicYearModel {
  int? id;
  String? name;
  bool? isActive;

  AcademicYearModel({this.id, this.name, this.isActive});

  AcademicYearModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['is_active'] == true || json['is_active'] == 1;
  }
}
