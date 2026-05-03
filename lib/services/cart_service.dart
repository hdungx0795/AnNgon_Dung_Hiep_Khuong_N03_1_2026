import 'package:hive_flutter/hive_flutter.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import 'database_service.dart';

class CartService {
  static final CartService _instance = CartService._();
  factory CartService() => _instance;
  CartService._();

  Box get _cartBox => Hive.box(DatabaseService.cartBoxName);

  Future<List<CartItemModel>> getCart(String phone) async {
    final List? data = _cartBox.get(phone);
    if (data == null) return [];
    return data.cast<CartItemModel>();
  }

  Future<void> _saveCart(String phone, List<CartItemModel> items) async {
    await _cartBox.put(phone, items);
  }

  Future<void> addToCart(String phone, ProductModel product, int qty) async {
    final items = await getCart(phone);
    final index = items.indexWhere((i) => i.product.id == product.id);
    
    if (index >= 0) {
      items[index].quantity += qty;
    } else {
      items.add(CartItemModel(product: product, quantity: qty));
    }
    await _saveCart(phone, items);
  }

  Future<void> updateQuantity(String phone, int productId, int qty) async {
    final items = await getCart(phone);
    final index = items.indexWhere((i) => i.product.id == productId);
    
    if (index >= 0) {
      if (qty <= 0) {
        items.removeAt(index);
      } else {
        items[index].quantity = qty;
      }
      await _saveCart(phone, items);
    }
  }

  Future<void> removeFromCart(String phone, int productId) async {
    final items = await getCart(phone);
    items.removeWhere((i) => i.product.id == productId);
    await _saveCart(phone, items);
  }

  Future<void> toggleSelect(String phone, int productId) async {
    final items = await getCart(phone);
    final index = items.indexWhere((i) => i.product.id == productId);
    if (index >= 0) {
      items[index].isSelected = !items[index].isSelected;
      await _saveCart(phone, items);
    }
  }

  Future<void> selectAll(String phone, bool value) async {
    final items = await getCart(phone);
    for (var item in items) {
      item.isSelected = value;
    }
    await _saveCart(phone, items);
  }

  Future<void> clearCart(String phone) async {
    await _cartBox.delete(phone);
  }

  Future<void> clearSelected(String phone) async {
    final items = await getCart(phone);
    items.removeWhere((i) => i.isSelected);
    await _saveCart(phone, items);
  }
}
