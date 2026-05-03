import 'package:hive/hive.dart';
import 'product_model.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 8)
class CartItemModel {
  @HiveField(0)
  final ProductModel product;
  
  @HiveField(1)
  int quantity;
  
  @HiveField(2)
  bool isSelected;

  CartItemModel({
    required this.product,
    this.quantity = 1,
    this.isSelected = true,
  });

  int get totalPrice => product.price * quantity;
}
