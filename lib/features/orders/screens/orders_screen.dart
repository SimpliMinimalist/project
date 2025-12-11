
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/features/search_orders/screens/search_orders_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          IconButton(
            icon: SvgPicture.asset('assets/icons/history.svg',
                width: 24, height: 24),
            onPressed: () {
            },
          ),
          IconButton(
            icon: SvgPicture.asset('assets/icons/filter.svg',
                width: 24, height: 24),
            onPressed: () {
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Orders will be displayed here.'),
      ),
    );
  }
}
