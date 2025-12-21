
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myapp/features/add_product/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isSelected;

  const ProductCard({
    super.key,
    required this.product,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor = isSelected
        ? Theme.of(context).primaryColor.withAlpha(25) // 10% opacity
        : Colors.white;

    return Card(
      elevation: 0.0,
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey.shade300,
                  ),
                  child: product.images.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            File(product.images.first),
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.image, size: 40, color: Colors.grey),
                ),
                if (isSelected)
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(128), // 50% opacity
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  if (product.categories.isNotEmpty)
                    Text(
                      product.categories.first,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  else
                    Text(
                      'Category not assigned',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (product.stock != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Stock: ${product.stock}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
