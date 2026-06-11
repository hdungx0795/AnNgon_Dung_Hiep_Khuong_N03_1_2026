import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../screens/order/widgets/order_summary_card.dart';
import '../../../screens/tracking/tracking_order_screen.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/loading_state.dart';
import '../../../widgets/section_header.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    if (user == null) {
      return EmptyState(
        icon: Icons.lock_outline,
        title: 'Đăng nhập để xem đơn hàng',
        message: 'Các đơn đang xử lý sẽ được lưu theo tài khoản của bạn.',
        actionLabel: 'Đăng nhập',
        onActionPressed: () => Navigator.pushNamed(context, '/login'),
      );
    }

    final orderProvider = context.watch<OrderProvider>();
    if (orderProvider.isLoading) {
      return const LoadingState(message: 'Đang tải đơn hàng...');
    }

    final activeOrders = orderProvider.activeOrders;
    if (activeOrders.isEmpty) {
      return EmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'Chưa có đơn đang xử lý',
        message: 'Khi đặt món, trạng thái giao hàng sẽ hiển thị tại đây.',
        actionLabel: 'Khám phá món ngon',
        onActionPressed: () => Navigator.pushNamed(context, '/home'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSizes.md),
      children: [
        SectionHeader(
          title: 'Đơn đang xử lý',
          subtitle: '${activeOrders.length} đơn cần theo dõi',
        ),
        const SizedBox(height: AppSizes.md),
        for (final order in activeOrders)
          OrderSummaryCard(
            order: order,
            showProgress: true,
            onTap: () => _openTracking(context, order.orderId),
          ),
      ],
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
