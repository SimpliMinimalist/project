
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/product_provider.dart';
import 'package:myapp/features/add_product/models/product_model.dart';
import 'package:myapp/features/add_product/screens/add_product_screen.dart';

class DraftsPopup extends StatelessWidget {
  const DraftsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final draftProducts = Provider.of<ProductProvider>(context).drafts;

    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: const Color(0xFFF5F5F5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Drafts',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          if (draftProducts.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 32.0),
              child: Center(
                child: Text(
                  'You don’t have any drafts yet. Save up to 5 drafts to finish later',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: draftProducts.length,
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 8.0),
                itemBuilder: (context, index) {
                  final product = draftProducts[index];
                  return _buildDraftTile(context, product);
                },
              ),
            ),
          if (draftProducts.isNotEmpty) const SizedBox(height: 8.0),
        ],
      ),
    );
  }

  Widget _buildDraftTile(BuildContext context, Product product) {
    final formattedDate = product.savedAt != null
        ? DateFormat('d MMM, h:mm a').format(product.savedAt!)
        : 'No date';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          Navigator.of(context).pop(); // Close the popup first
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => AddProductScreen(product: product),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8.0),
                  image: product.images.isNotEmpty
                      ? DecorationImage(
                          image: FileImage(File(product.images.first)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: product.images.isEmpty
                    ? const Icon(Icons.image_outlined, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name.isNotEmpty ? product.name : 'Untitled Draft',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12.0),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  _showDeleteDraftConfirmation(context, product.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDraftConfirmation(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Draft'),
          content: const Text('Are you sure you want to delete this draft?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<ProductProvider>(context, listen: false)
                    .deleteProduct(productId);
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
