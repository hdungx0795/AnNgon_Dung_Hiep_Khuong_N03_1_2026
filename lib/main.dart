import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Đồ Ăn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 2;

  final Map<String, dynamic> _user = {
    'idUser': 10,
    'hoTen': 'Nguyễn Văn A',
    'soDienThoai': '0987654321',
    'diaChi': 'Hà Đông, Hà Nội',
    'email': 'nguyenvana@email.com'
  };

  final List<String> _categories = [
    'Món Chính',
    'Đồ Uống',
    'Tráng Miệng',
    'Ăn Vặt'
  ];

  final List<Map<String, dynamic>> _listMonAn = [
    {
      'idMon': 1,
      'tenMon': 'Phở Bò',
      'gia': 50000.0,
      'danhMuc': 'Món chính'
    },
    {
      'idMon': 2,
      'tenMon': 'Bún Đậu Mắm Tôm',
      'gia': 45000.0,
      'danhMuc': 'Món chính'
    },
    {
      'idMon': 3,
      'tenMon': 'Trà Sữa',
      'gia': 35000.0,
      'danhMuc': 'Đồ uống'
    },
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái toàn bộ
          children: <Widget>[
            // Phần Counter mặc định
            Center(
              child: Column(
                children: [
                  const Text('You have pushed the button this many times:'),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            
            const Divider(height: 40, thickness: 2),

            // DANH SÁCH 1: Người dùng
            const Text(
              '1. THÔNG TIN NGƯỜI DÙNG:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Text('- Họ tên: ${_user['hoTen']}'),
            Text('- Số điện thoại: ${_user['soDienThoai']}'),
            Text('- Địa chỉ: ${_user['diaChi']}'),

            const Divider(height: 40),

            // DANH SÁCH 2: Danh mục
            const Text(
              '2. CÁC DANH MỤC:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            // Dùng join để in mảng thành chuỗi cách nhau bởi dấu phẩy
            Text(_categories.join(', ')), 

            const Divider(height: 40),

            // DANH SÁCH 3: Món ăn
            const Text(
              '3. DANH SÁCH MÓN ĂN:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            // Dùng vòng lặp in thẳng ra Text
            for (var mon in _listMonAn)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('- ${mon['tenMon']} (${mon['gia']} VNĐ) - Thuộc: ${mon['danhMuc']}'),
              ),
              
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
