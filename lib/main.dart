import 'package:flutter/material.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo NoSQL Database (Hive)
  await DatabaseService().init();

  // Khởi tạo Notifications
  await NotificationService().init();
  
  runApp(const PkaFoodApp());
}
