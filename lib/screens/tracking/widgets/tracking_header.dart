import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/format_utils.dart';
import '../../../models/enums/order_status.dart';
import '../../../models/enums/payment_method.dart';
import '../../../models/order_model.dart';
import '../../../widgets/price_text.dart';

class TrackingHeader extends StatelessWidget {
  const TrackingHeader({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = trackingStatusColor(colorScheme, order.status);

    return Card(
      key: const Key('tracking-header'),
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Icon(
                    trackingStatusIcon(order.status),
                    color: statusColor,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đơn hàng ${formatTrackingOrderId(order.orderId)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        '${FormatUtils.formatDate(order.createdAt)} lúc ${FormatUtils.formatTime(order.createdAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                TrackingStatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            LinearProgressIndicator(
              key: Key('tracking-progress-${order.status.name}'),
              value: trackingProgressValue(order.status),
              minHeight: 8,
              borderRadius: BorderRadius.circular(999),
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              trackingEtaCopy(order.status),
              key: const Key('tracking-eta-copy'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(height: AppSizes.lg),
            _TrackingInfoRow(
              icon: Icons.location_on_outlined,
              label: 'Địa chỉ',
              value: order.deliveryAddress,
            ),
            const SizedBox(height: AppSizes.sm),
            _TrackingInfoRow(
              icon: Icons.payments_outlined,
              label: 'Thanh toán',
              value: order.paymentMethod.label,
            ),
            if (order.note.trim().isNotEmpty) ...[
              const SizedBox(height: AppSizes.sm),
              _TrackingInfoRow(
                icon: Icons.notes_outlined,
                label: 'Ghi chú',
                value: order.note,
              ),
            ],
            const Divider(height: AppSizes.lg),
            Text(
              'Món đã đặt',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            for (final item in order.items)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.quantity}x ${item.productName}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Text(
                      FormatUtils.formatCurrency(item.totalPrice),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            const Divider(height: AppSizes.lg),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tổng thanh toán',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                PriceText(amount: order.finalAmount),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TrackingStatusBadge extends StatelessWidget {
  const TrackingStatusBadge({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final color = trackingStatusColor(Theme.of(context).colorScheme, status);

    return Container(
      key: Key('tracking-status-${status.name}'),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        status.displayName,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _TrackingInfoRow extends StatelessWidget {
  const _TrackingInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppSizes.iconSm, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: AppSizes.sm),
        SizedBox(
          width: 82,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

String formatTrackingOrderId(String orderId) {
  if (orderId.isEmpty) return '#';
  final visible = orderId.length <= 8 ? orderId : orderId.substring(0, 8);
  return '#$visible';
}

double trackingProgressValue(OrderStatus status) {
  return ((status.index + 1) / OrderStatus.values.length).clamp(0, 1);
}

String trackingEtaCopy(OrderStatus status) {
  switch (status) {
    case OrderStatus.created:
      return 'Đơn mới được ghi nhận, quán sẽ xác nhận trong ít phút.';
    case OrderStatus.confirmed:
      return 'Quán đã xác nhận đơn và đang chuyển sang bếp.';
    case OrderStatus.preparing:
      return 'Món đang được chuẩn bị, tài xế sẽ được gán sau đó.';
    case OrderStatus.delivering:
      return 'Tài xế đang giao đơn, dự kiến tới trong 10-15 phút.';
    case OrderStatus.delivered:
      return 'Đơn đã được giao tới bạn. Xác nhận khi đã nhận hàng.';
    case OrderStatus.completed:
      return 'Đơn đã hoàn tất. Cảm ơn bạn đã đặt món.';
  }
}

IconData trackingStatusIcon(OrderStatus status) {
  switch (status) {
    case OrderStatus.created:
      return Icons.receipt_long_outlined;
    case OrderStatus.confirmed:
      return Icons.task_alt_outlined;
    case OrderStatus.preparing:
      return Icons.restaurant_menu_outlined;
    case OrderStatus.delivering:
      return Icons.delivery_dining_outlined;
    case OrderStatus.delivered:
      return Icons.inventory_2_outlined;
    case OrderStatus.completed:
      return Icons.check_circle_outline;
  }
}

Color trackingStatusColor(ColorScheme colorScheme, OrderStatus status) {
  switch (status) {
    case OrderStatus.created:
      return Colors.orange;
    case OrderStatus.confirmed:
    case OrderStatus.preparing:
      return colorScheme.tertiary;
    case OrderStatus.delivering:
      return colorScheme.primary;
    case OrderStatus.delivered:
    case OrderStatus.completed:
      return Colors.green;
  }
}
