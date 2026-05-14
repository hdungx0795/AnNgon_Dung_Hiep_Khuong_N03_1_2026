import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../models/product_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/favorites_provider.dart';
import '../../../providers/product_provider.dart';
import '../../../widgets/app_widgets.dart';
import '../../product/product_detail_screen.dart';
import '../widgets/discovery_product_card.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final productProvider = context.watch<ProductProvider>();

    final favoriteProducts = productProvider.products
        .where((product) => favoritesProvider.isFavorite(product.id))
        .toList();

    if (productProvider.isLoading) {
      return const LoadingState(message: 'Đang tải món yêu thích...');
    }

    if (favoriteProducts.isEmpty) {
      return const EmptyState(
        icon: Icons.favorite_border,
        title: 'Chưa có món yêu thích',
        message:
            'Nhấn biểu tượng trái tim ở món bạn thích để lưu lại và đặt nhanh hơn.',
      );
    }

    return CustomScrollView(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSizes.md,
            AppSizes.md,
            AppSizes.md,
            AppSizes.sm,
          ),
          sliver: SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Món yêu thích',
              subtitle: 'Các món bạn đã lưu để đặt lại nhanh hơn',
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppSizes.md),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: AppSizes.md,
              mainAxisSpacing: AppSizes.md,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  _buildFavoriteCard(context, favoriteProducts[index]),
              childCount: favoriteProducts.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteCard(BuildContext context, ProductModel product) {
    final colorScheme = Theme.of(context).colorScheme;

    return DiscoveryProductCard(
      product: product,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      trailingAction: Material(
        color: colorScheme.surface.withValues(alpha: 0.92),
        shape: const CircleBorder(),
        child: IconButton(
          tooltip: 'Bỏ yêu thích',
          constraints: const BoxConstraints.tightFor(width: 36, height: 36),
          padding: EdgeInsets.zero,
          icon: Icon(Icons.favorite, color: colorScheme.primary, size: 20),
          onPressed: () => _removeFavorite(context, product.id),
        ),
      ),
    );
  }

  void _removeFavorite(BuildContext context, int productId) {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đăng nhập để quản lý yêu thích'),
        ),
      );
      return;
    }

    context.read<FavoritesProvider>().toggleFavorite(user.phone, productId);
  }
}
