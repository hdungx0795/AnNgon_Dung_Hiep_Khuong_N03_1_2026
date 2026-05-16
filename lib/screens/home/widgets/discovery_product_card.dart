import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../models/enums/category.dart';
import '../../../models/product_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../widgets/app_widgets.dart';

class DiscoveryProductCard extends StatelessWidget {
  const DiscoveryProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.trailingAction,
    this.showHero = false,
  });

  final ProductModel product;
  final VoidCallback onTap;
  final Widget? trailingAction;
  final bool showHero;

  Future<void> _handleQuickBuy(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final cart = context.read<CartProvider>();

    if (auth.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đăng nhập để mua hàng')),
      );
      return;
    }

    await cart.addItem(auth.currentUser!.phone, product, 1);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã thêm ${product.name} vào giỏ hàng'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Xem giỏ',
            onPressed: () {
              // Có thể điều hướng đến tab giỏ hàng nếu cần
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _ProductImage(product: product, showHero: showHero),
                  Positioned(
                    left: AppSizes.sm,
                    top: AppSizes.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: AppSizes.xs,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Text(
                        product.category.label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  if (trailingAction != null)
                    Positioned(
                      top: AppSizes.sm,
                      right: AppSizes.sm,
                      child: trailingAction!,
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.sm),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: AppSizes.xs),
                      PriceText(amount: product.price),
                      const SizedBox(height: AppSizes.xs),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 15, color: Colors.amber),
                          const SizedBox(width: AppSizes.xs),
                          Text(
                            product.rating.toString(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: IconButton(
                        key: Key('quick-buy-${product.id}'),
                        tooltip: 'Mua nhanh',
                        constraints: const BoxConstraints.tightFor(
                          width: 36,
                          height: 36,
                        ),
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.add_shopping_cart_rounded,
                          size: 18,
                          color: colorScheme.onPrimary,
                        ),
                        onPressed: () => _handleQuickBuy(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.product, required this.showHero});

  final ProductModel product;
  final bool showHero;

  @override
  Widget build(BuildContext context) {
    final image = AppImage.asset(
      product.imagePath,
      width: double.infinity,
      height: double.infinity,
      borderRadius: BorderRadius.zero,
      fallbackKind: AppImageFallbackKind.product,
      semanticLabel: product.name,
    );

    if (!showHero) return image;

    return Hero(tag: 'product_${product.id}', child: image);
  }
}
