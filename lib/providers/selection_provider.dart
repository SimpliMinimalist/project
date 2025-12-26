import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_provider.dart';

class SelectionProvider with ChangeNotifier {
  final Set<String> _selectedProducts = {};
  bool _isSelectionMode = false;

  Set<String> get selectedProducts => _selectedProducts;
  bool get isSelectionMode => _isSelectionMode;

  void toggleSelection(String productId) {
    if (_selectedProducts.contains(productId)) {
      _selectedProducts.remove(productId);
      if (_selectedProducts.isEmpty) {
        _isSelectionMode = false;
      }
    } else {
      _selectedProducts.add(productId);
      _isSelectionMode = true;
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedProducts.clear();
    _isSelectionMode = false;
    notifyListeners();
  }

  void deleteSelectedProducts(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Delete \${_selectedProducts.length} Product(s)'),
          content:
              const Text('Are you sure you want to delete the selected products?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                for (String id in _selectedProducts) {
                  productProvider.deleteProduct(id);
                }
                clearSelection();
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
