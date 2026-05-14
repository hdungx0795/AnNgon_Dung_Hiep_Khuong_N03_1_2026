import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_sizes.dart';
import '../../models/enums/order_status.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/primary_button.dart';
import '../chat/delivery_call_screen.dart';
import '../chat/delivery_chat_screen.dart';
import 'widgets/order_status_timeline.dart';
import 'widgets/tracking_header.dart';

class TrackingOrderScreen extends StatelessWidget {
  const TrackingOrderScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theo dõi đơn hàng'), elevation: 0),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final order = _findOrder(orderProvider);
          if (order == null) {
            return _buildOrderNotFound(context);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TrackingHeader(order: order),
                const SizedBox(height: AppSizes.md),
                OrderStatusTimeline(currentStatus: order.status),
                const SizedBox(height: AppSizes.md),
                _ShipperStatusCard(order: order),
                _CompleteOrderSection(
                  order: order,
                  onComplete: () =>
                      orderProvider.completeOrder(order.orderId, order.userId),
                ),
                const SizedBox(height: AppSizes.xl),
              ],
            ),
          );
        },
      ),
    );
  }

  OrderModel? _findOrder(OrderProvider orderProvider) {
    for (final candidate in orderProvider.activeOrders.followedBy(
      orderProvider.orderHistory,
    )) {
      if (candidate.orderId == orderId) {
        return candidate;
      }
    }
    return null;
  }

  Widget _buildOrderNotFound(BuildContext context) {
    return EmptyState(
      key: const Key('tracking-order-not-found'),
      icon: Icons.receipt_long_outlined,
      title: 'Không tìm thấy đơn hàng',
      message: 'Đơn hàng này không còn tồn tại hoặc đã được làm mới.',
      actionLabel: 'Quay lại',
      onActionPressed: () => Navigator.maybePop(context),
    );
  }
}

class _ShipperStatusCard extends StatelessWidget {
  const _ShipperStatusCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasAssignedShipper =
        order.status.index >= OrderStatus.delivering.index;
    final isCompleted = order.status == OrderStatus.completed;

    return Card(
      key: Key(
        hasAssignedShipper
            ? 'tracking-shipper-visible'
            : 'tracking-shipper-pending',
      ),
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: hasAssignedShipper
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHighest,
              child: Icon(
                hasAssignedShipper
                    ? Icons.person_outline
                    : Icons.delivery_dining_outlined,
                color: hasAssignedShipper
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasAssignedShipper ? 'Tài xế giao hàng' : 'Đang điều phối',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    hasAssignedShipper
                        ? order.shipperName
                        : 'Tài xế sẽ xuất hiện khi đơn bắt đầu giao.',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (isCompleted) ...[
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      'Đơn đã hoàn tất, không cần thao tác thêm.',
                      key: const Key('tracking-completed-copy'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (hasAssignedShipper && !isCompleted) ...[
              IconButton(
                key: const Key('tracking-chat-button'),
                tooltip: 'Nhắn tin',
                icon: const Icon(Icons.chat_bubble_outline),
                color: colorScheme.primary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DeliveryChatScreen(shipperName: order.shipperName),
                    ),
                  );
                },
              ),
              IconButton(
                key: const Key('tracking-call-button'),
                tooltip: 'Gọi tài xế',
                icon: const Icon(Icons.phone_outlined),
                color: Colors.green,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DeliveryCallScreen(shipperName: order.shipperName),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompleteOrderSection extends StatelessWidget {
  const _CompleteOrderSection({required this.order, required this.onComplete});

  final OrderModel order;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    if (order.status == OrderStatus.completed) {
      return const SizedBox.shrink(key: Key('tracking-completed-no-action'));
    }

    if (order.status != OrderStatus.delivered) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.md),
      child: PrimaryButton(
        key: const Key('tracking-complete-order-button'),
        label: 'Đã nhận được hàng',
        icon: Icons.check_circle_outline,
        onPressed: onComplete,
      ),
    );
  }
}
