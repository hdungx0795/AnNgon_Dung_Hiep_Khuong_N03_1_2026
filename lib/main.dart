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
  int _counter = 0;
  final List<NguoiDung> _danhSachNguoiDung = const [
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
