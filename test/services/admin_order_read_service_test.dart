import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
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

  late FakeFirebaseFirestore fakeFirestore;
  late AdminOrderReadService adminOrderService;

  setUp(() async {
    hiveDirectory = await setUpTestHive();
    fakeFirestore = FakeFirebaseFirestore();
    adminOrderService = AdminOrderReadService(firestore: fakeFirestore);
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

      final service = AdminOrderReadService(firestore: fakeFirestore);

      expect(service.totalOrders, 2);
      expect(service.completedRevenue, 85000);
    },
  );

  test('syncOrdersFromFirestore caches valid orders to Hive', () async {
    await fakeFirestore.collection('orders').doc('sync-1').set(
      _order(id: 'sync-1', status: OrderStatus.created, totalAmount: 200).toJson()
    );
    await fakeFirestore.collection('orders').doc('sync-2').set(
      _order(id: 'sync-2', status: OrderStatus.completed, totalAmount: 100).toJson()
    );

    expect(ordersBox.length, 0);

    await adminOrderService.syncOrdersFromFirestore();

    expect(ordersBox.length, 2);
    expect(adminOrderService.totalOrders, 2);
    expect(adminOrderService.completedRevenue, 100);
  });

  test('syncOrdersFromFirestore ignores parsing errors and continues', () async {
    await fakeFirestore.collection('orders').doc('bad').set({'invalid': 'data'});
    await fakeFirestore.collection('orders').doc('good').set(
      _order(id: 'good', status: OrderStatus.completed, totalAmount: 50).toJson()
    );

    await adminOrderService.syncOrdersFromFirestore();

    expect(ordersBox.length, 1);
    expect(adminOrderService.totalOrders, 1);
    expect(ordersBox.get('good')?.orderId, 'good');
  });

  test('Fallback to Hive if Firestore is empty or fails', () async {
    await ordersBox.put(
      'hive-only',
      _order(id: 'hive-only', status: OrderStatus.delivering, totalAmount: 50),
    );

    // Sync from empty Firestore
    await adminOrderService.syncOrdersFromFirestore();

    // Still retains Hive data
    expect(adminOrderService.totalOrders, 1);
    expect(adminOrderService.getAllOrders().first.orderId, 'hive-only');
  });
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
