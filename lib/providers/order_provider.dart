import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../models/enums/payment_method.dart';
import '../models/voucher_model.dart';
import '../services/order_service.dart';

import 'package:hive_flutter/hive_flutter.dart';
import '../services/database_service.dart';

class OrderProvider extends ChangeNotifier {
  OrderProvider(this._orderService) {
    _initListener();
  }

  final OrderService _orderService;
  int? _currentUserId;

  void _initListener() {
    Hive.box<OrderModel>(DatabaseService.ordersBoxName).watch().listen((_) {
      if (_currentUserId != null) {
        loadOrders(_currentUserId!);
      }
    });
  }

  List<OrderModel> _activeOrders = [];
  List<OrderModel> _orderHistory = [];
  bool _isLoading = false;

  List<OrderModel> get activeOrders => _activeOrders;
  List<OrderModel> get orderHistory => _orderHistory;
  bool get isLoading => _isLoading;

  Future<void> loadOrders(int userId) async {
    _currentUserId = userId;
    _isLoading = true;
    notifyListeners();

    _activeOrders = await _orderService.getActiveOrders(userId);
    _orderHistory = await _orderService.getOrderHistory(userId);

    _isLoading = false;
    notifyListeners();
  }

  Future<OrderModel> placeOrder({
    required int userId,
    required List<CartItemModel> items,
    required PaymentMethod paymentMethod,
    required String address,
    required String note,
    VoucherModel? voucher,
  }) async {
    final order = await _orderService.createOrder(
      userId: userId,
      items: items,
      paymentMethod: paymentMethod,
      address: address,
      note: note,
      voucher: voucher,
    );
    
    await loadOrders(userId);
    return order;
  }

  Future<void> completeOrder(String orderId, int userId) async {
    await _orderService.completeOrder(orderId);
    await loadOrders(userId);
  }
}
