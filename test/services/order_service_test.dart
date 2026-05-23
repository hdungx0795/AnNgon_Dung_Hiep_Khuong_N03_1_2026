import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:pka_food/models/enums/order_status.dart';
import 'package:pka_food/models/enums/payment_method.dart';
import 'package:pka_food/models/order_item_model.dart';
import 'package:pka_food/models/order_model.dart';
import 'package:pka_food/models/cart_item_model.dart';
import 'package:pka_food/services/database_service.dart';
import 'package:pka_food/services/order_service.dart';

import '../test_hive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const notificationsChannel = MethodChannel(
    'dexterous.com/flutter/local_notifications',
  );

  late Directory hiveDirectory;
  late FakeFirebaseFirestore fakeFirestore;
  late OrderService orderService;
  late Box<OrderModel> ordersBox;

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(notificationsChannel, (_) async => null);
  });

  setUp(() async {
    hiveDirectory = await setUpTestHive();
    fakeFirestore = FakeFirebaseFirestore();
    orderService = OrderService(firestore: fakeFirestore)..cancelAllDeliverySimulations();
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

  test('TC8 Unit/OrderService - completeOrder cancels pending simulation timers', () async {
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

  test('TC8 Unit/OrderService - completed order avoids delivery simulation', () async {
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

  test('TC8 Unit/OrderService - delivering timer updates status and shipper', () async {
    await _putOrder(ordersBox, status: OrderStatus.created);

    orderService.startDeliverySimulationWithDelays('order-1', _testDelays);
    await Future<void>.delayed(const Duration(milliseconds: 70));

    final order = ordersBox.get('order-1');
    expect(order?.status, OrderStatus.delivering);
    expect(order?.shipperName, 'Nguyễn Văn Tài');
    
    // Also verify Firestore is updated
    final fsOrder = await fakeFirestore.collection('orders').doc('order-1').get();
    expect(fsOrder.data()?['status'], OrderStatus.delivering.name);
  });

  test('TC8 Unit/OrderService - createOrder writes to Hive and Firestore', () async {
    final cartItem = CartItemModel(
      product: testProduct(id: 1, name: 'Burger', price: 100),
      quantity: 2,
    );
    
    final order = await orderService.createOrder(
      userId: 1,
      items: [cartItem],
      paymentMethod: PaymentMethod.cod,
      address: 'Home',
      note: '',
    );
    
    // Verify Hive
    expect(ordersBox.get(order.orderId), isNotNull);
    
    // Verify Firestore
    final doc = await fakeFirestore.collection('orders').doc(order.orderId).get();
    expect(doc.exists, isTrue);
    expect(doc.data()?['userId'], 1);
  });

  test('TC8 Unit/OrderService - getActiveOrders uses Firestore with Hive fallback', () async {
    // 1. Put into Firestore directly
    await fakeFirestore.collection('orders').doc('order-fs').set(
      OrderModel(
        orderId: 'order-fs',
        userId: 1,
        items: [],
        totalAmount: 100,
        paymentMethod: PaymentMethod.cod,
        deliveryAddress: '',
        note: '',
        status: OrderStatus.created,
        shipperName: '',
        createdAt: DateTime.now(),
      ).toJson()
    );
    
    // Read from service
    final activeOrders = await orderService.getActiveOrders(1);
    expect(activeOrders.length, 1);
    expect(activeOrders.first.orderId, 'order-fs');
    
    // Verify it cached to Hive
    expect(ordersBox.get('order-fs'), isNotNull);
  });

  test('TC8 Unit/OrderService - getOrderHistory reads from Firestore', () async {
    await fakeFirestore.collection('orders').doc('order-fs-hist').set(
      OrderModel(
        orderId: 'order-fs-hist',
        userId: 1,
        items: [],
        totalAmount: 100,
        paymentMethod: PaymentMethod.cod,
        deliveryAddress: '',
        note: '',
        status: OrderStatus.completed,
        shipperName: '',
        createdAt: DateTime.now(),
      ).toJson()
    );
    
    final history = await orderService.getOrderHistory(1);
    expect(history.length, 1);
    expect(history.first.orderId, 'order-fs-hist');
  });

  test('TC8 Unit/OrderService - falls back to Hive on Firestore error', () async {
    // Hive has order, Firestore is empty
    await _putOrder(ordersBox, status: OrderStatus.created);
    
    final activeOrders = await orderService.getActiveOrders(1);
    expect(activeOrders.length, 1);
    expect(activeOrders.first.orderId, 'order-1');
  });

  test('TC8 Unit/OrderService - updateOrderStatus syncs to Hive and Firestore', () async {
    await _putOrder(ordersBox, status: OrderStatus.created);
    await orderService.updateOrderStatus('order-1', OrderStatus.confirmed);
    
    expect(ordersBox.get('order-1')?.status, OrderStatus.confirmed);
    
    final doc = await fakeFirestore.collection('orders').doc('order-1').get();
    expect(doc.exists, isTrue);
    expect(doc.data()?['status'], OrderStatus.confirmed.name);
  });

  test('TC8 Unit/OrderService - prevents duplicate Hive cache writes', () async {
    final orderJson = OrderModel(
      orderId: 'order-cache-test',
      userId: 1,
      items: [],
      totalAmount: 100,
      paymentMethod: PaymentMethod.cod,
      deliveryAddress: '',
      note: '',
      status: OrderStatus.created,
      shipperName: '',
      createdAt: DateTime(2026, 5, 20),
    ).toJson();

    await fakeFirestore.collection('orders').doc('order-cache-test').set(orderJson);

    int watchCount = 0;
    final sub = ordersBox.watch().listen((_) => watchCount++);
    
    // Fetch 1: should cache and trigger watch
    await orderService.getActiveOrders(1);
    await Future<void>.delayed(Duration.zero);
    expect(watchCount, 1);
    
    // Fetch 2: should not cache again
    await orderService.getActiveOrders(1);
    await Future<void>.delayed(Duration.zero);
    expect(watchCount, 1);

    await sub.cancel();
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
