import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_sizes.dart';
import '../../models/order_model.dart';
import '../../models/product_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../screens/order/widgets/order_summary_card.dart';
import '../../services/product_service.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_state.dart';
import '../../widgets/section_header.dart';
import '../tracking/tracking_order_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lịch sử đơn hàng')),
        body: EmptyState(
          icon: Icons.lock_outline,
          title: 'Đăng nhập để xem lịch sử',
          message: 'Các đơn đã hoàn tất được lưu theo tài khoản của bạn.',
          actionLabel: 'Đăng nhập',
          onActionPressed: () => Navigator.pushNamed(context, '/login'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử đơn hàng')),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return const LoadingState(message: 'Đang tải lịch sử đơn hàng...');
          }

          final history = orderProvider.orderHistory;
          if (history.isEmpty) {
            return EmptyState(
              icon: Icons.history_outlined,
              title: 'Chưa có đơn đã hoàn tất',
              message: 'Các đơn đã giao xong sẽ xuất hiện tại đây.',
              actionLabel: 'Tiếp tục mua món',
              onActionPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSizes.md),
            children: [
              SectionHeader(
                title: 'Đơn đã hoàn tất',
                subtitle: '${history.length} đơn trong lịch sử',
              ),
              const SizedBox(height: AppSizes.md),
              for (final order in history)
                OrderSummaryCard(
                  order: order,
                  onTap: () => _openTracking(context, order.orderId),
                  onReorder: () => _reorder(context, user.phone, order),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _reorder(
    BuildContext context,
    String userPhone,
    OrderModel order,
  ) async {
    final cartProvider = context.read<CartProvider>();
    final productService = context.read<ProductService>();

    final result = await reorderOrderItems(
      order: order,
      findProduct: productService.getProductById,
      addToCart: (product, quantity) =>
          cartProvider.addItem(userPhone, product, quantity),
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.feedbackMessage),
        action: result.addedCount > 0
            ? SnackBarAction(
                label: 'XEM GIỎ',
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
              )
            : null,
      ),
    );
  }

  void _openTracking(BuildContext context, String orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrackingOrderScreen(orderId: orderId),
      ),
    );
  }
}

class ReorderResult {
  const ReorderResult({required this.addedCount, required this.totalCount});

  final int addedCount;
  final int totalCount;

  String get feedbackMessage {
    if (addedCount == totalCount) {
      return 'Đã thêm $addedCount sản phẩm vào giỏ hàng!';
    }
    if (addedCount == 0) {
      return 'Không thể thêm lại sản phẩm từ đơn này.';
    }
    return 'Đã thêm $addedCount/$totalCount sản phẩm còn bán vào giỏ hàng.';
  }
}

Future<ReorderResult> reorderOrderItems({
  required OrderModel order,
  required Future<ProductModel?> Function(int productId) findProduct,
  required Future<void> Function(ProductModel product, int quantity) addToCart,
}) async {
  var addedCount = 0;
  for (final item in order.items) {
    final product = await findProduct(item.productId);
    if (product != null) {
      await addToCart(product, item.quantity);
      addedCount++;
    }
  }

  return ReorderResult(addedCount: addedCount, totalCount: order.items.length);
}
