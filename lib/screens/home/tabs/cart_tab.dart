import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/format_utils.dart';
import '../../../models/cart_item_model.dart';

class CartTab extends StatelessWidget {
  const CartTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    if (user == null) return const Center(child: Text('Vui lòng đăng nhập'));

    final cartProvider = context.watch<CartProvider>();
    final items = cartProvider.items;

    if (items.isEmpty) {
      return _EmptyCart(
        onExplorePressed: () =>
            Navigator.pushReplacementNamed(context, '/home'),
      );
    }

    final selectedQuantity = items
        .where((item) => item.isSelected)
        .fold<int>(0, (sum, item) => sum + item.quantity);
    final hasSelectedItems = selectedQuantity > 0;

    return Column(
      children: [
        _SelectAllHeader(
          isAllSelected: cartProvider.isAllSelected,
          onChanged: (value) =>
              cartProvider.selectAll(user.phone, value ?? false),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _CartItemCard(
                item: item,
                onSelected: () =>
                    cartProvider.toggleSelect(user.phone, item.product.id),
                onDecrease: () => cartProvider.updateQuantity(
                  user.phone,
                  item.product.id,
                  item.quantity - 1,
                ),
                onIncrease: () => cartProvider.updateQuantity(
                  user.phone,
                  item.product.id,
                  item.quantity + 1,
                ),
                onRemove: () =>
                    cartProvider.removeItem(user.phone, item.product.id),
              );
            },
          ),
        ),
        _CartSummaryBar(
          selectedQuantity: selectedQuantity,
          totalAmount: cartProvider.totalAmount,
          onCheckout: hasSelectedItems
              ? () => Navigator.pushNamed(context, '/checkout')
              : null,
        ),
      ],
    );
  }
}

class _SelectAllHeader extends StatelessWidget {
  const _SelectAllHeader({
    required this.isAllSelected,
    required this.onChanged,
  });

  final bool isAllSelected;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Checkbox(
            value: isAllSelected,
            activeColor: AppColors.primary,
            onChanged: onChanged,
          ),
          Text(
            isAllSelected ? 'Bỏ chọn tất cả' : 'Chọn tất cả',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.item,
    required this.onSelected,
    required this.onDecrease,
    required this.onIncrease,
    required this.onRemove,
  });

  final CartItemModel item;
  final VoidCallback onSelected;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: item.isSelected,
              activeColor: AppColors.primary,
              onChanged: (_) => onSelected(),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                item.product.imagePath,
                width: 62,
                height: 62,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 62,
                  height: 62,
                  color: Colors.grey[200],
                  child: const Icon(Icons.fastfood, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    FormatUtils.formatCurrency(item.product.price),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _QuantityButton(
                        icon: Icons.remove,
                        onPressed: onDecrease,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          item.quantity.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      _QuantityButton(icon: Icons.add, onPressed: onIncrease),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Xóa món',
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18),
        color: AppColors.primary,
        onPressed: onPressed,
      ),
    );
  }
}

class _CartSummaryBar extends StatelessWidget {
  const _CartSummaryBar({
    required this.selectedQuantity,
    required this.totalAmount,
    required this.onCheckout,
  });

  final int selectedQuantity;
  final int totalAmount;
  final VoidCallback? onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedQuantity > 0
                      ? '$selectedQuantity món đã chọn'
                      : 'Chọn món để tiếp tục',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  FormatUtils.formatCurrency(totalAmount),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
              child: const Text(
                'Thanh toán',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({required this.onExplorePressed});

  final VoidCallback onExplorePressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 86,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            const Text(
              'Giỏ hàng trống',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Chọn vài món ngon để bắt đầu đặt hàng.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onExplorePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Khám phá món ngon ngay'),
            ),
          ],
        ),
      ),
    );
  }
}
