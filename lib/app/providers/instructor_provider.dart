import 'package:flutter/material.dart';

class InstructorProvider extends ChangeNotifier {
  List<dynamic> bundles = [];
  List<dynamic> meetings = [];
  List<dynamic> quizzes = [];

  void setBundles(List<dynamic> data) {
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
