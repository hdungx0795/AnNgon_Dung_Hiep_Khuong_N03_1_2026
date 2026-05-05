import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifiers/cart_notifier.dart';
import '../repositories/app_repository.dart';

class GioHangPage extends StatelessWidget {
  const GioHangPage({
    super.key,
    required this.userId,
    this.onOrderCreatedNavigate,
  });

  final int userId;
  final VoidCallback? onOrderCreatedNavigate;

  void _taoDonHang(BuildContext context, CartNotifier cart) {
    final items = List.of(cart.items);
    if (items.isEmpty) return;

    context.read<AppRepository>().createOrderFromCart(
          userId: userId,
          cartItems: items,
        );
    cart.clear();
    onOrderCreatedNavigate?.call();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartNotifier>();
    final items = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: cart.clear,
              child: const Text('Xoa het'),
            ),
        ],
      ),
      body: items.isEmpty
          ? const Center(
              child: Text('Gio hang trong.'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('${item.quantity}x'),
                          ),
                          title: Text(item.productName),
                          subtitle: Text(
                            '${item.unitPrice.toStringAsFixed(0)} VND / mon',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Giam',
                                onPressed: () => cart.decrease(item.productId),
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              Text(
                                item.getFormattedLineTotal(),
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              IconButton(
                                tooltip: 'Tang',
                                onPressed: () => cart.increase(item.productId),
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tam tinh',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${cart.totalAmount.toStringAsFixed(0)} VND',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _taoDonHang(context, cart),
                            icon: const Icon(Icons.shopping_bag_outlined),
                            label: const Text('Tao don'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
