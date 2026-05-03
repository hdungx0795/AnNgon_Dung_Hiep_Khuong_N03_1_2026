import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'tabs/explore_tab.dart';
import 'tabs/cart_tab.dart';
import 'tabs/orders_tab.dart';
import 'tabs/favorites_tab.dart';

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 15,
            child: Icon(Icons.person, size: 20, color: Colors.white),
          ),
          onPressed: () => Navigator.pushNamed(context, '/profile'),
        ),
        title: Text(_titles[_currentIndex], style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Giỏ hàng'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Đơn hàng'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Yêu thích'),
        ],
      ),
    );
  }
}
