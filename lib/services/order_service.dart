import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/order_model.dart';
import '../models/order_item_model.dart';
import '../models/cart_item_model.dart';
import '../models/voucher_model.dart';
import '../models/enums/order_status.dart';
import '../models/enums/payment_method.dart';
import 'database_service.dart';
import 'notification_service.dart';

class OrderService {
  static final OrderService _instance = OrderService._();
  factory OrderService() => _instance;
  OrderService._();

  Box<OrderModel> get _ordersBox =>
      Hive.box<OrderModel>(DatabaseService.ordersBoxName);
  final Map<String, List<Timer>> _deliveryTimers = {};

  Future<OrderModel> createOrder({
    required int userId,
    required List<CartItemModel> items,
    required PaymentMethod paymentMethod,
    required String address,
    required String note,
    VoucherModel? voucher,
  }) async {
    final orderId = const Uuid().v4();
    final orderItems = items
        .map(
          (i) => OrderItemModel(
            productId: i.product.id,
            productName: i.product.name,
            quantity: i.quantity,
            unitPrice: i.product.price,
          ),
        )
        .toList();

    final totalAmount = items.fold(0, (sum, i) => sum + i.totalPrice);
    final discount = voucher?.calculateDiscount(totalAmount) ?? 0;

    final order = OrderModel(
      orderId: orderId,
      userId: userId,
      items: orderItems,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      deliveryAddress: address,
      note: note,
      status: OrderStatus.created,
      shipperName: 'Đang tìm shipper...',
      createdAt: DateTime.now(),
      voucherCode: voucher?.code,
      discount: discount,
    );

    await _ordersBox.put(orderId, order);

    // Start simulation
    startDeliverySimulation(orderId);

    return order;
  }

  Future<List<OrderModel>> getActiveOrders(int userId) async {
    return _ordersBox.values
        .where(
          (o) =>
              o.userId == userId &&
              o.status.index < OrderStatus.completed.index,
        )
        .toList();
  }

  Future<List<OrderModel>> getOrderHistory(int userId) async {
    return _ordersBox.values
        .where(
          (o) =>
              o.userId == userId &&
              o.status.index >= OrderStatus.completed.index,
        )
        .toList();
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final order = _ordersBox.get(orderId);
    if (order == null ||
        order.status == OrderStatus.completed ||
        status.index <= order.status.index) {
      return;
    }

    await _ordersBox.put(orderId, order.copyWith(status: status));

    // Notify user
    NotificationService().showNotification(
      id: orderId.hashCode,
      title: 'Cập nhật đơn hàng #${_shortOrderId(orderId)}',
      body: 'Trạng thái mới: ${status.displayName}',
    );
  }

  Future<void> completeOrder(String orderId) async {
    _cancelDeliveryTimers(orderId);
    await updateOrderStatus(orderId, OrderStatus.completed);
  }

  void startDeliverySimulation(String orderId) {
    _startDeliverySimulation(orderId, const [
      Duration(seconds: 10),
      Duration(seconds: 30),
      Duration(seconds: 60),
      Duration(seconds: 120),
    ]);
  }

  void _startDeliverySimulation(String orderId, List<Duration> delays) {
    final order = _ordersBox.get(orderId);
    if (order == null || order.status == OrderStatus.completed) {
      return;
    }

    _cancelDeliveryTimers(orderId);

    // Simulated delivery workflow
    _deliveryTimers[orderId] = [
      Timer(
        delays[0],
        () => _advanceOrderStatus(orderId, OrderStatus.confirmed),
      ),
      Timer(
        delays[1],
        () => _advanceOrderStatus(orderId, OrderStatus.preparing),
      ),
      Timer(
        delays[2],
        () => _advanceOrderStatus(
          orderId,
          OrderStatus.delivering,
          shipperName: 'Nguyễn Văn Tài',
        ),
      ),
      Timer(delays[3], () async {
        await _advanceOrderStatus(orderId, OrderStatus.delivered);
        _deliveryTimers.remove(orderId);
      }),
    ];
  }

  Future<void> _advanceOrderStatus(
    String orderId,
    OrderStatus status, {
    String? shipperName,
  }) async {
    final order = _ordersBox.get(orderId);
    if (order == null) {
      _cancelDeliveryTimers(orderId);
      return;
    }

    if (order.status == OrderStatus.completed ||
        status.index <= order.status.index) {
      return;
    }

    final updatedOrder = order.copyWith(
      status: status,
      shipperName: shipperName,
    );
    await _ordersBox.put(orderId, updatedOrder);

    NotificationService().showNotification(
      id: orderId.hashCode,
      title: 'Cập nhật đơn hàng #${_shortOrderId(orderId)}',
      body: 'Trạng thái mới: ${status.displayName}',
    );
  }

  String _shortOrderId(String orderId) {
    if (orderId.length <= 8) {
      return orderId;
    }
    return orderId.substring(0, 8);
  }

  void _cancelDeliveryTimers(String orderId) {
    final timers = _deliveryTimers.remove(orderId);
    if (timers == null) {
      return;
    }

    for (final timer in timers) {
      timer.cancel();
    }
  }

  @visibleForTesting
  bool hasActiveDeliverySimulation(String orderId) {
    return _deliveryTimers.containsKey(orderId);
  }

  @visibleForTesting
  void cancelAllDeliverySimulations() {
    for (final orderId in _deliveryTimers.keys.toList()) {
      _cancelDeliveryTimers(orderId);
    }
  }

  @visibleForTesting
  void startDeliverySimulationWithDelays(
    String orderId,
    List<Duration> delays,
  ) {
    assert(delays.length == 4);
    _startDeliverySimulation(orderId, delays);
  }
}
