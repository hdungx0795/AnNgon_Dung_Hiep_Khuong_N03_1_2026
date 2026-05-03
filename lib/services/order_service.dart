import 'dart:async';
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

  Box<OrderModel> get _ordersBox => Hive.box<OrderModel>(DatabaseService.ordersBoxName);

  Future<OrderModel> createOrder({
    required int userId,
    required List<CartItemModel> items,
    required PaymentMethod paymentMethod,
    required String address,
    required String note,
    VoucherModel? voucher,
  }) async {
    final orderId = const Uuid().v4();
    final orderItems = items.map((i) => OrderItemModel(
      productId: i.product.id,
      productName: i.product.name,
      quantity: i.quantity,
      unitPrice: i.product.price,
    )).toList();

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
        .where((o) => o.userId == userId && o.status.index < OrderStatus.completed.index)
        .toList();
  }

  Future<List<OrderModel>> getOrderHistory(int userId) async {
    return _ordersBox.values
        .where((o) => o.userId == userId && o.status.index >= OrderStatus.completed.index)
        .toList();
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final order = _ordersBox.get(orderId);
    if (order != null) {
      await _ordersBox.put(orderId, order.copyWith(status: status));
      
      // Notify user
      NotificationService().showNotification(
        id: orderId.hashCode,
        title: 'Cập nhật đơn hàng #${orderId.substring(0, 8)}',
        body: 'Trạng thái mới: ${status.displayName}',
      );
    }
  }

  Future<void> completeOrder(String orderId) async {
    await updateOrderStatus(orderId, OrderStatus.completed);
  }

  void startDeliverySimulation(String orderId) {
    // Simulated delivery workflow
    Timer(const Duration(seconds: 10), () => updateOrderStatus(orderId, OrderStatus.confirmed));
    Timer(const Duration(seconds: 30), () => updateOrderStatus(orderId, OrderStatus.preparing));
    Timer(const Duration(seconds: 60), () async {
      final order = _ordersBox.get(orderId);
      if (order != null) {
        await updateOrderStatus(orderId, OrderStatus.delivering);
        // We can't update shipperName via updateOrderStatus easily without copyWith logic outside
        final updatedOrder = _ordersBox.get(orderId);
        if (updatedOrder != null) {
          _ordersBox.put(orderId, updatedOrder.copyWith(shipperName: 'Nguyễn Văn Tài'));
        }
      }
    });
    Timer(const Duration(seconds: 120), () => updateOrderStatus(orderId, OrderStatus.delivered));
  }
}
