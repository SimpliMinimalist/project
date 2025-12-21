
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/add_product/models/product_model.dart';
import 'package:myapp/features/add_product/screens/add_product_screen.dart';
import 'package:myapp/features/home/widgets/add_category_bottom_sheet.dart';
import 'package:myapp/providers/category_provider.dart';
import 'package:provider/provider.dart';

import '../../../providers/product_provider.dart';
import '../../../providers/store_provider.dart';
import '../../add_product/widgets/add_product_fab.dart';
import '../../add_product/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;
  bool _isSelectionMode = false;
  final Set<String> _selectedProducts = {};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (_isSelectionMode) return false;
    if (notification is ScrollUpdateNotification) {
      final direction = _scrollController.position.userScrollDirection;
      final scrollDelta = notification.scrollDelta ?? 0;
      const threshold = 5.0;

      if (direction == ScrollDirection.reverse && scrollDelta.abs() > threshold) {
        if (_isFabVisible) _updateFab(false);
      } else if (direction == ScrollDirection.forward && scrollDelta.abs() > threshold) {
        if (!_isFabVisible) _updateFab(true);
      }
    } else if (notification is ScrollEndNotification) {
      if (notification.metrics.atEdge) {
        _updateFab(true);
      }
    }
    return false;
  }

  void _updateFab(bool visible) {
    if (_isFabVisible == visible) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _isFabVisible = visible);
    });
  }

  void _toggleSelection(String productId) {
    setState(() {
      if (_selectedProducts.contains(productId)) {
        _selectedProducts.remove(productId);
        if (_selectedProducts.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedProducts.add(productId);
        _isSelectionMode = true;
      }
    });
  }

  void _deleteSelectedProducts() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Delete ${_selectedProducts.length} Product(s)'),
          content: const Text('Are you sure you want to delete the selected products?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                for (String id in _selectedProducts) {
                  productProvider.deleteProduct(id);
                }
                setState(() {
                  _selectedProducts.clear();
                  _isSelectionMode = false;
                });
                Navigator.of(dialogContext).pop();
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
    final storeProvider = Provider.of<StoreProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    final List<Product> filteredProducts;
    if (categoryProvider.selectedCategory == 'All') {
      filteredProducts = productProvider.products;
    } else {
      filteredProducts = productProvider.products
          .where((p) => p.categories.contains(categoryProvider.selectedCategory))
          .toList();
    }

    Widget leadingContent;
    if (storeProvider.logo != null && !_isSelectionMode) {
      leadingContent = CircleAvatar(
        radius: 18,
        backgroundImage: FileImage(storeProvider.logo!),
      );
    } else if (_isSelectionMode) {
      leadingContent = IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          setState(() {
            _isSelectionMode = false;
            _selectedProducts.clear();
          });
        },
      );
    } else {
      leadingContent = const CircleAvatar(
        radius: 18,
        child: Icon(Icons.store),
      );
    }

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: _isSelectionMode,
              titleSpacing: 0,
              leading: leadingContent,
              title: _isSelectionMode
                  ? Text('${_selectedProducts.length} selected')
                  : Text(
                      storeProvider.storeName.isNotEmpty
                          ? storeProvider.storeName
                          : 'My Store',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              actions: _isSelectionMode
                  ? [
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: _deleteSelectedProducts,
                      ),
                    ]
                  : [
                      IconButton(
                        icon: SvgPicture.asset('assets/icons/search.svg',
                            width: 24, height: 24),
                        onPressed: () => context.push('/search'),
                      ),
                      IconButton(
                        icon: SvgPicture.asset('assets/icons/notification.svg',
                            width: 24, height: 24),
                        onPressed: () => context.push('/orders'),
                      ),
                      IconButton(
                        icon: SvgPicture.asset('assets/icons/profile.svg',
                            width: 24, height: 24),
                        onPressed: () {},
                      ),
                    ],
            ),
            SliverToBoxAdapter(
              child: _buildCategoryFilters(),
            ),
            filteredProducts.isEmpty
                ? const SliverFillRemaining(
                    child: Center(
                      child: Text('No products yet. Add one!'),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = filteredProducts[index];
                          final isSelected = _selectedProducts.contains(product.id);
                          return GestureDetector(
                            onTap: () {
                              if (_isSelectionMode) {
                                _toggleSelection(product.id);
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddProductScreen(product: product),
                                  ),
                                );
                              }
                            },
                            onLongPress: () {
                              _toggleSelection(product.id);
                            },
                            child: ProductCard(
                              product: product,
                              isSelected: isSelected,
                            ),
                          );
                        },
                        childCount: filteredProducts.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _isSelectionMode
            ? const SizedBox.shrink()
            : (_isFabVisible ? const AddProductFab() : const SizedBox.shrink()),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final allCategories = ['All', ...categoryProvider.categories];

        return SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: allCategories.length + 1, // +1 for the add button
            itemBuilder: (context, index) {
              if (index == allCategories.length) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ActionChip(
                    label: const Icon(Icons.add),
                    onPressed: () => showAddCategoryBottomSheet(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: const EdgeInsets.all(8),
                  ),
                );
              }

              final category = allCategories[index];
              final isSelected = category == categoryProvider.selectedCategory;

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  showCheckmark: false,
                  onSelected: (selected) {
                    if (selected) {
                      categoryProvider.selectCategory(category);
                    }
                  },
                  backgroundColor: isSelected
                      ? Theme.of(context).primaryColor.withAlpha(25)
                      : Colors.grey[200],
                  selectedColor: Theme.of(context).primaryColor.withAlpha(51),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300]!,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
