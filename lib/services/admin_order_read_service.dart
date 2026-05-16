import 'package:hive_flutter/hive_flutter.dart';

import '../models/enums/order_status.dart';
import '../models/order_model.dart';
import 'database_service.dart';

class AdminOrderReadService {
  static final AdminOrderReadService _instance = AdminOrderReadService._();
  factory AdminOrderReadService() => _instance;
  AdminOrderReadService._();

  Box<OrderModel> get _ordersBox =>
      Hive.box<OrderModel>(DatabaseService.ordersBoxName);

  List<OrderModel> getAllOrders() {
    return _ordersBox.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  int get totalOrders => _ordersBox.length;

  int get completedRevenue {
    return _ordersBox.values
        .where((order) => order.status == OrderStatus.completed)
        .fold(0, (sum, order) => sum + order.finalAmount);
  }
}
