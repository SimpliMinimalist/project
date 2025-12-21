
import 'package:flutter/material.dart';
import 'package:myapp/providers/category_provider.dart';
import 'package:provider/provider.dart';

void showAddCategoryBottomSheet(BuildContext context) {
  final categoryController = TextEditingController();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                final categoryName = categoryController.text.trim();
                if (categoryName.isNotEmpty) {
                  Provider.of<CategoryProvider>(context, listen: false)
                      .addCategory(categoryName);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Category'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}
