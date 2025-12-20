
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
  final _imageFieldKey = GlobalKey<FormFieldState<List<XFile>>>();
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];
  int _activePage = 0;

  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descriptionController = TextEditingController();

  Product? _initialProduct;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _loadProductData(widget.product!);
    } else {
      // When creating a new product, clear any lingering selection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ProductProvider>(context, listen: false).clearSelection();
      });
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
    setState(() {});
  }

  void _loadProductData(Product product) {
    _initialProduct = product.copyWith();
    _productNameController.text = product.name;
    _descriptionController.text = product.description ?? '';

    if (product.isDraft && product.price == 0.0) {
      _priceController.text = '';
    } else {
      _priceController.text = product.price.toString();
    }

    _salePriceController.text = product.salePrice?.toString() ?? '';
    _stockController.text = product.stock?.toString() ?? '';
    _images.clear();
    _images.addAll(product.images.map((path) => XFile(path)));

    // Also update the provider with the loaded draft's ID
    Provider.of<ProductProvider>(context, listen: false).setSelectedDraftId(product.id);

    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.validate();
    });
  }

  bool _isFormModified() {
    if (_initialProduct == null) {
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
        isDraft: _initialProduct!.isDraft,
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

    final isEditingDraft = _initialProduct != null && _initialProduct!.isDraft;
    final isNewProduct = _initialProduct == null;

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        if (isEditingDraft) {
          // Editing an existing draft
          return AlertDialog(
            title: const Text('Save changes?'),
            content: const Text('Do you want to save the changes to this draft?'),
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
                child: const Text('Save'),
              ),
            ],
          );
        } else if (isNewProduct) {
          // Creating a new product
          return AlertDialog(
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
          );
        } else {
          // Editing a published product
          return AlertDialog(
            title: const Text('Discard changes?'),
            content: const Text('You have unsaved changes. Are you sure you want to discard them?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop('continue'),
                child: const Text('Continue editing'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop('discard'),
                child: const Text('Discard'),
              ),
            ],
          );
        }
      },
    );

    if (!mounted) return;

    if (result == 'save') {
      final bool didSave = _saveDraft();
      if (didSave) {
        Navigator.of(context).pop();
      }
    } else if (result == 'discard') {
      Provider.of<ProductProvider>(context, listen: false).clearSelection();
      Navigator.of(context).pop();
    }
  }

  bool _saveDraft() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    if (productProvider.drafts.length >= 5 &&
        (_initialProduct == null || !_initialProduct!.isDraft)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Drafts Limit Reached'),
          content: const Text('You can only save up to 5 drafts. Please delete an existing draft to save a new one.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return false;
    }

    final stockValue = int.tryParse(_stockController.text);
    final salePriceValue = double.tryParse(_salePriceController.text);
    final priceValue = double.tryParse(_priceController.text) ?? 0.0;

    final draftProduct = Product(
      id: _initialProduct?.id ?? const Uuid().v4(),
      name: _productNameController.text,
      description: _descriptionController.text,
      price: priceValue,
      salePrice: salePriceValue,
      stock: stockValue,
      images: _images.map((image) => image.path).toList(),
      isDraft: true,
    );

    productProvider.saveDraft(draftProduct);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product saved as draft!')),
      );
    }
    return true;
  }

  void _showDraftsPopup() async {
    final isFormModified = _isFormModified();
    final selectedDraft = await showGeneralDialog<Product>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withAlpha(102),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DraftsPopup(isFormModified: isFormModified),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
    );

    if (selectedDraft != null && mounted) {
      _loadProductData(selectedDraft);
    }
  }

  void _attemptSave() {
    if (_formKey.currentState!.validate()) {
      final stockValue = int.tryParse(_stockController.text);
      final salePriceValue = double.tryParse(_salePriceController.text);
      final navigator = Navigator.of(context);
      final productProvider = Provider.of<ProductProvider>(context, listen: false);

      if (_initialProduct == null || _initialProduct!.isDraft) {
        final newProduct = Product(
          id: _initialProduct?.id ?? const Uuid().v4(),
          name: _productNameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          salePrice: salePriceValue,
          stock: stockValue,
          images: _images.map((image) => image.path).toList(),
        );
        productProvider.addProduct(newProduct);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added successfully!')),
          );
        }
      } else {
        final updatedProduct = Product(
          id: _initialProduct!.id,
          name: _productNameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          salePrice: salePriceValue,
          stock: stockValue,
          images: _images.map((image) => image.path).toList(),
        );
        productProvider.updateProduct(updatedProduct);
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
      _imageFieldKey.currentState?.validate();
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      if (_images.isNotEmpty && _activePage >= _images.length) {
        _activePage = _images.length - 1;
      }
    });
    _imageFieldKey.currentState?.validate();
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
                productProvider.deleteProduct(_initialProduct!.id);
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
    final isEditing = _initialProduct != null && !_initialProduct!.isDraft;
    final isDraft = _initialProduct != null && _initialProduct!.isDraft;

    return PopScope(
      canPop: !_isFormModified(),
      onPopInvokedWithResult: (bool didPop, bool? result) async {
        if (didPop) {
          Provider.of<ProductProvider>(context, listen: false).clearSelection();
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
            if (!isEditing) // Show drafts icon only when not editing a published product
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
                  key: _imageFieldKey,
                  initialValue: _images,
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
                if (isEditing) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _attemptSave,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Text(isEditing
                        ? 'Update Product'
                        : (isDraft ? 'Add Product' : 'Add Product')), // Changed label for drafts
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
