
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/add_product/screens/add_product_screen.dart';
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    // React to user scrolling
    if (notification is ScrollUpdateNotification) {
      final direction = _scrollController.position.userScrollDirection;
      final scrollDelta = notification.scrollDelta ?? 0;
      const threshold = 5.0; // Adjust for desired sensitivity

      if (direction == ScrollDirection.reverse && scrollDelta.abs() > threshold) {
        if (_isFabVisible) _updateFab(false); // Scrolling down, hide FAB
      } else if (direction == ScrollDirection.forward && scrollDelta.abs() > threshold) {
        if (!_isFabVisible) _updateFab(true); // Scrolling up, show FAB
      }
    }
    // Ensure FAB is visible when scrolling stops at the very top or bottom
    else if (notification is ScrollEndNotification) {
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
      body: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: CustomScrollView(
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
                storeProvider.storeName.isNotEmpty
                    ? storeProvider.storeName
                    : 'My Store',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: SvgPicture.asset('assets/icons/search.svg',
                      width: 24, height: 24),
                  onPressed: () => context.go('/search'),
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
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddProductScreen(product: product),
                              ),
                            );
                          },
                          child: ProductCard(product: product),
                        );
                      },
                      childCount: productProvider.products.length,
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
        child:
            _isFabVisible ? const AddProductFab() : const SizedBox.shrink(),
      ),
    );
  }
}
