
import 'package:flutter/material.dart';
import 'package:myapp/shared/widgets/custom_search_bar.dart';

class SearchOrdersScreen extends StatefulWidget {
  const SearchOrdersScreen({super.key});

  @override
  State<SearchOrdersScreen> createState() => _SearchOrdersScreenState();
}

class _SearchOrdersScreenState extends State<SearchOrdersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomSearchBar(
              controller: _searchController,
              hintText: 'Search Orders',
              onChanged: _onSearchChanged,
              hasBackButton: true,
              onBack: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text('Search results for orders will appear here.'),
      ),
    );
  }
}
