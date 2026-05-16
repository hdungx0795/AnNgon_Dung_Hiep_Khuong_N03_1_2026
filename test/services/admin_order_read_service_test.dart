import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pka_food/models/enums/order_status.dart';
import 'package:pka_food/models/enums/payment_method.dart';
import 'package:pka_food/models/order_item_model.dart';
import 'package:pka_food/models/order_model.dart';
import 'package:pka_food/services/admin_order_read_service.dart';
import 'package:pka_food/services/database_service.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;
  late Box<OrderModel> ordersBox;

  setUp(() async {
    hiveDirectory = await setUpTestHive();
    ordersBox = Hive.box<OrderModel>(DatabaseService.ordersBoxName);
  });

  tearDown(() async {
    await tearDownTestHive(hiveDirectory);
  });

  test(
    'completed revenue includes completed orders only after discount',
    () async {
      await ordersBox.put(
        'completed',
        _order(
          id: 'completed',
          status: OrderStatus.completed,
          totalAmount: 100000,
          discount: 15000,
        ),
      );
      await ordersBox.put(
        'active',
        _order(
          id: 'active',
          status: OrderStatus.delivering,
          totalAmount: 50000,
        ),
      );

      final service = AdminOrderReadService();

      expect(service.totalOrders, 2);
      expect(service.completedRevenue, 85000);
    },
  );
}

OrderModel _order({
  required String id,
  required OrderStatus status,
  required int totalAmount,
  int discount = 0,
}) {
  return OrderModel(
    orderId: id,
    userId: 7,
    items: [
      OrderItemModel(
        productId: 1,
        productName: 'Test Burger',
        quantity: 1,
        unitPrice: totalAmount,
      ),
    ],
    totalAmount: totalAmount,
    paymentMethod: PaymentMethod.cod,
    deliveryAddress: 'Test address',
    note: '',
    status: status,
    shipperName: 'Test shipper',
    createdAt: DateTime(2026, 5, 15),
    discount: discount,
  );
}
