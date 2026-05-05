import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'content_screen.dart';
import 'about_screen.dart';

class BaseLayout extends StatefulWidget {
  const BaseLayout({super.key});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  int _currentIndex = 0;

  // Tiêu đề của AppBar sẽ thay đổi theo tab
  final List<String> _titles = ['Trang Chủ', 'Thực Đơn', 'Về Chúng Tôi'];

  // Danh sách 3 màn hình
  final List<Widget> _screens = const [
    HomeScreen(),
    ContentScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      // Phần ruột sẽ render màn hình tương ứng
      body: _screens[_currentIndex],
      // Thanh điều hướng Footer
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.deepOrange,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Content',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
      ),
    );
  }
}
