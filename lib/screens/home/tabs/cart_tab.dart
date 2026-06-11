import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../models/cart_item_model.dart';
import '../../../widgets/app_widgets.dart';

class CartTab extends StatelessWidget {
  const CartTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    if (user == null) {
      return const EmptyState(
        title: 'Vui lòng đăng nhập',
        message: 'Đăng nhập để xem giỏ hàng và tiếp tục đặt món.',
        icon: Icons.lock_outline,
      );
    }

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
    final selectedItemCount = items.where((item) => item.isSelected).length;
    final hasSelectedItems = selectedQuantity > 0;

    return Column(
      children: [
        _SelectAllHeader(
          isAllSelected: cartProvider.isAllSelected,
          itemCount: items.length,
          selectedItemCount: selectedItemCount,
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
          selectedItemCount: selectedItemCount,
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
    required this.itemCount,
    required this.selectedItemCount,
    required this.onChanged,
  });

  final bool isAllSelected;
  final int itemCount;
  final int selectedItemCount;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.md,
        AppSizes.md,
        AppSizes.sm,
      ),
      child: Row(
        children: [
          Checkbox(
            key: const Key('cart-select-all-checkbox'),
            value: isAllSelected,
            onChanged: onChanged,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAllSelected ? 'Bỏ chọn tất cả' : 'Chọn tất cả',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  '$selectedItemCount/$itemCount món trong giỏ đã chọn',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      elevation: item.isSelected ? 1 : 0,
      color: item.isSelected
          ? colorScheme.primaryContainer.withValues(alpha: 0.22)
          : colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        side: BorderSide(
          color: item.isSelected
              ? colorScheme.primary.withValues(alpha: 0.45)
              : colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              key: Key('cart-item-select-${item.product.id}'),
              value: item.isSelected,
              onChanged: (_) => onSelected(),
            ),
            AppImage.asset(
              item.product.imagePath,
              width: AppSizes.imageThumb,
              height: AppSizes.imageThumb,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              fallbackKind: AppImageFallbackKind.product,
              semanticLabel: item.product.name,
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  PriceText(
                    amount: item.product.price,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Row(
                    children: [
                      _QuantityButton(
                        icon: Icons.remove,
                        tooltip: 'Giảm số lượng',
                        keyName: 'cart-decrease-${item.product.id}',
                        onPressed: onDecrease,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm,
                        ),
                        child: Text(
                          item.quantity.toString(),
                          key: Key('cart-quantity-${item.product.id}'),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      _QuantityButton(
                        icon: Icons.add,
                        tooltip: 'Tăng số lượng',
                        keyName: 'cart-increase-${item.product.id}',
                        onPressed: onIncrease,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              key: Key('cart-remove-${item.product.id}'),
              tooltip: 'Xóa món',
              icon: Icon(Icons.delete_outline, color: colorScheme.error),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.tooltip,
    required this.keyName,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final String keyName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        key: Key(keyName),
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18),
        style: IconButton.styleFrom(
          backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.45),
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class _CartSummaryBar extends StatelessWidget {
  const _CartSummaryBar({
    required this.selectedQuantity,
    required this.selectedItemCount,
    required this.totalAmount,
    required this.onCheckout,
  });

  final int selectedQuantity;
  final int selectedItemCount;
  final int totalAmount;
  final VoidCallback? onCheckout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasSelectedItems = onCheckout != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.md,
        AppSizes.md,
        AppSizes.md,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    hasSelectedItems
                        ? '$selectedItemCount mục, $selectedQuantity món đã chọn'
                        : 'Chọn món để thanh toán',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: hasSelectedItems
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                PriceText(
                  amount: totalAmount,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            if (!hasSelectedItems) ...[
              const SizedBox(height: AppSizes.xs),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nút thanh toán sẽ bật khi có ít nhất 1 món được chọn.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSizes.sm),
            PrimaryButton(
              key: const Key('cart-checkout-button'),
              label: 'Thanh toán',
              icon: Icons.shopping_bag_outlined,
              onPressed: onCheckout,
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
    return EmptyState(
      title: 'Giỏ hàng trống',
      message: 'Chọn vài món ngon để bắt đầu đặt hàng.',
      icon: Icons.shopping_cart_outlined,
      actionLabel: 'Khám phá món ngon',
      onActionPressed: onExplorePressed,
    );
  }
}
