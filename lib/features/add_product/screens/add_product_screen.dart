
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];
  int _activePage = 0;

  Future<void> _pickImages() async {
    if (_images.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
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

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = Theme.of(context).textTheme.titleLarge;
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        leadingWidth: 100,
        title: Text(
          'Product',
          style: titleTextStyle?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: (titleTextStyle.fontSize ?? 22.0) - 1.0,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product added successfully!')),
                );
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'Save',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormField<List<XFile>>(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select at least one image.';
                  }
                  return null;
                },
                initialValue: _images,
                builder: (formFieldState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _images.isEmpty
                          ? _buildAddPhotoImage(formFieldState.hasError)
                          : _buildImageCarousel(),
                      if (formFieldState.hasError && _images.isEmpty)
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
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
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
                decoration: const InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
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
              enableInfiniteScroll: true,
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
                dotHeight: 8,
                dotWidth: 8,
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
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
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
      aspectRatio: 1.0,
      child: InkWell(
        onTap: _pickImages,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
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
    );
  }
}
