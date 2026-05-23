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

  test('TC8 Provider/OrderProvider - loadOrders is a no-op after dispose', () async {
    final provider = OrderProvider(OrderService());

    provider.dispose();
    await provider.loadOrders(1);

    expect(provider.isLoading, isFalse);
    expect(provider.activeOrders, isEmpty);
    expect(provider.orderHistory, isEmpty);
  });

  test('TC8 Provider/OrderProvider - ignores order box watch events after dispose', () async {
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

  test('TC8 Provider/OrderProvider - resets loading after service error', () async {
    final provider = OrderProvider(_ThrowingOrderService());
    
    // Add dummy active orders to verify state is preserved
    provider.activeOrders.add(_createTestOrder('old-1'));
    
    expect(provider.isLoading, isFalse);
    expect(provider.activeOrders, isNotEmpty);
    
    await provider.loadOrders(1);
    
    expect(provider.isLoading, isFalse);
    expect(provider.activeOrders.length, 1);
  });
}

class _ThrowingOrderService implements OrderService {
  @override
  Future<List<OrderModel>> getActiveOrders(int userId) async {
    throw Exception('Simulated fetch failure');
  }

  @override
  Future<List<OrderModel>> getOrderHistory(int userId) async {
    return [];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

OrderModel _createTestOrder(String id) {
  return OrderModel(
    orderId: id,
    userId: 1,
    items: [],
    totalAmount: 100,
    paymentMethod: PaymentMethod.cod,
    deliveryAddress: 'Test address',
    note: '',
    status: OrderStatus.created,
    shipperName: 'Shipper',
    createdAt: DateTime.now(),
  );
}
