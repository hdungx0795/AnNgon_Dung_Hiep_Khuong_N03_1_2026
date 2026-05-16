import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/models/enums/order_status.dart';
import 'package:pka_food/models/enums/payment_method.dart';
import 'package:pka_food/models/order_item_model.dart';
import 'package:pka_food/models/order_model.dart';
import 'package:pka_food/providers/order_provider.dart';
import 'package:pka_food/screens/tracking/tracking_order_screen.dart';
import 'package:pka_food/services/order_service.dart';
import 'package:provider/provider.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;
  late _TestOrderProvider orderProvider;

  setUpAll(() async {
    hiveDirectory = await setUpTestHive();
  });

  setUp(() {
    orderProvider = _TestOrderProvider();
  });

  tearDown(() {
    orderProvider.dispose();
  });

  tearDownAll(() async {
    await tearDownTestHive(hiveDirectory);
  });

  testWidgets('shows a fallback when tracking order is not found', (
    tester,
  ) async {
    await _pumpTracking(tester, orderProvider, 'missing-order');

    expect(find.byKey(const Key('tracking-order-not-found')), findsOneWidget);
    expect(find.text('Không tìm thấy đơn hàng'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders tracking details and progress for preparing status', (
    tester,
  ) async {
    orderProvider.setActiveOrders([_order(status: OrderStatus.preparing)]);

    await _pumpTracking(tester, orderProvider, 'order-123456789');

    expect(find.byKey(const Key('tracking-header')), findsOneWidget);
    expect(find.text('Đơn hàng #order-12'), findsOneWidget);
    expect(find.byKey(const Key('tracking-status-preparing')), findsOneWidget);
    expect(
      find.byKey(const Key('tracking-progress-preparing')),
      findsOneWidget,
    );
    expect(
      find.text('Món đang được chuẩn bị, tài xế sẽ được gán sau đó.'),
      findsWidgets,
    );
    expect(find.text('Phenikaa University'), findsOneWidget);
    expect(find.text('Thanh toán tiền mặt (COD)'), findsOneWidget);
    expect(find.text('2x Test Burger'), findsOneWidget);
  });

  testWidgets('shows pending shipper state before delivery starts', (
    tester,
  ) async {
    orderProvider.setActiveOrders([_order(status: OrderStatus.preparing)]);

    await _pumpTracking(tester, orderProvider, 'order-123456789');

    expect(find.byKey(const Key('tracking-shipper-pending')), findsOneWidget);
    expect(find.text('Đang điều phối'), findsOneWidget);
    expect(find.byKey(const Key('tracking-chat-button')), findsNothing);
    expect(find.byKey(const Key('tracking-call-button')), findsNothing);
  });

  testWidgets('shows shipper contact actions while delivering', (tester) async {
    orderProvider.setActiveOrders([_order(status: OrderStatus.delivering)]);

    await _pumpTracking(tester, orderProvider, 'order-123456789');

    expect(find.byKey(const Key('tracking-shipper-visible')), findsOneWidget);
    expect(find.text('Test Shipper'), findsOneWidget);
    expect(find.byKey(const Key('tracking-chat-button')), findsOneWidget);
    expect(find.byKey(const Key('tracking-call-button')), findsOneWidget);
    expect(
      find.text('Tài xế đang giao đơn, dự kiến tới trong 10-15 phút.'),
      findsWidgets,
    );
  });

  testWidgets('delivered status exposes completion action', (tester) async {
    orderProvider.setActiveOrders([_order(status: OrderStatus.delivered)]);

    await _pumpTracking(tester, orderProvider, 'order-123456789');

    expect(
      find.byKey(const Key('tracking-complete-order-button')),
      findsOneWidget,
    );
    expect(find.text('Đã nhận được hàng'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const Key('tracking-complete-order-button')),
    );
    await tester.tap(find.byKey(const Key('tracking-complete-order-button')));
    await tester.pump();

    expect(orderProvider.completeOrderCallCount, 1);
    expect(orderProvider.completedOrderId, 'order-123456789');
    expect(orderProvider.completedUserId, 1);
  });

  testWidgets('completed status shows no completion action', (tester) async {
    orderProvider.setHistory([_order(status: OrderStatus.completed)]);

    await _pumpTracking(tester, orderProvider, 'order-123456789');

    expect(
      find.byKey(const Key('tracking-completed-no-action')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('tracking-complete-order-button')),
      findsNothing,
    );
    expect(find.byKey(const Key('tracking-chat-button')), findsNothing);
    expect(find.text('Đơn đã hoàn tất. Cảm ơn bạn đã đặt món.'), findsWidgets);
    expect(find.byKey(const Key('tracking-completed-copy')), findsOneWidget);
  });

  testWidgets('opens invoice from tracking screen', (tester) async {
    orderProvider.setActiveOrders([_order(status: OrderStatus.confirmed)]);

    await _pumpTracking(tester, orderProvider, 'order-123456789');

    await tester.ensureVisible(
      find.byKey(const Key('tracking-view-invoice-button')),
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('tracking-view-invoice-button')));
    await tester.pumpAndSettle();

    expect(find.text('Hóa đơn'), findsOneWidget);
    expect(find.byKey(const Key('invoice-summary-card')), findsOneWidget);
    expect(find.text('PHENIKAA FOOD APP'), findsOneWidget);
    expect(find.byKey(const Key('invoice-final-total')), findsOneWidget);
  });
}

Future<void> _pumpTracking(
  WidgetTester tester,
  _TestOrderProvider orderProvider,
  String orderId,
) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<OrderProvider>.value(
      value: orderProvider,
      child: MaterialApp(home: TrackingOrderScreen(orderId: orderId)),
    ),
  );
}

OrderModel _order({required OrderStatus status}) {
  return OrderModel(
    orderId: 'order-123456789',
    userId: 1,
    items: [
      OrderItemModel(
        productId: 1,
        productName: 'Test Burger',
        quantity: 2,
        unitPrice: 30000,
      ),
      OrderItemModel(
        productId: 2,
        productName: 'Test Drink',
        quantity: 1,
        unitPrice: 15000,
      ),
    ],
    totalAmount: 75000,
    paymentMethod: PaymentMethod.cod,
    deliveryAddress: 'Phenikaa University',
    note: 'Gọi khi tới cổng',
    status: status,
    shipperName: 'Test Shipper',
    createdAt: DateTime(2026, 5, 14, 12, 30),
  );
}

class _TestOrderProvider extends OrderProvider {
  _TestOrderProvider() : super(OrderService());

  final List<OrderModel> _activeOrders = [];
  final List<OrderModel> _history = [];
  int completeOrderCallCount = 0;
  String? completedOrderId;
  int? completedUserId;

  void setActiveOrders(List<OrderModel> orders) {
    _activeOrders
      ..clear()
      ..addAll(orders);
    notifyListeners();
  }

  void setHistory(List<OrderModel> orders) {
    _history
      ..clear()
      ..addAll(orders);
    notifyListeners();
  }

  @override
  List<OrderModel> get activeOrders => List.unmodifiable(_activeOrders);

  @override
  List<OrderModel> get orderHistory => List.unmodifiable(_history);

  @override
  Future<void> loadOrders(int userId) async {}

  @override
  Future<void> completeOrder(String orderId, int userId) async {
    completeOrderCallCount++;
    completedOrderId = orderId;
    completedUserId = userId;
  }
}
