import 'package:flutter/material.dart';

class WebinarProvider extends ChangeNotifier {
  List<dynamic> panelWebinars = [];
  List<dynamic> panelWebinarChapters = [];
  List<dynamic> personalNotes = [];

  void setPanelWebinars(List<dynamic> data) {
    panelWebinars = data;
    notifyListeners();
  }

  void setPanelWebinarChapters(List<dynamic> data) {
    panelWebinarChapters = data;
    notifyListeners();
  }

  void setPersonalNotes(List<dynamic> data) {
    personalNotes = data;
    notifyListeners();
  }

  void clearAll() {
    panelWebinars.clear();
    panelWebinarChapters.clear();
    personalNotes.clear();
    notifyListeners();
  }
}
