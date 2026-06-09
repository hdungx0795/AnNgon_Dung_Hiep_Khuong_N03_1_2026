import 'package:hive/hive.dart';

part 'order_item_model.g.dart';

@HiveType(typeId: 6)
class OrderItemModel {
  @HiveField(0)
  final int productId;
  
  @HiveField(1)
  final String productName;
  
  @HiveField(2)
  final int quantity;
  
  @HiveField(3)
  final int unitPrice;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  int get totalPrice => unitPrice * quantity;
}
