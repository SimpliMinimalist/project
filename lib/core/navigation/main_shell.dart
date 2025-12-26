import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/search_orders/screens/search_orders_screen.dart';
import 'package:myapp/providers/selection_provider.dart';
import 'package:myapp/providers/store_provider.dart';
import 'package:provider/provider.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  void _onItemTapped(int index, BuildContext context) {
    final selectionProvider = Provider.of<SelectionProvider>(context, listen: false);
    if (selectionProvider.isSelectionMode) {
      selectionProvider.clearSelection();
    }
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/orders');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Theme.of(context).colorScheme.onPrimary;
    final Color unselectedColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: _buildAppBar(),
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) => _onItemTapped(index, context),
        selectedIndex: _selectedIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: SvgPicture.asset(
              'assets/icons/store.svg',
              width: 24, height: 24,
              colorFilter: ColorFilter.mode(selectedColor, BlendMode.srcIn),
            ),
            icon: SvgPicture.asset(
              'assets/icons/store.svg',
              width: 24, height: 24,
              colorFilter: ColorFilter.mode(unselectedColor, BlendMode.srcIn),
            ),
            label: 'Store',
          ),
          NavigationDestination(
            selectedIcon: SvgPicture.asset(
              'assets/icons/orders.svg',
              width: 24, height: 24,
              colorFilter: ColorFilter.mode(selectedColor, BlendMode.srcIn),
            ),
            icon: SvgPicture.asset(
              'assets/icons/orders.svg',
              width: 24, height: 24,
              colorFilter: ColorFilter.mode(unselectedColor, BlendMode.srcIn),
            ),
            label: 'Orders',
          ),
          NavigationDestination(
            selectedIcon: SvgPicture.asset(
              'assets/icons/profile.svg',
              width: 24, height: 24,
              colorFilter: ColorFilter.mode(selectedColor, BlendMode.srcIn),
            ),
            icon: SvgPicture.asset(
              'assets/icons/profile.svg',
              width: 24, height: 24,
              colorFilter: ColorFilter.mode(unselectedColor, BlendMode.srcIn),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final storeProvider = Provider.of<StoreProvider>(context);
    final selectionProvider = Provider.of<SelectionProvider>(context);

    if (selectionProvider.isSelectionMode) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => selectionProvider.clearSelection(),
        ),
        title: Text('\${selectionProvider.selectedProducts.length} selected'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => selectionProvider.deleteSelectedProducts(context),
          ),
        ],
      );
    }

    switch (_selectedIndex) {
      case 0:
        return AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              radius: 12,
              backgroundImage: storeProvider.logo != null
                  ? FileImage(storeProvider.logo!)
                  : null,
            ),
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
              onPressed: () => context.push('/search'),
            ),
          ],
        );
      case 1:
        return AppBar(
          title: const Text('Orders'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: SvgPicture.asset('assets/icons/search.svg',
                  width: 24, height: 24),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchOrdersScreen(),
                  ),
                );
              },
            ),
          ],
        );
      case 2:
        return AppBar(
          title: const Text('Profile'),
        );
      default:
        return AppBar();
    }
  }
}
