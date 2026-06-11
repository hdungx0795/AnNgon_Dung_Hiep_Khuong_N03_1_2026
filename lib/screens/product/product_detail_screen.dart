import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../models/enums/category.dart';
import '../../models/product_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/app_widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isAddingToCart = false;

  void _increment() => setState(() => _quantity++);

  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildProductInfo()),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'product_${widget.product.id}',
          child: AppImage.asset(
            widget.product.imagePath,
            width: double.infinity,
            height: double.infinity,
            borderRadius: BorderRadius.zero,
            fallbackKind: AppImageFallbackKind.product,
            semanticLabel: widget.product.name,
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: _OverlayIconButton(
          tooltip: 'Quay lại',
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Consumer<FavoritesProvider>(
          builder: (context, favoritesProvider, child) {
            final isFavorite = favoritesProvider.isFavorite(widget.product.id);
            return Padding(
              padding: const EdgeInsets.all(AppSizes.sm),
              child: _OverlayIconButton(
                tooltip: isFavorite ? 'Bỏ yêu thích' : 'Thêm yêu thích',
                icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                isActive: isFavorite,
                onPressed: () => _handleFavoriteToggle(favoritesProvider),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductInfo() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.product.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              _RatingBadge(rating: widget.product.rating),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            widget.product.category.label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          PriceText(amount: widget.product.price),
          const SizedBox(height: AppSizes.lg),
          Text(
            AppStrings.description,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            widget.product.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Row(
            children: [
              Text(
                'Số lượng',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              _buildQuantitySelector(),
            ],
          ),
          const SizedBox(height: 112),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      key: const Key('product-detail-quantity-selector'),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            tooltip: 'Giảm số lượng',
            icon: Icons.remove,
            onPressed: _decrement,
          ),
          SizedBox(
            key: const Key('product-detail-quantity'),
            width: 44,
            child: Text(
              _quantity.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          _QuantityButton(
            tooltip: 'Tăng số lượng',
            icon: Icons.add,
            onPressed: _increment,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          AppSizes.lg,
          AppSizes.md,
          AppSizes.lg,
          AppSizes.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tổng tiền',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  PriceText(
                    key: const Key('product-detail-total-price'),
                    amount: widget.product.price * _quantity,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: PrimaryButton(
                label: AppStrings.addToCart,
                onPressed: _isAddingToCart ? null : _handleAddToCart,
                isLoading: _isAddingToCart,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAddToCart() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) {
      _showSnackBar('Vui lòng đăng nhập để mua hàng');
      return;
    }

    setState(() => _isAddingToCart = true);
    await context.read<CartProvider>().addItem(
      user.phone,
      widget.product,
      _quantity,
    );

    if (!mounted) return;
    setState(() => _isAddingToCart = false);
    _showSnackBar('Đã thêm vào giỏ hàng!');
  }

  void _handleFavoriteToggle(FavoritesProvider favoritesProvider) {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) {
      _showSnackBar('Vui lòng đăng nhập để yêu thích');
      return;
    }

    favoritesProvider.toggleFavorite(user.phone, widget.product.id);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
  }
}

class _OverlayIconButton extends StatelessWidget {
  const _OverlayIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: tooltip,
        icon: Icon(icon),
        color: isActive ? colorScheme.primary : colorScheme.onSurface,
        onPressed: onPressed,
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 18),
          const SizedBox(width: AppSizes.xs),
          Text(
            rating.toString(),
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      constraints: const BoxConstraints.tightFor(width: 42, height: 42),
      icon: Icon(icon),
      color: Theme.of(context).colorScheme.primary,
      onPressed: onPressed,
    );
  }
}
