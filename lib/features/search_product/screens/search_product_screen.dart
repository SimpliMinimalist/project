
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/add_product/widgets/product_card.dart';
import 'package:myapp/features/add_product/models/product_model.dart';
import 'package:myapp/providers/product_provider.dart';
import 'package:myapp/shared/widgets/custom_search_bar.dart';
import 'package:provider/provider.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];
  late final ProductProvider _productProvider;

  @override
  void initState() {
    super.initState();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _filteredProducts = _productProvider.products;
  }

  void _filterProducts(String searchTerm) {
    setState(() {
      if (searchTerm.isNotEmpty) {
        _filteredProducts = _productProvider.products
            .where(
                (product) => product.name.toLowerCase().contains(searchTerm.toLowerCase()))
            .toList();
      } else {
        _filteredProducts = _productProvider.products;
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.pop();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                CustomSearchBar(
                  controller: _searchController,
                  hintText: 'Search Products',
                  onChanged: _filterProducts,
                  onClear: () {
                    _searchController.clear();
                    _filterProducts('');
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _filteredProducts.isEmpty
                      ? Center(
                          child: Text(_searchController.text.isNotEmpty
                              ? 'No products found.'
                              : 'No products available.'),
                        )
                      : ListView.builder(
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            return InkWell(
                              onTap: () {
                                context.push('/edit-product', extra: product);
                              },
                              child: ProductCard(product: product),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
