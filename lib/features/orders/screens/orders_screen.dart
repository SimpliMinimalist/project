
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/shared/widgets/custom_search_bar.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        // TODO: Reset search results for orders here
      }
    });
  }

  void _onSearchChanged(String query) {
    // TODO: Implement order search logic
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 16.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: _isSearching
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomSearchBar(
                      key: const ValueKey('SearchBar'),
                      controller: _searchController,
                      hintText: 'Search Orders',
                      onChanged: _onSearchChanged,
                      hasBackButton: true,
                      onBack: _toggleSearch,
                    ),
                  ),
                )
              : AppBar(
                  key: const ValueKey('DefaultAppBar'),
                  title: const Text('Orders'),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: SvgPicture.asset('assets/icons/search.svg',
                          width: 24, height: 24),
                      onPressed: _toggleSearch,
                    ),
                    IconButton(
                      icon: SvgPicture.asset('assets/icons/history.svg',
                          width: 24, height: 24),
                      onPressed: () {
                        // TODO: Implement history functionality
                      },
                    ),
                    IconButton(
                      icon: SvgPicture.asset('assets/icons/filter.svg',
                          width: 24, height: 24),
                      onPressed: () {
                        // TODO: Implement filter functionality
                      },
                    ),
                  ],
                ),
        ),
      ),
      body: const Center(
        child: Text('Orders will be displayed here.'),
      ),
    );
  }
}
