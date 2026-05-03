// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../models/enums/order_status.dart';
import '../../../core/constants/app_colors.dart';

class OrderStatusTimeline extends StatelessWidget {
  final OrderStatus currentStatus;

  const OrderStatusTimeline({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final statusList = OrderStatus.values;
    final currentStatusIndex = currentStatus.index;

    return Column(
      children: statusList.map((status) {
        final index = status.index;
        final isCompleted = index <= currentStatusIndex;
        final isCurrent = index == currentStatusIndex;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.primary : Colors.grey[300],
                    shape: BoxShape.circle,
                    border: isCurrent ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 5) : null,
                  ),
                ),
                if (index < statusList.length - 1)
                  Container(
                    width: 2,
                    height: 40,
                    color: index < currentStatusIndex ? AppColors.primary : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.displayName,
                    style: TextStyle(
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCompleted ? Colors.black : Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
