
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:uuid/uuid.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;

  const AddProductScreen({
    super.key,
    this.product,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];
  int _activePage = 0;

  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descriptionController = TextEditingController();

  // For tracking changes
  Product? _initialProduct;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _initialProduct = widget.product!.copyWith();
      _productNameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.stock?.toString() ?? '';
      _images.addAll(widget.product!.images.map((path) => XFile(path)));
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool _isFormModified() {
    if (widget.product == null) {
      return _productNameController.text.isNotEmpty ||
          _priceController.text.isNotEmpty ||
          _stockController.text.isNotEmpty ||
          _descriptionController.text.isNotEmpty ||
          _images.isNotEmpty;
    } else {
      final currentProduct = Product(
        id: _initialProduct!.id,
        name: _productNameController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        stock: int.tryParse(_stockController.text),
        images: _images.map((image) => image.path).toList(),
      );
      return !_initialProduct!.equals(currentProduct);
    }
  }

  Future<bool> _showDiscardDialog() async {
    if (!_isFormModified()) {
      return true;
    }

    final navigator = Navigator.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('You have unsaved changes. Are you sure you want to discard them?'),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(false),
            child: const Text('Continue editing'),
          ),
          TextButton(
            onPressed: () => navigator.pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _attemptSave() {
    if (_formKey.currentState!.validate()) {
      final stockValue = _stockController.text.isNotEmpty ? int.parse(_stockController.text) : null;
      final navigator = Navigator.of(context);

      if (widget.product == null) {
        // Add new product
        final newProduct = Product(
          id: const Uuid().v4(),
          name: _productNameController.text,
          price: double.parse(_priceController.text),
          stock: stockValue,
          images: _images.map((image) => image.path).toList(),
        );
        Provider.of<ProductProvider>(context, listen: false).addProduct(newProduct);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added successfully!')),
          );
        }
      } else {
        // Update existing product
        final updatedProduct = Product(
          id: widget.product!.id,
          name: _productNameController.text,
          price: double.parse(_priceController.text),
          stock: stockValue,
          images: _images.map((image) => image.path).toList(),
        );
        Provider.of<ProductProvider>(context, listen: false).updateProduct(updatedProduct);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product updated successfully!')),
          );
        }
      }
      navigator.pop();
    }
  }

  Future<void> _pickImages() async {
    final messenger = ScaffoldMessenger.of(context);
    if (_images.length >= 10) {
      messenger.showSnackBar(
        const SnackBar(content: Text('You can only select up to 10 images.')),
      );
      return;
    }

    final List<XFile> pickedFiles = await _picker.pickMultiImage(
      limit: 10 - _images.length,
    );

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      if (_images.isNotEmpty && _activePage >= _images.length) {
        _activePage = _images.length - 1;
      }
    });
  }

  void _showDeleteConfirmationDialog() {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () => navigator.pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                productProvider.deleteProduct(widget.product!.id);
                navigator.pop();
                navigator.pop();
                messenger.showSnackBar(
                  const SnackBar(content: Text('Product deleted successfully!')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = Theme.of(context).textTheme.titleLarge;
    final isEditing = widget.product != null;

    return PopScope(
      canPop: !_isFormModified(),
      onPopInvokedWithResult: (bool didPop, bool? result) async {
        if (didPop) {
          return;
        }
        final navigator = Navigator.of(context);
        final bool shouldPop = await _showDiscardDialog();
        if (shouldPop) {
          navigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final shouldPop = await _showDiscardDialog();
              if (shouldPop) {
                navigator.pop();
              }
            },
          ),
          title: Text(
            isEditing ? 'Edit Product' : 'New Product',
            style: titleTextStyle?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: (titleTextStyle.fontSize ?? 22.0) - 1.0,
            ),
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormField<List<XFile>>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (_images.isEmpty) {
                      return 'Please select at least one image.';
                    }
                    return null;
                  },
                  builder: (formFieldState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _images.isEmpty
                            ? _buildAddPhotoImage(formFieldState.hasError)
                            : _buildImageCarousel(),
                        if (formFieldState.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                            child: Text(
                              formFieldState.errorText!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _productNameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                    prefixText: '₹ ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Sale Price',
                    border: OutlineInputBorder(),
                    prefixText: '₹ ',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Transform.translate(
          offset: const Offset(0, -7),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (isEditing)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showDeleteConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black87,
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
                if (isEditing)
                  const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _attemptSave,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Text(isEditing ? 'Update Product' : 'Add Product'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.0,
          child: CarouselSlider.builder(
            itemCount: _images.length,
            itemBuilder: (context, index, realIndex) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        File(_images[index].path),
                        fit: BoxFit.cover,
                      ),
                      // Image counter
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(128),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            '${index + 1}/${_images.length}',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                      // Delete button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(128),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.delete_outline, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _activePage = index;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_images.length > 1)
          Center(
            child: AnimatedSmoothIndicator(
              activeIndex: _activePage,
              count: _images.length,
              effect: ScrollingDotsEffect(
                dotHeight: 6,
                dotWidth: 6,
                activeDotColor: Theme.of(context).primaryColor,
                dotColor: Colors.grey,
                maxVisibleDots: 5,
              ),
            ),
          ),
        const SizedBox(height: 12),
        if (_images.length < 10)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.add_a_photo_outlined),
              label: const Text('Add More Photos'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                elevation: 0,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddPhotoImage(bool hasError) {
    final backgroundColor = hasError
        ? Theme.of(context).colorScheme.error.withAlpha(25)
        : Colors.grey.shade200;

    return AspectRatio(
      aspectRatio: 1 / 1,
      child: InkWell(
        onTap: _pickImages,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo_outlined,
                  size: 64,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(height: 16),
                Text(
                  'Add up to 10 Photos',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension ProductEquals on Product {
  bool equals(Product other) {
    const listEquals = ListEquality();
    return id == other.id &&
        name == other.name &&
        price == other.price &&
        stock == other.stock &&
        listEquals.equals(images, other.images);
  }
}
