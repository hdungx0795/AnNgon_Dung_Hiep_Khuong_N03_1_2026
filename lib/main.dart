import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  // Firebase web requires explicit options. Keep the app usable with local
  // Hive fallback when a Firebase config file is not present in the repo.
  try {
    await Firebase.initializeApp();
  } catch (error) {
    debugPrint('Firebase initialization skipped: $error');
  }

  // Khởi tạo NoSQL Database (Hive)
  await DatabaseService().init();

  // Khởi tạo Notifications
  await NotificationService().init();

  runApp(const PkaFoodApp());
}
