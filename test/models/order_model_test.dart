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
}
