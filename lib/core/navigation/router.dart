import 'package:go_router/go_router.dart';
import 'package:myapp/core/navigation/main_shell.dart';
import 'package:myapp/features/auth/screens/welcome_screen.dart';
import 'package:myapp/features/store_setup/screens/store_setup_screen.dart';
import 'package:myapp/features/store/screens/store_screen.dart';
import 'package:myapp/features/add_product/screens/add_product_screen.dart';
import 'package:myapp/features/orders/screens/orders_screen.dart';
import 'package:myapp/features/search_product/screens/search_product_screen.dart';
import 'package:myapp/features/add_product/models/product_model.dart';
import 'package:myapp/features/profile/screens/profile_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/store-setup',
      builder: (context, state) => const StoreSetupScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const StoreScreen(),
        ),
        GoRoute(
          path: '/orders',
          builder: (context, state) => const OrdersScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/add-product',
      builder: (context, state) => const AddProductScreen(),
    ),
    GoRoute(
      path: '/edit-product',
      builder: (context, state) {
        final product = state.extra as Product;
        return AddProductScreen(product: product);
      },
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchProductScreen(),
    ),
  ],
);
