import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();
  List<CartItemModel> _items = [];

  List<CartItemModel> get items => List.unmodifiable(_items);

  int get totalAmount {
    return _items.where((i) => i.isSelected).fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get itemCount => _items.length;
  bool get isAllSelected => _items.isNotEmpty && _items.every((i) => i.isSelected);

  Future<void> loadCart(String phone) async {
    _items = await _cartService.getCart(phone);
    notifyListeners();
  }

  Future<void> addItem(String phone, ProductModel product, int quantity) async {
    await _cartService.addToCart(phone, product, quantity);
    await loadCart(phone);
  }

  Future<void> updateQuantity(String phone, int productId, int quantity) async {
    await _cartService.updateQuantity(phone, productId, quantity);
    await loadCart(phone);
  }

  Future<void> removeItem(String phone, int productId) async {
    await _cartService.removeFromCart(phone, productId);
    await loadCart(phone);
  }

  Future<void> toggleSelect(String phone, int productId) async {
    await _cartService.toggleSelect(phone, productId);
    await loadCart(phone);
  }

  Future<void> selectAll(String phone, bool value) async {
    await _cartService.selectAll(phone, value);
    await loadCart(phone);
  }

  Future<void> clearCart(String phone) async {
    await _cartService.clearCart(phone);
    await loadCart(phone);
  }

  Future<void> clearSelected(String phone) async {
    await _cartService.clearSelected(phone);
    await loadCart(phone);
  }
}
