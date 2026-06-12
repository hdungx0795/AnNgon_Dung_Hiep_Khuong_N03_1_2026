// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pka_food/providers/order_provider.dart';
import 'package:pka_food/providers/auth_provider.dart';
import 'package:pka_food/core/constants/app_colors.dart';
import 'package:pka_food/core/utils/format_utils.dart';
import 'package:pka_food/models/enums/order_status.dart';
import 'package:pka_food/screens/tracking/tracking_order_screen.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    if (user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Vui lòng đăng nhập để xem đơn hàng'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Đăng nhập'),
            ),
          ],
        ),
      );
    }

    final orderProvider = context.watch<OrderProvider>();
    final activeOrders = orderProvider.activeOrders;

    if (activeOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: 80, color: Colors.grey[200]),
            const SizedBox(height: 16),
            const Text('Hiện không có đơn hàng nào đang xử lý', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Switch to explore tab if possible via some logic, 
                // but for now just a hint.
              },
              child: const Text('Khám phá món ngon ngay'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeOrders.length,
      itemBuilder: (context, index) {
        final order = activeOrders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delivery_dining, color: AppColors.primary),
            ),
            title: Text(
              'Đơn hàng: #${order.orderId.substring(0, 8)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Trạng thái: ${order.status.displayName}', 
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500)),
                Text(order.itemsSummary, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(FormatUtils.formatCurrency(order.finalAmount), 
                  style: const TextStyle(fontWeight: FontWeight.bold)),
                const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrackingOrderScreen(orderId: order.orderId),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
