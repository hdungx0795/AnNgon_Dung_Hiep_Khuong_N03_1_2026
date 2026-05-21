import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/enums/order_status.dart';
import '../models/order_model.dart';
import 'database_service.dart';

class AdminOrderReadService {
  static AdminOrderReadService? _instance;
  factory AdminOrderReadService({FirebaseFirestore? firestore}) {
    if (firestore != null) {
      return AdminOrderReadService._(firestore);
    }
    _instance ??= AdminOrderReadService._(null);
    return _instance!;
  }
  AdminOrderReadService._(this._firestoreOverride);

  final FirebaseFirestore? _firestoreOverride;
  FirebaseFirestore get _fs => _firestoreOverride ?? FirebaseFirestore.instance;

  Box<OrderModel> get _ordersBox =>
      Hive.box<OrderModel>(DatabaseService.ordersBoxName);

  Future<void> syncOrdersFromFirestore() async {
    try {
      final snapshot = await _fs.collection('orders').get();
      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          try {
            final order = OrderModel.fromJson(doc.data());
            await _ordersBox.put(order.orderId, order);
          } catch (e) {
            debugPrint('Admin sync: Failed to parse order ${doc.id}: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Admin sync: Firestore fetch failed: $e');
    }
  }

  List<OrderModel> getAllOrders() {
    return _ordersBox.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  int get totalOrders => _ordersBox.length;

  int get completedRevenue {
    return _ordersBox.values
        .where((order) => order.status == OrderStatus.completed)
        .fold(0, (acc, order) => acc + order.finalAmount);
  }
}
