
import 'dart:io';
import 'package:flutter/material.dart';

class StoreProvider with ChangeNotifier {
  File? _logo;
  String _storeName = '';

  File? get logo => _logo;
  String get storeName => _storeName;

  void setStore(File? logo, String storeName) {
    _logo = logo;
    _storeName = storeName;
    notifyListeners();
  }
}
