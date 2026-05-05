import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/app_repository.dart';

class DonHangCuaToiPage extends StatelessWidget {
  const DonHangCuaToiPage({super.key, required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<AppRepository>();
    final donHangs = repository.getDonHangsByUser(userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng của tôi'),
      ),
      body: donHangs.isEmpty
          ? const Center(
              child: Text('Bạn chưa có đơn hàng nào.'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: donHangs.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final donHang = donHangs[index];
                final chiTietByOrder = repository.getChiTietByOrderId(donHang.orderId);

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('#${index + 1}')),
                    title: Text('Đơn ${donHang.orderId} - ${donHang.getStatusLabel()}'),
                    subtitle: Text(
                      'Số món: ${chiTietByOrder.length} • ${donHang.getFormattedTotalAmount()}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (_) => Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chi tiết đơn ${donHang.orderId}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text('Địa chỉ: ${donHang.deliveryAddress}'),
                              Text('Thanh toán: ${donHang.paymentMethod}'),
                              Text('Trạng thái: ${donHang.getStatusLabel()}'),
                              Text('Tổng tiền: ${donHang.getFormattedTotalAmount()}'),
                              Text('Ghi chú: ${donHang.note ?? 'Không có'}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

