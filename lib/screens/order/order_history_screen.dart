import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/product_service.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/format_utils.dart';
import '../../models/enums/order_status.dart';
import '../tracking/tracking_order_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text('Vui lòng đăng nhập')));

    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử đơn hàng')),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final history = orderProvider.orderHistory;

          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('Bạn chưa có đơn hàng nào', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final order = history[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrackingOrderScreen(orderId: order.orderId),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Đơn hàng #${order.orderId.substring(0, 8)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              order.status.displayName,
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          FormatUtils.formatDate(order.createdAt),
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const Divider(height: 24),
                        Text(order.itemsSummary, maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tổng cộng: ${FormatUtils.formatCurrency(order.finalAmount)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                            OutlinedButton(
                              onPressed: () async {
                                final cartProvider = context.read<CartProvider>();
                                final productService = context.read<ProductService>();
                                final userPhone = user.phone;

                                int addedCount = 0;
                                for (var item in order.items) {
                                  final product = await productService.getProductById(item.productId);
                                  if (product != null) {
                                    await cartProvider.addItem(userPhone, product, item.quantity);
                                    addedCount++;
                                  }
                                }

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Đã thêm $addedCount sản phẩm vào giỏ hàng!'),
                                      action: SnackBarAction(
                                        label: 'XEM GIỎ',
                                        onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Đặt lại'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
