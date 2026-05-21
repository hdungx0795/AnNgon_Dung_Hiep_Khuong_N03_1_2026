import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/models/enums/order_status.dart';
import 'package:pka_food/models/enums/payment_method.dart';
import 'package:pka_food/models/order_item_model.dart';
import 'package:pka_food/models/order_model.dart';

void main() {
  test('OrderModel finalAmount subtracts discount from total amount', () {
    final order = OrderModel(
      orderId: 'order-1',
      userId: 1,
      items: [
        OrderItemModel(productId: 1, productName: 'Burger', quantity: 2, unitPrice: 50000),
      ],
      totalAmount: 100000,
      paymentMethod: PaymentMethod.cod,
      deliveryAddress: 'Phenikaa',
      note: '',
      status: OrderStatus.created,
      shipperName: 'Shipper',
      createdAt: DateTime(2026, 4, 22),
      discount: 15000,
    );

    expect(order.finalAmount, 85000);
    expect(order.items.first.totalPrice, 100000);
  });

  group('OrderModel and OrderItemModel Serialization', () {
    test('toJson and fromJson round-trip matches original values', () {
      final order = OrderModel(
        orderId: 'order-999',
        userId: 2,
        items: [
          OrderItemModel(
            productId: 5,
            productName: 'Fried Rice',
            quantity: 3,
            unitPrice: 45000,
          ),
        ],
        totalAmount: 135000,
        paymentMethod: PaymentMethod.ewallet,
        deliveryAddress: 'Hanoi',
        note: 'No spicy',
        status: OrderStatus.delivering,
        shipperName: 'Shipper A',
        createdAt: DateTime(2026, 5, 21, 10, 30, 0),
        voucherCode: 'FREESHIP',
        discount: 15000,
      );

      final jsonMap = order.toJson();
      final roundTripOrder = OrderModel.fromJson(jsonMap);

      expect(roundTripOrder.orderId, order.orderId);
      expect(roundTripOrder.userId, order.userId);
      expect(roundTripOrder.items.length, order.items.length);
      expect(roundTripOrder.items.first.productId, order.items.first.productId);
      expect(roundTripOrder.items.first.productName, order.items.first.productName);
      expect(roundTripOrder.items.first.quantity, order.items.first.quantity);
      expect(roundTripOrder.items.first.unitPrice, order.items.first.unitPrice);
      expect(roundTripOrder.totalAmount, order.totalAmount);
      expect(roundTripOrder.paymentMethod, order.paymentMethod);
      expect(roundTripOrder.deliveryAddress, order.deliveryAddress);
      expect(roundTripOrder.note, order.note);
      expect(roundTripOrder.status, order.status);
      expect(roundTripOrder.shipperName, order.shipperName);
      expect(roundTripOrder.createdAt, order.createdAt);
      expect(roundTripOrder.voucherCode, order.voucherCode);
      expect(roundTripOrder.discount, order.discount);
    });
  });
}
