
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/providers/category_provider.dart';
import 'package:provider/provider.dart';

void showAddCategoryBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return const AddCategoryBottomSheet();
    },
  );
}

class AddCategoryBottomSheet extends StatefulWidget {
  const AddCategoryBottomSheet({super.key});

  @override
  State<AddCategoryBottomSheet> createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  final _categoryController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _categoryController.addListener(() {
      setState(() {
        _isButtonEnabled = _categoryController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  void _addCategory() {
    final categoryName = _categoryController.text.trim();
    if (categoryName.isNotEmpty) {
      Provider.of<CategoryProvider>(context, listen: false)
          .addCategory(categoryName);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            controller: _categoryController,
            decoration: InputDecoration(
              labelText: 'Category Name',
              suffixIcon: _isButtonEnabled
                  ? IconButton(
                      icon: SvgPicture.asset('assets/icons/cancel.svg'),
                      onPressed: () {
                        _categoryController.clear();
                      },
                    )
                  : null,
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: _isButtonEnabled ? _addCategory : null,
            child: const Text('Add Category'),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
