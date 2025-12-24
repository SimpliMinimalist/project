
import 'package:flutter/material.dart';
import 'package:myapp/features/add_product/models/product_variant_model.dart';
import 'package:myapp/shared/widgets/clearable_text_form_field.dart';

class EditVariantScreen extends StatefulWidget {
  final ProductVariant variant;

  const EditVariantScreen({super.key, required this.variant});

  @override
  State<EditVariantScreen> createState() => _EditVariantScreenState();
}

class _EditVariantScreenState extends State<EditVariantScreen> {
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late ProductVariant _editedVariant;

  @override
  void initState() {
    super.initState();
    _editedVariant = widget.variant.copyWith();
    _priceController = TextEditingController(text: _editedVariant.price.toStringAsFixed(2));
    _stockController = TextEditingController(text: _editedVariant.stock.toString());
  }

  @override
  void dispose() {
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final stock = int.tryParse(_stockController.text) ?? 0;
    _editedVariant = _editedVariant.copyWith(price: price, stock: stock);
    Navigator.of(context).pop(_editedVariant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editedVariant.name),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            GestureDetector(
              onTap: () {
                // TODO: Implement image picking
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: const Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
              ),
            ),
            const SizedBox(height: 24),
            // Attributes
            ..._editedVariant.attributes.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key, style: Theme.of(context).textTheme.titleMedium),
                    Text(entry.value, style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            ClearableTextFormField(
              controller: _priceController,
              labelText: 'Price',
              prefixText: '₹ ',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            // Inventory
            Text('Inventory', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Available'),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        int currentStock = int.tryParse(_stockController.text) ?? 0;
                        if (currentStock > 0) {
                          setState(() {
                            _stockController.text = (currentStock - 1).toString();
                          });
                        }
                      },
                    ),
                    SizedBox(
                      width: 50,
                      child: TextFormField(
                        controller: _stockController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        int currentStock = int.tryParse(_stockController.text) ?? 0;
                        setState(() {
                          _stockController.text = (currentStock + 1).toString();
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            // Shipping
            Row(
              children: [
                const Icon(Icons.local_shipping_outlined),
                const SizedBox(width: 8),
                Text('Shipping', style: Theme.of(context).textTheme.titleMedium),
              ],
            )
          ],
        ),
      ),
    );
  }
}
