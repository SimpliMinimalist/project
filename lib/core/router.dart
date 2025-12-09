
import 'package:go_router/go_router.dart';
import 'package:myapp/features/auth/screens/welcome_screen.dart';
import 'package:myapp/features/store_setup/screens/store_setup_screen.dart';
import 'package:myapp/features/home/screens/home_screen.dart';
import 'package:myapp/features/add_product/screens/add_product_screen.dart';
import 'package:myapp/features/search_product/screens/search_product_screen.dart';

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
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/add-product',
      builder: (context, state) => const AddProductScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchProductScreen(),
    ),
  ],
);
