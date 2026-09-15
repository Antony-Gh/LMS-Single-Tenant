import 'package:flutter/material.dart';
import 'package:esoi/app/models/content_model.dart';

class WebinarProvider extends ChangeNotifier {
  List<dynamic> panelWebinars = [];
  List<ContentModel> panelWebinarChapters = [];
  List<dynamic> personalNotes = [];

  void setPanelWebinars(List<dynamic> data) {
    panelWebinars = data;
    notifyListeners();
  }

  void setPanelWebinarChapters(List<ContentModel> data) {
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
