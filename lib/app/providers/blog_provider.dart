import 'package:flutter/material.dart';

class BlogProvider extends ChangeNotifier {
  List<dynamic> panelBlogs = [];
  List<dynamic> panelBlogComments = [];

  void setPanelBlogs(List<dynamic> data) {
    panelBlogs = data;
    notifyListeners();
  }

  void setPanelBlogComments(List<dynamic> data) {
    panelBlogComments = data;
    notifyListeners();
  }

  void clearAll() {
    panelBlogs.clear();
    panelBlogComments.clear();
    notifyListeners();
  }
}
