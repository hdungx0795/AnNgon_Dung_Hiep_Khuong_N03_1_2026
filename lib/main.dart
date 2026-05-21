import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo Firebase
  await Firebase.initializeApp();
  
  // Khởi tạo NoSQL Database (Hive)
  await DatabaseService().init();

  // Khởi tạo Notifications
  await NotificationService().init();
  
  runApp(const PkaFoodApp());
}
