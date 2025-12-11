
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/icons/search.svg',
                width: 24, height: 24),
            onPressed: () {
              // TODO: Implement search functionality
            },
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
      body: const Center(
        child: Text('Orders will be displayed here.'),
      ),
    );
  }
}
