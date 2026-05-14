import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pka_food/models/order_item_model.dart';
import 'package:pka_food/models/order_model.dart';
import 'package:pka_food/models/enums/order_status.dart';
import 'package:pka_food/models/enums/payment_method.dart';
import 'package:pka_food/providers/order_provider.dart';
import 'package:pka_food/services/database_service.dart';
import 'package:pka_food/services/order_service.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;

  setUp(() async {
    hiveDirectory = await setUpTestHive();
  });

  tearDown(() async {
    await tearDownTestHive(hiveDirectory);
  });

  test('loadOrders is a no-op after dispose', () async {
    final provider = OrderProvider(OrderService());

    provider.dispose();
    await provider.loadOrders(1);

    expect(provider.isLoading, isFalse);
    expect(provider.activeOrders, isEmpty);
    expect(provider.orderHistory, isEmpty);
  });

  test('disposed provider ignores order box watch events', () async {
    final provider = OrderProvider(OrderService());
    var notifications = 0;
    provider.addListener(() => notifications++);

    provider.dispose();

    await Hive.box<OrderModel>(DatabaseService.ordersBoxName).put(
      'order-1',
      OrderModel(
        orderId: 'order-1',
        userId: 1,
        items: [
          OrderItemModel(
            productId: 1,
            productName: 'Test Burger',
            quantity: 1,
            unitPrice: 25000,
          ),
        ],
        totalAmount: 25000,
        paymentMethod: PaymentMethod.cod,
        deliveryAddress: 'Test address',
        note: '',
        status: OrderStatus.created,
        shipperName: 'Đang tìm shipper...',
        createdAt: DateTime(2026, 5, 14),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(notifications, 0);
  });
}
