import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../models/enums/order_status.dart';
import 'tracking_header.dart';

class OrderStatusTimeline extends StatelessWidget {
  const OrderStatusTimeline({super.key, required this.currentStatus});

  final OrderStatus currentStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statuses = OrderStatus.values;
    final currentStatusIndex = currentStatus.index;

    return Card(
      key: const Key('tracking-status-timeline'),
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
            Text(
              'Trạng thái đơn hàng',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            for (final status in statuses)
              _TimelineStep(
                status: status,
                isCompleted: status.index <= currentStatusIndex,
                isCurrent: status == currentStatus,
                isLast: status == statuses.last,
              ),
          ],
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.status,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLast,
  });

  final OrderStatus status;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeColor = trackingStatusColor(colorScheme, status);
    final inactiveColor = colorScheme.outlineVariant;

    return Row(
      key: Key('tracking-step-${status.name}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isCompleted ? activeColor : colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCurrent
                      ? activeColor
                      : isCompleted
                      ? activeColor
                      : inactiveColor,
                  width: isCurrent ? 3 : 1,
                ),
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.circle,
                size: isCompleted ? 16 : 8,
                color: isCompleted ? colorScheme.onPrimary : inactiveColor,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 44,
                color: isCompleted ? activeColor : inactiveColor,
              ),
          ],
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.displayName,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                    color: isCompleted
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                if (isCurrent) ...[
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    trackingEtaCopy(status),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
