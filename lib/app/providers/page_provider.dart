import 'package:flutter/material.dart';
import 'package:esoi/app/pages/main_page/home_page/home_page.dart';
import 'package:esoi/common/enums/page_name_enum.dart';

import '../pages/main_page/classes_page/classes_page.dart';

class PageProvider extends ChangeNotifier {
  PageNames page = PageNames.home;

  Map<PageNames, Widget> pages = {
    PageNames.home: const HomePage(),
    PageNames.myClasses: const ClassesPage(),
  };

  setPage(PageNames data, {bool emit = true}) {
    page = data;
    if (emit) {
      notifyListeners();
    }
  }
}
