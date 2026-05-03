import 'package:hive/hive.dart';
import 'order_item_model.dart';
import 'enums/order_status.dart';
import 'enums/payment_method.dart';

part 'order_model.g.dart';

@HiveType(typeId: 2)
class OrderModel {
  @HiveField(0)
  final String orderId;
  
  @HiveField(1)
  final int userId;
  
  @HiveField(2)
  final List<OrderItemModel> items;
  
  @HiveField(3)
  final int totalAmount;
  
  @HiveField(4)
  final PaymentMethod paymentMethod;
  
  @HiveField(5)
  final String deliveryAddress;
  
  @HiveField(6)
  final String note;
  
  @HiveField(7)
  final OrderStatus status;
  
  @HiveField(8)
  final String shipperName;
  
  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final String? voucherCode;

  @HiveField(11)
  final int discount;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.note,
    required this.status,
    required this.shipperName,
    required this.createdAt,
    this.voucherCode,
    this.discount = 0,
  });

  int get finalAmount => totalAmount - discount;

  String get itemsSummary => items.map((i) => '${i.quantity}x ${i.productName}').join(', ');

  OrderModel copyWith({
    OrderStatus? status,
    String? shipperName,
    String? voucherCode,
    int? discount,
  }) {
    return OrderModel(
      orderId: orderId,
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      deliveryAddress: deliveryAddress,
      note: note,
      status: status ?? this.status,
      shipperName: shipperName ?? this.shipperName,
      createdAt: createdAt,
      voucherCode: voucherCode ?? this.voucherCode,
      discount: discount ?? this.discount,
    );
  }
}
