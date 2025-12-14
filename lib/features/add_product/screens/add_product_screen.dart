
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:myapp/features/add_product/models/product_model.dart';
import 'package:myapp/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/shared/widgets/clearable_text_form_field.dart';
import 'package:myapp/features/add_product/widgets/drafts_popup.dart';

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
  final _salePriceController = TextEditingController();
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
      _descriptionController.text = widget.product!.description ?? '';
      _priceController.text = widget.product!.price.toString();
      _salePriceController.text = widget.product!.salePrice?.toString() ?? '';
      _stockController.text = widget.product!.stock?.toString() ?? '';
      _images.addAll(widget.product!.images.map((path) => XFile(path)));
    }
    _productNameController.addListener(_onFormChanged);
    _priceController.addListener(_onFormChanged);
    _salePriceController.addListener(_onFormChanged);
    _stockController.addListener(_onFormChanged);
    _descriptionController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _productNameController.removeListener(_onFormChanged);
    _priceController.removeListener(_onFormChanged);
    _salePriceController.removeListener(_onFormChanged);
    _stockController.removeListener(_onFormChanged);
    _descriptionController.removeListener(_onFormChanged);
    _productNameController.dispose();
    _priceController.dispose();
    _salePriceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    setState(() {
      // This is just to trigger a rebuild and update the PopScope
    });
  }

  bool _isFormModified() {
    if (widget.product == null) {
      return _productNameController.text.isNotEmpty ||
          _priceController.text.isNotEmpty ||
          _salePriceController.text.isNotEmpty ||
          _stockController.text.isNotEmpty ||
          _descriptionController.text.isNotEmpty ||
          _images.isNotEmpty;
    } else {
      final currentProduct = Product(
        id: _initialProduct!.id,
        name: _productNameController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        salePrice: double.tryParse(_salePriceController.text),
        stock: int.tryParse(_stockController.text),
        images: _images.map((image) => image.path).toList(),
      );
      return !_initialProduct!.equals(currentProduct);
    }
  }

  Future<void> _showSaveDraftDialog() async {
    final navigator = Navigator.of(context);
    if (!_isFormModified()) {
      navigator.pop();
      return;
    }

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save changes?'),
        content: const Text('Do you want to save this product as a draft?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop('discard'),
            child: const Text('Discard'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop('continue'),
            child: const Text('Continue editing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop('save'),
            child: const Text('Save as Draft'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (result == 'save') {
      _saveDraft();
      Navigator.of(context).pop();
    } else if (result == 'discard') {
      Navigator.of(context).pop();
    }
  }


  void _saveDraft() {
    final stockValue = int.tryParse(_stockController.text);
    final salePriceValue = double.tryParse(_salePriceController.text);
    final priceValue = double.tryParse(_priceController.text) ?? 0.0;

    final draftProduct = Product(
      id: widget.product?.id ?? const Uuid().v4(),
      name: _productNameController.text,
      description: _descriptionController.text,
      price: priceValue,
      salePrice: salePriceValue,
      stock: stockValue,
      images: _images.map((image) => image.path).toList(),
      isDraft: true,
    );

    Provider.of<ProductProvider>(context, listen: false).saveDraft(draftProduct);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product saved as draft!')),
      );
    }
  }

  void _showDraftsPopup() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [DraftsPopup()],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }


  void _attemptSave() {
    if (_formKey.currentState!.validate()) {
      final stockValue = int.tryParse(_stockController.text);
      final salePriceValue = double.tryParse(_salePriceController.text);
      final navigator = Navigator.of(context);

      if (widget.product == null || widget.product!.isDraft) {
        // Add new product or update from draft
        final newProduct = Product(
          id: widget.product?.id ?? const Uuid().v4(),
          name: _productNameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          salePrice: salePriceValue,
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
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          salePrice: salePriceValue,
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
      if (mounted) {
        navigator.pop();
      }
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
                if (mounted) {
                    navigator.pop();
                    messenger.showSnackBar(
                    const SnackBar(content: Text('Product deleted successfully!')),
                    );
                }
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
    final isEditing = widget.product != null && !widget.product!.isDraft;
    final isDraft = widget.product != null && widget.product!.isDraft;

    return PopScope(
      canPop: !_isFormModified(),
      onPopInvokedWithResult: (bool didPop, bool? result) async {
        if (didPop) {
          return;
        }
        _showSaveDraftDialog();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _showSaveDraftDialog,
          ),
          title: Text(
            isEditing ? 'Edit Product' : (isDraft ? 'Edit Draft' : 'New Product'),
            style: titleTextStyle?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: (titleTextStyle.fontSize ?? 22.0) - 1.0,
            ),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset('assets/icons/draft_products.svg', width: 24, height: 24),
              onPressed: _showDraftsPopup,
            ),
          ],
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
                ClearableTextFormField(
                  controller: _productNameController,
                  labelText: 'Product Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                ClearableTextFormField(
                  controller: _priceController,
                  labelText: 'Price',
                  prefixText: '₹ ',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                ClearableTextFormField(
                  controller: _salePriceController,
                  labelText: 'Sale Price',
                  prefixText: '₹ ',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                   autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                ClearableTextFormField(
                  controller: _stockController,
                  labelText: 'Stock',
                  keyboardType: TextInputType.number,
                   validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        int.tryParse(value) == null) {
                      return 'Please enter a valid integer';
                    }
                    return null;
                  },
                   autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                ClearableTextFormField(
                  controller: _descriptionController,
                  labelText: 'Description',
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
                if (isEditing || isDraft)
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
                if (isEditing || isDraft)
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
                backgroundColor: Colors.white,
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
        : Colors.white;

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
        description == other.description &&
        price == other.price &&
        salePrice == other.salePrice &&
        stock == other.stock &&
        listEquals.equals(images, other.images);
  }
}
