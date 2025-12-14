import 'package:flutter/material.dart';
import 'package:myapp/features/add_product/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => _products.where((p) => !p.isDraft).toList();
  List<Product> get drafts => _products.where((p) => p.isDraft).toList();

  void addProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    final newProduct = product.copyWith(isDraft: false, savedAt: DateTime.now());
    if (index != -1) {
      _products[index] = newProduct;
    } else {
      _products.insert(0, newProduct);
    }
    notifyListeners();
  }

  void saveDraft(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    final newDraft = product.copyWith(isDraft: true, savedAt: DateTime.now());
    if (index != -1) {
      _products[index] = newDraft;
    } else {
      _products.insert(0, newDraft);
    }
    notifyListeners();
  }

  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product.copyWith(savedAt: DateTime.now());
      notifyListeners();
    }
  }

  void deleteProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }
}
