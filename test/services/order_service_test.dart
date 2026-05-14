import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pka_food/models/enums/order_status.dart';
import 'package:pka_food/models/enums/payment_method.dart';
import 'package:pka_food/models/order_item_model.dart';
import 'package:pka_food/models/order_model.dart';
import 'package:pka_food/services/database_service.dart';
import 'package:pka_food/services/order_service.dart';

import '../test_hive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const notificationsChannel = MethodChannel(
    'dexterous.com/flutter/local_notifications',
  );

  late Directory hiveDirectory;
  late OrderService orderService;
  late Box<OrderModel> ordersBox;

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(notificationsChannel, (_) async => null);
  });

  setUp(() async {
    hiveDirectory = await setUpTestHive();
    orderService = OrderService()..cancelAllDeliverySimulations();
    ordersBox = Hive.box<OrderModel>(DatabaseService.ordersBoxName);
  });

  tearDown(() async {
    orderService.cancelAllDeliverySimulations();
    await tearDownTestHive(hiveDirectory);
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(notificationsChannel, null);
  });

  test('completeOrder cancels pending simulation timers', () async {
    await _putOrder(ordersBox, status: OrderStatus.created);

    orderService.startDeliverySimulationWithDelays('order-1', _testDelays);
    await orderService.completeOrder('order-1');
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(ordersBox.get('order-1')?.status, OrderStatus.completed);
    expect(orderService.hasActiveDeliverySimulation('order-1'), isFalse);
  });

  test(
    'duplicate simulations cancel stale timers for the same order',
    () async {
      await _putOrder(ordersBox, status: OrderStatus.created);

      orderService.startDeliverySimulationWithDelays('order-1', _testDelays);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      orderService.startDeliverySimulationWithDelays('order-1', _testDelays);
      await Future<void>.delayed(const Duration(milliseconds: 15));

      expect(ordersBox.get('order-1')?.status, OrderStatus.created);

      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(ordersBox.get('order-1')?.status, OrderStatus.confirmed);
    },
  );

  test('completed order does not start a delivery simulation', () async {
    await _putOrder(ordersBox, status: OrderStatus.completed);

    orderService.startDeliverySimulationWithDelays('order-1', _testDelays);
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(ordersBox.get('order-1')?.status, OrderStatus.completed);
    expect(orderService.hasActiveDeliverySimulation('order-1'), isFalse);
  });

  test(
    'deleted order during simulation is a safe no-op and cleans timers',
    () async {
      await _putOrder(ordersBox, status: OrderStatus.created);

      orderService.startDeliverySimulationWithDelays('order-1', _testDelays);
      await ordersBox.delete('order-1');
      await Future<void>.delayed(const Duration(milliseconds: 35));

      expect(ordersBox.get('order-1'), isNull);
      expect(orderService.hasActiveDeliverySimulation('order-1'), isFalse);
    },
  );

  test('delivering timer updates status and shipper name together', () async {
    await _putOrder(ordersBox, status: OrderStatus.created);

    orderService.startDeliverySimulationWithDelays('order-1', _testDelays);
    await Future<void>.delayed(const Duration(milliseconds: 70));

    final order = ordersBox.get('order-1');
    expect(order?.status, OrderStatus.delivering);
    expect(order?.shipperName, 'Nguyễn Văn Tài');
  });
}

const _testDelays = [
  Duration(milliseconds: 20),
  Duration(milliseconds: 40),
  Duration(milliseconds: 60),
  Duration(milliseconds: 80),
];

Future<void> _putOrder(
  Box<OrderModel> ordersBox, {
  required OrderStatus status,
}) {
  return ordersBox.put(
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
      status: status,
      shipperName: 'Đang tìm shipper...',
      createdAt: DateTime(2026, 5, 14),
    ),
  );
}
