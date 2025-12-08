
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final position = _scrollController.position;

    // Always show FAB at the top or bottom & stop processing to prevent flickering
    if (position.atEdge) {
      if (!_isFabVisible) {
        setState(() => _isFabVisible = true);
      }
      return; 
    }

    final direction = position.userScrollDirection;
    if (direction == ScrollDirection.reverse) { // Scrolling down
      if (_isFabVisible) {
        setState(() => _isFabVisible = false);
      }
    } else if (direction == ScrollDirection.forward) { // Scrolling up
      if (!_isFabVisible) {
        setState(() => _isFabVisible = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    Widget leadingContent;
    if (storeProvider.logo != null) {
      leadingContent = CircleAvatar(
        radius: 18,
        backgroundImage: FileImage(storeProvider.logo!),
      );
    } else {
      leadingContent = const CircleAvatar(
        radius: 18,
        child: Icon(Icons.store),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            titleSpacing: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: leadingContent,
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
          productProvider.products.isEmpty
              ? const SliverFillRemaining(
                  child: Center(
                    child: Text('No products yet. Add one!'),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = productProvider.products[index];
                      return ProductCard(product: product);
                    },
                    childCount: productProvider.products.length,
                  ),
                ),
        ],
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _isFabVisible
            ? const AddProductFab()
            : const SizedBox.shrink(),
      ),
    );
  }
}
