
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddProductFab extends StatelessWidget {
  const AddProductFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.push('/add-product');
      },
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Adjust for more or less rounded corners
      ),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
