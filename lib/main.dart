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

  // 1. KHAI BÁO DANH SÁCH NHÓM Ở ĐÂY (Ngay trên hàm build)
  List<NguoiDung> danhSachNhom = [
    NguoiDung(
      idUser: 1,
      hoTen: 'Nguyễn Văn Dũng',
      soDienThoai: '0987654321',
      diaChi: 'Hà Đông, Hà Nội',
      email: 'dung.nguyen@student.vn',
    ),
    NguoiDung(
      idUser: 2,
      hoTen: 'Lưu Đức Hiệp',
      soDienThoai: '0123456789',
      diaChi: 'Thanh Xuân, Hà Nội',
      email: 'hiep.luu@student.vn',
    ),
    NguoiDung(
      idUser: 3,
      hoTen: 'Nguyễn Kim Khương',
      soDienThoai: '0988888888',
      diaChi: 'Cầu Giấy, Hà Nội',
      email: 'khuong.nguyen@student.vn',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          // Đã sửa lại lỗi typo ở dòng này
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'THÔNG TIN CÁC THÀNH VIÊN:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),

            // 2. VÒNG LẶP TỰ ĐỘNG IN RA DANH SÁCH
            ...danhSachNhom.map((user) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  children: [
                    Text(
                      'Họ tên: ${user.hoTen}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Địa chỉ: ${user.diaChi}'),
                    Text('SĐT: ${user.soDienThoai}'),
                    const Divider(), // Đường kẻ ngang
                  ],
                ),
              );
            }).toList(), // Đừng quên .toList()

            const SizedBox(height: 30),
            const Text('Số lần bạn đã nhấn nút:'),
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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

// 3. CLASS NGƯỜI DÙNG CHUẨN FORM
class NguoiDung {
  int idUser;
  String hoTen;
  String soDienThoai;
  String diaChi;
  String email;

  NguoiDung({
    required this.idUser,
    required this.hoTen,
    required this.soDienThoai,
    required this.diaChi,
    required this.email,
  });

  void hienThiThongTin() {
    print('Người dùng: $hoTen - Địa chỉ: $diaChi');
  }
}
