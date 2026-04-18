import 'package:flutter/material.dart';
import 'models/nguoi_dung.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng Đồ Ăn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Ứng dụng Đồ Ăn'),
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
<<<<<<< HEAD
  int _counter = 2;

  final Map<String, dynamic> _user = {
    'idUser': 10,
    'hoTen': 'Nguyễn Văn A',
    'soDienThoai': '0987654321',
    'diaChi': 'Hà Đông, Hà Nội',
    'email': 'nguyenvana@email.com',
  };

  final List<String> _categories = [
    'Món Chính',
    'Đồ Uống',
    'Tráng Miệng',
    'Ăn Vặt',
  ];

  final List<Map<String, dynamic>> _listMonAn = [
    {'idMon': 1, 'tenMon': 'Phở Bò', 'gia': 50000.0, 'danhMuc': 'Món chính'},
    {
      'idMon': 2,
      'tenMon': 'Bún Đậu Mắm Tôm',
      'gia': 45000.0,
      'danhMuc': 'Món chính',
    },
    {'idMon': 3, 'tenMon': 'Trà Sữa', 'gia': 35000.0, 'danhMuc': 'Đồ uống'},
  ];

  // 1. KHAI BÁO DANH SÁCH NHÓM Ở ĐÂY (Ngay trên hàm build)
  List<NguoiDung> danhSachNhom = [
=======
  int _counter = 0;
  final List<NguoiDung> _danhSachNguoiDung = const [
>>>>>>> main
    NguoiDung(
      id: '23010438',
      hoTen: 'Nguyen Van Dung',
      sdt: '0900000001',
      diaChi: 'Ha Noi',
      email: 'dung23010438@example.com',
    ),
    NguoiDung(
      id: '23010437',
      hoTen: 'Luu Duc Hiep',
      sdt: '0900000002',
      diaChi: 'Ha Noi',
      email: 'hiep23010437@example.com',
    ),
    NguoiDung(
      id: '23010428',
      hoTen: 'Nguyen Kim Khuong',
      sdt: '0900000003',
      diaChi: 'Ha Noi',
      email: 'khuong23010428@example.com',
    ),
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
      body: Center(
        child: Column(
<<<<<<< HEAD
          // Đã sửa lại lỗi typo ở dòng này
=======
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
>>>>>>> main
          mainAxisAlignment: MainAxisAlignment.center,
          // Tìm đến đoạn này trong code của bạn
          children: <Widget>[
            const Text(
              'DANH SÁCH THÀNH VIÊN NHÓM:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20), // Tạo một khoảng trắng cách ra
            ..._danhSachNguoiDung.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final nguoiDung = entry.value;
              return Text('$index. ${nguoiDung.hoTen} - MSV: ${nguoiDung.id}');
            }),

            const SizedBox(height: 30), // Khoảng cách trước số đếm
            const Text('Số lần bạn đã nhấn nút:'),
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
<<<<<<< HEAD
            const SizedBox(height: 8),
            Text('- Họ tên: ${_user['hoTen']}'),
            Text('- Số điện thoại: ${_user['soDienThoai']}'),
            Text('- Địa chỉ: ${_user['diaChi']}'),

            const Divider(height: 40),

            // DANH SÁCH 2: Danh mục
            const Text(
              '2. CÁC DANH MỤC:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            // Dùng join để in mảng thành chuỗi cách nhau bởi dấu phẩy
            Text(_categories.join(', ')),

            const Divider(height: 40),

            // DANH SÁCH 3: Món ăn
            const Text(
              '3. DANH SÁCH MÓN ĂN:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            // Dùng vòng lặp in thẳng ra Text
            for (var mon in _listMonAn)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  '- ${mon['tenMon']} (${mon['gia']} VNĐ) - Thuộc: ${mon['danhMuc']}',
                ),
              ),
=======
>>>>>>> main
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
