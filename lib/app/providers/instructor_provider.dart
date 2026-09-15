import 'package:flutter/material.dart';
import 'package:esoi/app/models/bundle_model.dart';

class InstructorProvider extends ChangeNotifier {
  List<BundleModel> bundles = [];
  List<dynamic> meetings = [];
  List<dynamic> quizzes = [];

  void setBundles(List<BundleModel> data) {
    bundles = data;
    notifyListeners();
  }

  void setMeetings(List<dynamic> data) {
    meetings = data;
    notifyListeners();
  }

  void setQuizzes(List<dynamic> data) {
    quizzes = data;
    notifyListeners();
  }

  void clearAll() {
    bundles.clear();
    meetings.clear();
    quizzes.clear();
    notifyListeners();
  }
}
