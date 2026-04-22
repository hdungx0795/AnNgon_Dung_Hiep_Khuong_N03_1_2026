import 'package:flutter/material.dart';

import 'data/mock_data.dart';
import 'models/mon_an.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'An Ngon App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MonAnListPage(title: 'Danh sách món ăn'),
    );
  }
}

class MonAnListPage extends StatelessWidget {
  const MonAnListPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Đơn hàng của tôi',
            icon: const Icon(Icons.receipt_long),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const DonHangCuaToiPage(
                    userId: 23010438,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: mockMonAns.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final monAn = mockMonAns[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(monAn.id.toString()),
              ),
              title: Text(monAn.getDisplayName()),
              subtitle: Text('${monAn.category} • ${monAn.getFormattedPrice()}'),
              trailing: Text('⭐ ${monAn.rating}'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MonAnDetailPage(monAn: monAn),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.receipt_long),
        label: const Text('Đơn hàng của tôi'),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const DonHangCuaToiPage(
                userId: 23010438,
              ),
            ),
          );
        },
      ),
    );
  }
}

class MonAnDetailPage extends StatelessWidget {
  const MonAnDetailPage({super.key, required this.monAn});

  final MonAn monAn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(monAn.getDisplayName()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              monAn.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Danh mục: ${monAn.category}'),
            Text('Giá: ${monAn.getFormattedPrice()}'),
            Text('Đánh giá: ${monAn.rating} / 5'),
            const SizedBox(height: 16),
            Text(monAn.description),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã thêm "${monAn.name}" vào đơn tạm thời'),
                    ),
                  );
                },
                child: const Text('Đặt món'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DonHangCuaToiPage extends StatelessWidget {
  const DonHangCuaToiPage({super.key, required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context) {
    final donHangs = mockDonHangs.where((item) => item.userId == userId).toList();

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
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final donHang = donHangs[index];
                final orderIdAsInt = int.tryParse(donHang.orderId);
                final chiTietByOrder = mockChiTietDonHangs
                    .where((item) => item.orderId == orderIdAsInt)
                    .toList();

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
