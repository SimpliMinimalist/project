
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/add_product/widgets/product_card.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/providers/product_provider.dart';
import 'package:provider/provider.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isTyping = false;
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    _filteredProducts = productProvider.products;
    _searchController.addListener(() {
      setState(() {
        _isTyping = _searchController.text.isNotEmpty;
        _filteredProducts = productProvider.products
            .where((product) => product.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      });
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SearchBar(
                  constraints: const BoxConstraints(minHeight: 52, maxHeight: 52),
                  controller: _searchController,
                  hintText: 'Search Products',
                  elevation: WidgetStateProperty.all(0.0),
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  )),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  trailing: _isTyping
                      ? [
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        ]
                      : null,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _filteredProducts.isEmpty
                      ? Center(
                          child: Text(_isTyping
                              ? 'No products found.'
                              : 'Search for products to see results.'),
                        )
                      : ListView.builder(
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            return InkWell(
                              onTap: () {
                                context.go('/edit-product', extra: product);
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
