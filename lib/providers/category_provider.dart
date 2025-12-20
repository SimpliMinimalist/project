
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  final List<String> _categories = [];
  String _selectedCategory = 'All';

  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;

  void addCategory(String category) {
    if (category.isNotEmpty && !_categories.contains(category)) {
      _categories.add(category);
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
