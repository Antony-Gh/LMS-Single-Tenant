import 'package:flutter/material.dart';
import 'package:esoi/app/models/blog_model.dart';

class BlogProvider extends ChangeNotifier {
  List<BlogModel> panelBlogs = [];
  List<dynamic> panelBlogComments = [];

  void setPanelBlogs(List<BlogModel> data) {
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
