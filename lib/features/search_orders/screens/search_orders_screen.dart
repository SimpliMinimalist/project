
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/features/search_orders/models/order.dart';
import 'package:myapp/shared/widgets/custom_search_bar.dart';

class SearchOrdersScreen extends StatefulWidget {
  const SearchOrdersScreen({super.key});

  @override
  State<SearchOrdersScreen> createState() => _SearchOrdersScreenState();
}

class _SearchOrdersScreenState extends State<SearchOrdersScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Order> _allOrders = [
    Order(id: 'ORD-001', customerName: 'John Doe', status: 'Delivered', amount: 150.00, date: DateTime(2024, 5, 20)),
    Order(id: 'ORD-002', customerName: 'Jane Smith', status: 'Pending', amount: 75.50, date: DateTime(2024, 5, 21)),
    Order(id: 'ORD-003', customerName: 'Peter Jones', status: 'Shipped', amount: 200.00, date: DateTime(2024, 5, 21)),
    Order(id: 'ORD-004', customerName: 'Mary Johnson', status: 'Delivered', amount: 300.75, date: DateTime(2024, 5, 22)),
    Order(id: 'ORD-005', customerName: 'Chris Lee', status: 'Cancelled', amount: 50.00, date: DateTime(2024, 5, 23)),
    Order(id: 'ORD-006', customerName: 'David Brown', status: 'Delivered', amount: 120.00, date: DateTime(2024, 5, 24)),
    Order(id: 'ORD-007', customerName: 'Sarah Davis', status: 'Pending', amount: 90.25, date: DateTime(2024, 5, 25)),
  ];

  List<Order> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _filteredOrders = _allOrders;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredOrders = _allOrders
          .where((order) =>
              order.id.toLowerCase().contains(query.toLowerCase()) ||
              order.customerName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
              hintText: 'Search by Order ID or Customer',
              onChanged: _onSearchChanged,
              hasBackButton: true,
              onBack: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: _filteredOrders.isEmpty
          ? const Center(
              child: Text('No orders found.'),
            )
          : ListView.builder(
              itemCount: _filteredOrders.length,
              itemBuilder: (context, index) {
                final order = _filteredOrders[index];
                return _OrderListTile(order: order);
              },
            ),
    );
  }
}

class _OrderListTile extends StatelessWidget {
  const _OrderListTile({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(order.customerName),
      subtitle: Text(order.id),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '\$${order.amount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(DateFormat.yMMMd().format(order.date)),
        ],
      ),
    );
  }
}
