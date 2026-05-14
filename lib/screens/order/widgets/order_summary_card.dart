// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/format_utils.dart';
import '../../../models/enums/order_status.dart';
import '../../../models/order_model.dart';
import '../../../widgets/price_text.dart';
import '../../../widgets/primary_button.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    super.key,
    required this.order,
    required this.onTap,
    this.onReorder,
    this.showProgress = false,
  });

  final OrderModel order;
  final VoidCallback onTap;
  final VoidCallback? onReorder;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      key: Key('order-card-${order.orderId}'),
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.7)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _statusColor(order.status).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: Icon(
                      _statusIcon(order.status),
                      color: _statusColor(order.status),
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đơn hàng ${formatOrderId(order.orderId)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          FormatUtils.formatDate(order.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusChip(status: order.status),
                ],
              ),
              if (showProgress) ...[
                const SizedBox(height: AppSizes.md),
                OrderProgressIndicator(status: order.status),
              ],
              const SizedBox(height: AppSizes.md),
              _OrderMetaRow(
                icon: Icons.restaurant_menu_outlined,
                label: '${order.items.length} mục',
                value: _itemsPreview(order),
              ),
              const SizedBox(height: AppSizes.sm),
              _OrderMetaRow(
                icon: Icons.location_on_outlined,
                label: 'Giao đến',
                value: order.deliveryAddress,
              ),
              const Divider(height: AppSizes.lg),
              Row(
                children: [
                  Expanded(
                    child: PriceText(
                      amount: order.finalAmount,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  if (onReorder != null)
                    SecondaryButton(
                      label: 'Đặt lại',
                      icon: Icons.replay_outlined,
                      fullWidth: false,
                      onPressed: onReorder,
                    )
                  else
                    Icon(
                      Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String formatOrderId(String orderId) {
    if (orderId.isEmpty) return '#';
    final visible = orderId.length <= 8 ? orderId : orderId.substring(0, 8);
    return '#$visible';
  }

  static String _itemsPreview(OrderModel order) {
    if (order.items.isEmpty) return 'Không có món';
    final firstItems = order.items
        .take(2)
        .map((item) {
          return '${item.quantity}x ${item.productName}';
        })
        .join(', ');
    final remaining = order.items.length - 2;
    if (remaining <= 0) return firstItems;
    return '$firstItems và $remaining món khác';
  }

  static Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.created:
        return AppColors.warning;
      case OrderStatus.confirmed:
      case OrderStatus.preparing:
        return AppColors.secondary;
      case OrderStatus.delivering:
        return AppColors.primary;
      case OrderStatus.delivered:
      case OrderStatus.completed:
        return AppColors.success;
    }
  }

  static IconData _statusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.created:
        return Icons.receipt_long_outlined;
      case OrderStatus.confirmed:
        return Icons.task_alt_outlined;
      case OrderStatus.preparing:
        return Icons.soup_kitchen_outlined;
      case OrderStatus.delivering:
        return Icons.delivery_dining_outlined;
      case OrderStatus.delivered:
        return Icons.inventory_2_outlined;
      case OrderStatus.completed:
        return Icons.check_circle_outline;
    }
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final color = OrderSummaryCard._statusColor(status);
    return Container(
      key: Key('order-status-${status.name}'),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.2)),
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

class OrderProgressIndicator extends StatelessWidget {
  const OrderProgressIndicator({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final color = OrderSummaryCard._statusColor(status);
    final progress = (status.index + 1) / OrderStatus.values.length;

    return Column(
      key: Key('order-progress-${status.name}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 6,
            backgroundColor: color.withOpacity(0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          'Tiến độ: ${status.displayName}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _OrderMetaRow extends StatelessWidget {
  const _OrderMetaRow({
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
          width: 72,
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
