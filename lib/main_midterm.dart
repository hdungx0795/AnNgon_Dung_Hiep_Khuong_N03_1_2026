import 'package:flutter/material.dart';
import 'midterm/base_layout.dart';

void main() {
  runApp(const MidtermApp());
}

class MidtermApp extends StatelessWidget {
  const MidtermApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài Thi Giữa Kỳ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      debugShowCheckedModeBanner: false,
      home: const BaseLayout(),
    );
  }
}
