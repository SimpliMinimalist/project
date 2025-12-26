
import 'package:flutter/material.dart';
import 'package:myapp/providers/category_provider.dart';
import 'package:provider/provider.dart';

void showAddCategoryBottomSheet(BuildContext context) {
  final TextEditingController categoryController = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add New Category',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category name';
                  }
                  if (Provider.of<CategoryProvider>(context, listen: false)
                      .categories
                      .contains(value)) {
                    return 'This category already exists';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Provider.of<CategoryProvider>(context, listen: false)
                        .addCategory(categoryController.text);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Add Category'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}
