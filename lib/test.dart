import 'package:flutter/material.dart';

void main() {
  runApp(const AnNgonApp());
}

class AnNgonApp extends StatelessWidget {
  const AnNgonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'An Ngon App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
        ), // Màu cam hợp với app đồ ăn
        useMaterial3: true,
      ),
      // Bắt đầu ứng dụng bằng màn hình MainScreen
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// =========================================================
// MÀN HÌNH CHÍNH (Chứa thanh Bottom Navigation)
// =========================================================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Biến lưu trữ vị trí của tab đang được chọn (mặc định là 0 - Trang chủ)
  int _selectedIndex = 0;

  // Danh sách 3 màn hình sẽ được hiển thị tương ứng với 3 tab
  static const List<Widget> _danhSachManHinh = <Widget>[
    TrangChuScreen(),
    GioHangScreen(),
    HoSoScreen(),
  ];

  // Hàm xử lý khi người dùng bấm vào một tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Phần body sẽ tự động thay đổi dựa vào _selectedIndex
      body: Center(child: _danhSachManHinh.elementAt(_selectedIndex)),

      // Thanh điều hướng dưới đáy
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Giỏ hàng',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ sơ'),
        ],
        currentIndex: _selectedIndex, // Vị trí tab đang active
        selectedItemColor: Colors.deepOrange, // Màu khi được chọn
        unselectedItemColor: Colors.grey, // Màu khi không được chọn
        onTap: _onItemTapped, // Gọi hàm chuyển tab khi bấm
      ),
    );
  }
}

// =========================================================
// 3 MÀN HÌNH CON (Screens)
// =========================================================

// 1. Màn hình Trang Chủ
class TrangChuScreen extends StatelessWidget {
  const TrangChuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khám phá món ngon'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Trang Chủ',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// 2. Màn hình Giỏ Hàng
class GioHangScreen extends StatelessWidget {
  const GioHangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng của bạn'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Đây là Giỏ Hàng',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// 3. Màn hình Hồ Sơ
class HoSoScreen extends StatelessWidget {
  const HoSoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Hồ Sơ',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
