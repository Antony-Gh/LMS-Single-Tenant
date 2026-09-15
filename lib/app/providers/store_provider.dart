import 'package:flutter/material.dart';

class StoreProvider extends ChangeNotifier {
  List<dynamic> products = [];
  List<dynamic> sales = [];
  List<dynamic> purchases = [];

  void setProducts(List<dynamic> data) {
    products = data;
    notifyListeners();
  }

  void setSales(List<dynamic> data) {
    sales = data;
    notifyListeners();
  }

  void setPurchases(List<dynamic> data) {
    purchases = data;
    notifyListeners();
  }

  void clearAll() {
    products.clear();
    sales.clear();
    purchases.clear();
    notifyListeners();
  }
}
