import 'package:flutter/material.dart';

import 'tabs/explore_tab.dart';
import 'tabs/cart_tab.dart';
import 'tabs/favorites_tab.dart';
import 'tabs/orders_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const ExploreTab(),
    const CartTab(),
    const OrdersTab(),
    const FavoritesTab(),
  ];

  final List<String> _titles = [
    'Khám phá',
    'Giỏ hàng',
    'Đơn hàng',
    'Yêu thích',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        key: const Key('home-shell-app-bar'),
        toolbarHeight: 48,
        leading: IconButton(
          tooltip: 'Hồ sơ',
          icon: CircleAvatar(
            backgroundColor: colorScheme.primaryContainer,
            radius: 16,
            child: Icon(
              Icons.person_outline,
              size: 18,
              color: colorScheme.primary,
            ),
          ),
          onPressed: () => Navigator.pushNamed(context, '/profile'),
        ),
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
      ),
      body: IndexedStack(
        key: const Key('home-shell-indexed-stack'),
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: NavigationBar(
        key: const Key('home-shell-navigation-bar'),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Giỏ hàng',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Đơn hàng',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Yêu thích',
          ),
        ],
      ),
    );
  }
}
