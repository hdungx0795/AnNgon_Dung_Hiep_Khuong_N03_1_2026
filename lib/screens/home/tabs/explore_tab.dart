import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../models/enums/category.dart';
import '../../../models/product_model.dart';
import '../../../providers/product_provider.dart';
import '../../../widgets/app_widgets.dart';
import '../../product/product_detail_screen.dart';
import '../widgets/discovery_product_card.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.products;
    final hasFilter =
        _searchQuery.isNotEmpty ||
        productProvider.selectedCategory != Category.all;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.md,
            AppSizes.sm,
            AppSizes.md,
            AppSizes.sm,
          ),
          sliver: SliverToBoxAdapter(
            child: _DiscoveryHeader(
              onSearchChanged: (value) {
                setState(() => _searchQuery = value.trim());
                productProvider.setSearchQuery(value);
              },
              onComboPressed: () => productProvider.setCategory(Category.combo),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _CategoryScroller(
            selectedCategory: productProvider.selectedCategory,
            onSelected: productProvider.setCategory,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.md,
            AppSizes.xs,
            AppSizes.md,
            AppSizes.xs,
          ),
          sliver: SliverToBoxAdapter(
            child: SectionHeader(
              title: productProvider.selectedCategory == Category.all
                  ? 'Món nổi bật'
                  : productProvider.selectedCategory.label,
              subtitle: 'Chọn món phù hợp cho bữa ăn hôm nay',
            ),
          ),
        ),
        if (productProvider.isLoading)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: LoadingState(message: 'Đang tải món ngon...'),
          )
        else if (products.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _ExploreEmptyState(hasFilter: hasFilter),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.md,
              AppSizes.sm,
              AppSizes.md,
              96,
            ),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.crossAxisExtent;
                final crossAxisCount = width < 360 ? 1 : 2;
                final childAspectRatio = crossAxisCount == 1 ? 1.12 : 0.72;

                return SliverGrid(
                  key: const Key('explore-product-grid'),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: AppSizes.md,
                    mainAxisSpacing: AppSizes.md,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _buildProductCard(context, products[index]),
                    childCount: products.length,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product) {
    return DiscoveryProductCard(
      product: product,
      showHero: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
    );
  }
}

class _DiscoveryHeader extends StatelessWidget {
  const _DiscoveryHeader({
    required this.onSearchChanged,
    required this.onComboPressed,
  });

  final ValueChanged<String> onSearchChanged;
  final VoidCallback onComboPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.md,
            AppSizes.sm,
            AppSizes.md,
            AppSizes.md,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Bạn muốn ăn gì hôm nay?',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              AppTextField(
                key: const Key('explore-search-field'),
                labelText: 'Tìm kiếm món ngon',
                prefixIcon: Icons.search,
                textInputAction: TextInputAction.search,
                onChanged: onSearchChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Container(
          key: const Key('explore-promo-banner'),
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primaryContainer,
                colorScheme.secondaryContainer,
              ],
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Combo burger hôm nay',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w800,
                        height: 1.18,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      'Burger + nước, tiết kiệm cho bữa trưa nhanh.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    SizedBox(
                      height: 40,
                      child: FilledButton(
                        onPressed: onComboPressed,
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.md,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusSm,
                            ),
                          ),
                        ),
                        child: const Text('Xem ngay'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.md),
              SizedBox(
                width: 104,
                height: 92,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: AppImage.asset(
                        'assets/images/products/comboBurgerCoca.jpg',
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        fallbackKind: AppImageFallbackKind.product,
                        semanticLabel: 'Combo burger ưu đãi',
                      ),
                    ),
                    Positioned(
                      right: -6,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm,
                          vertical: AppSizes.xs,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSm,
                          ),
                        ),
                        child: Text(
                          '-15%',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryScroller extends StatelessWidget {
  const _CategoryScroller({
    required this.selectedCategory,
    required this.onSelected,
  });

  final Category selectedCategory;
  final ValueChanged<Category> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.xs,
      ),
      child: Row(
        children: Category.values.map((category) {
          final isSelected = selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.sm),
            child: ChoiceChip(
              key: Key('explore-category-${category.name}'),
              avatar: Icon(
                _categoryIcon(category),
                size: AppSizes.iconSm,
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
              ),
              label: Text(category.label),
              selected: isSelected,
              onSelected: (_) => onSelected(category),
              selectedColor: colorScheme.primary,
              backgroundColor: colorScheme.surface,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              labelPadding: const EdgeInsets.symmetric(horizontal: AppSizes.xs),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm,
                vertical: AppSizes.xs,
              ),
              side: BorderSide(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
              ),
              showCheckmark: false,
              labelStyle: TextStyle(
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _categoryIcon(Category category) {
    switch (category) {
      case Category.all:
        return Icons.apps_rounded;
      case Category.food:
        return Icons.lunch_dining_rounded;
      case Category.drink:
        return Icons.local_drink_rounded;
      case Category.combo:
        return Icons.inventory_2_rounded;
    }
  }
}

class _ExploreEmptyState extends StatelessWidget {
  const _ExploreEmptyState({required this.hasFilter});

  final bool hasFilter;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      key: Key(hasFilter ? 'explore-no-results-state' : 'explore-empty-state'),
      icon: hasFilter ? Icons.search_off_outlined : Icons.fastfood_outlined,
      title: hasFilter ? 'Không tìm thấy món phù hợp' : 'Chưa có món nào',
      message: hasFilter
          ? 'Thử đổi từ khóa hoặc chọn danh mục khác.'
          : 'Danh sách món sẽ hiển thị tại đây khi có dữ liệu.',
    );
  }
}
