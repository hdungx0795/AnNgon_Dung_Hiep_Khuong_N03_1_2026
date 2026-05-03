// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/enums/order_status.dart';
import '../chat/delivery_chat_screen.dart';
import '../chat/delivery_call_screen.dart';
import 'widgets/order_status_timeline.dart';
import 'widgets/tracking_header.dart';

class TrackingOrderScreen extends StatelessWidget {
  final String orderId;

  const TrackingOrderScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theo dõi đơn hàng'),
        elevation: 0,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          // Find the order in active orders
          final order = orderProvider.activeOrders.followedBy(orderProvider.orderHistory)
              .firstWhere((o) => o.orderId == orderId, orElse: () => throw Exception('Order not found'));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TrackingHeader(order: order),
                const SizedBox(height: 30),
                const Text(
                  'Trạng thái đơn hàng', 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                ),
                const SizedBox(height: 20),
                OrderStatusTimeline(currentStatus: order.status),
                const SizedBox(height: 30),
                _buildShipperInfo(context, order),
                _buildCompleteOrderButton(context, orderProvider, order),
                const SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShipperInfo(BuildContext context, OrderModel order) {
    if (order.status.index < OrderStatus.delivering.index) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25, 
            backgroundColor: AppColors.primary, 
            child: Icon(Icons.person, color: Colors.white)
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tài xế giao hàng', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(order.shipperName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeliveryChatScreen(shipperName: order.shipperName),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.phone_outlined, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeliveryCallScreen(shipperName: order.shipperName),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCompleteOrderButton(BuildContext context, OrderProvider orderProvider, OrderModel order) {
    if (order.status != OrderStatus.delivered) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => orderProvider.completeOrder(order.orderId, order.userId),
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Da nhan duoc hang'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}
