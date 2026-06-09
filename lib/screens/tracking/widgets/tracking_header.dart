// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../models/order_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/format_utils.dart';
import '../../../models/enums/order_status.dart';

class TrackingHeader extends StatelessWidget {
  final OrderModel order;

  const TrackingHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mã đơn: #${order.orderId.substring(0, 8)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status.displayName.toUpperCase(),
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          ...order.items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${item.quantity}x ${item.productName}', style: const TextStyle(color: Colors.black87)),
                Text(FormatUtils.formatCurrency(item.totalPrice), style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          )),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng thanh toán', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                FormatUtils.formatCurrency(order.finalAmount),
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
