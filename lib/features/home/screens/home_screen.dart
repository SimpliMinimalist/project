
import 'package:myapp/features/add_product/widgets/product_card.dart';
import 'package:myapp/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../providers/store_provider.dart';
import '../../add_product/widgets/add_product_fab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    // Determine the leading widget consistently
    Widget leadingContent;
    if (storeProvider.logo != null) {
      // If a logo exists, use it as the background for the CircleAvatar
      leadingContent = CircleAvatar(
        radius: 18, // Reduced radius
        backgroundImage: FileImage(storeProvider.logo!),
      );
    } else {
      // If no logo, show a default icon inside the CircleAvatar
      leadingContent = const CircleAvatar(
        radius: 18, // Reduced radius
        child: Icon(Icons.store),
      );
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0, // Closer title
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // Apply consistent padding to the wrapper
          child: leadingContent, // Use the consistently defined widget
        ),
        title: Text(
          storeProvider.storeName.isNotEmpty ? storeProvider.storeName : 'My Store',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/icons/search.svg',
                width: 24, height: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset('assets/icons/notification.svg',
                width: 24, height: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: productProvider.products.isEmpty
          ? const Center(
              child: Text('No products yet. Add one!'),
            )
          : ListView.builder(
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                final product = productProvider.products[index];
                return ProductCard(product: product);
              },
            ),
      floatingActionButton: const AddProductFab(),
    );
  }
}
