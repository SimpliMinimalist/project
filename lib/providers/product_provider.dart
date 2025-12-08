import 'package:flutter/material.dart';
import 'package:myapp/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => _products;

  void addProduct(Product product) {
    _products.insert(0, product);
    notifyListeners();
  }
}
