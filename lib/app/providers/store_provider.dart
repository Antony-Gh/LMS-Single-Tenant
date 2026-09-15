import 'package:flutter/material.dart';
import 'package:esoi/app/models/store_product_model.dart';
import 'package:esoi/app/models/sales_model.dart';

class StoreProvider extends ChangeNotifier {
  List<StoreProductModel> products = [];
  List<Sales> sales = [];
  List<Sales> purchases = [];

  void setProducts(List<StoreProductModel> data) {
    products = data;
    notifyListeners();
  }

  void setSales(List<Sales> data) {
    sales = data;
    notifyListeners();
  }

  void setPurchases(List<Sales> data) {
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
