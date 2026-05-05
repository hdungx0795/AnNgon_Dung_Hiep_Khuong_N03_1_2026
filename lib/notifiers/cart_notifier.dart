import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/mon_an.dart';

class CartNotifier extends ChangeNotifier {
  final List<CartItem> _items;

  CartNotifier({List<CartItem>? initialItems})
      : _items = List<CartItem>.from(initialItems ?? const []);

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalLines => _items.length;

  int get totalQuantity {
    var sum = 0;
    for (final item in _items) {
      sum += item.quantity;
    }
    return sum;
  }

  double get totalAmount {
    var sum = 0.0;
    for (final item in _items) {
      sum += item.getLineTotal();
    }
    return sum;
  }

  void addMonAn(MonAn monAn, {int quantity = 1}) {
    if (quantity <= 0) return;

    final index = _items.indexWhere((e) => e.productId == monAn.id);
    if (index == -1) {
      _items.add(
        CartItem(
          productId: monAn.id,
          productName: monAn.name,
          quantity: quantity,
          unitPrice: monAn.price,
        ),
      );
      notifyListeners();
      return;
    }

    final current = _items[index];
    _items[index] = current.copyWith(quantity: current.quantity + quantity);
    notifyListeners();
  }

  void increase(int productId) {
    final index = _items.indexWhere((e) => e.productId == productId);
    if (index == -1) return;

    final current = _items[index];
    _items[index] = current.copyWith(quantity: current.quantity + 1);
    notifyListeners();
  }

  void decrease(int productId) {
    final index = _items.indexWhere((e) => e.productId == productId);
    if (index == -1) return;

    final current = _items[index];
    final nextQty = current.quantity - 1;
    if (nextQty <= 0) {
      _items.removeAt(index);
      notifyListeners();
      return;
    }

    _items[index] = current.copyWith(quantity: nextQty);
    notifyListeners();
  }

  void remove(int productId) {
    final before = _items.length;
    _items.removeWhere((e) => e.productId == productId);
    if (_items.length != before) notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}

