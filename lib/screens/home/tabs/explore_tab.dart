import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../models/enums/category.dart';
import '../../../models/product_model.dart';
import '../../../providers/product_provider.dart';
import '../../../widgets/app_widgets.dart';
import '../../chat/delivery_chat_screen.dart';
import '../../product/product_detail_screen.dart';
import '../widgets/discovery_product_card.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key, this.onCartTabPressed});

  final VoidCallback? onCartTabPressed;

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  String _searchQuery = '';

  void _showComingSoon(String feature) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$feature đang được phát triển')));
  }

  void _openProduct(ProductModel? product, {Category? fallbackCategory}) {
    if (product != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(product: product),
        ),
      );
      return;
    }

    if (fallbackCategory != null) {
      context.read<ProductProvider>().setCategory(fallbackCategory);
    }
    _showComingSoon('Món quảng cáo');
  }

  void _openMomoSheet() {
    bool isPrimary = true;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.lg,
                  AppSizes.sm,
                  AppSizes.lg,
                  AppSizes.lg,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const _MomoLogo(size: 48),
                        const SizedBox(width: AppSizes.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ví MoMo đã liên kết',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: AppSizes.xs),
                              Text(
                                'Tài khoản 9554',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.md),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: isPrimary,
                      title: const Text('Đặt làm phương thức chính'),
                      onChanged: (value) =>
                          setSheetState(() => isPrimary = value),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.link_off_rounded),
                      title: Text(
                        'Gỡ liên kết',
                        style: TextStyle(
                          color: colorScheme.error,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openSupportSheet() {
    final messageController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        final colorScheme = theme.colorScheme;

        Future<void> openSupportChat() async {
          if (messageController.text.trim().isEmpty) return;
          Navigator.of(sheetContext).pop();
          await Future<void>.delayed(const Duration(milliseconds: 220));
          if (!mounted) return;

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  const DeliveryChatScreen(shipperName: 'Nhân viên hỗ trợ'),
            ),
          );
        }

        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.lg,
              AppSizes.sm,
              AppSizes.lg,
              AppSizes.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      child: Icon(
                        Icons.support_agent_rounded,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Text(
                        'Nhân viên hỗ trợ An Ngon',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.md),
                Container(
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: const Text(
                    'Xin chào, An Ngon có thể hỗ trợ bạn kiểm tra món, đơn hàng hoặc ưu đãi hôm nay.',
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                TextField(
                  key: const Key('support-chat-preview-input'),
                  controller: messageController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => openSupportChat(),
                  decoration: InputDecoration(
                    hintText: 'Nhập tin nhắn...',
                    suffixIcon: IconButton(
                      key: const Key('support-chat-preview-send'),
                      tooltip: 'Gửi',
                      onPressed: openSupportChat,
                      icon: const Icon(Icons.send_rounded),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ProductModel? _findPromoProduct(
    List<ProductModel> products,
    String imagePath,
  ) {
    for (final product in products) {
      if (product.imagePath == imagePath) return product;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.products;
    final hasFilter =
        _searchQuery.isNotEmpty ||
        productProvider.selectedCategory != Category.all;

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => productProvider.loadProducts(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _TeacherLayoutHeader(
                  onSearchChanged: (value) {
                    setState(() => _searchQuery = value.trim());
                    productProvider.setSearchQuery(value);
                  },
                  onProfilePressed: () =>
                      Navigator.pushNamed(context, '/profile'),
                  onCartPressed: widget.onCartTabPressed ?? () {},
                  onScanPressed: () => _showComingSoon('Tính năng quét mã'),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.md,
                  AppSizes.lg,
                  AppSizes.md,
                  AppSizes.sm,
                ),
                sliver: SliverToBoxAdapter(
                  child: _ShortcutGrid(
                    selectedCategory: productProvider.selectedCategory,
                    onCategorySelected: productProvider.setCategory,
                    onComingSoon: _showComingSoon,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.md,
                  AppSizes.sm,
                  AppSizes.md,
                  AppSizes.sm,
                ),
                sliver: SliverToBoxAdapter(
                  child: _MomoLinkedCard(onPressed: _openMomoSheet),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.md,
                  AppSizes.sm,
                  AppSizes.md,
                  AppSizes.xs,
                ),
                sliver: SliverToBoxAdapter(child: _BuyNowHeader()),
              ),
              SliverToBoxAdapter(
                child: _PromoCarousel(
                  promos: [
                    _PromoData(
                      imagePath: 'assets/images/products/comboBurgerCoca.jpg',
                      title: 'Combo burger Coca cho bữa trưa nhanh gọn',
                      subtitle: 'Ưu đãi - An Ngon',
                      onOpen: () => _openProduct(
                        _findPromoProduct(
                          products,
                          'assets/images/products/comboBurgerCoca.jpg',
                        ),
                        fallbackCategory: Category.combo,
                      ),
                    ),
                    _PromoData(
                      imagePath: 'assets/images/products/ComboGiaDinh.jpg',
                      title: 'Combo gia đình tiết kiệm hơn',
                      subtitle: 'Ưu đãi - Combo',
                      onOpen: () => _openProduct(
                        _findPromoProduct(
                          products,
                          'assets/images/products/ComboGiaDinh.jpg',
                        ),
                        fallbackCategory: Category.combo,
                      ),
                    ),
                    _PromoData(
                      imagePath: 'assets/images/products/gaRan.jpg',
                      title: 'Gà rán nóng giòn cho bữa tối',
                      subtitle: 'Gợi ý - Đồ ăn',
                      onOpen: () => _openProduct(
                        _findPromoProduct(
                          products,
                          'assets/images/products/gaRan.jpg',
                        ),
                        fallbackCategory: Category.food,
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.md,
                  AppSizes.lg,
                  AppSizes.md,
                  AppSizes.xs,
                ),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(
                    title: productProvider.selectedCategory == Category.all
                        ? 'Món ngon hôm nay'
                        : productProvider.selectedCategory.label,
                    subtitle: 'Kéo xuống để chọn món và đặt hàng trong An Ngon',
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
                    112,
                  ),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.crossAxisExtent;
                      final crossAxisCount = width < 360 ? 1 : 2;
                      final childAspectRatio = crossAxisCount == 1
                          ? 1.12
                          : 0.72;

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
          ),
        ),
        Positioned(
          right: AppSizes.lg,
          bottom: AppSizes.lg,
          child: _SupportChatBubble(onPressed: _openSupportSheet),
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

class _TeacherLayoutHeader extends StatelessWidget {
  const _TeacherLayoutHeader({
    required this.onSearchChanged,
    required this.onProfilePressed,
    required this.onCartPressed,
    required this.onScanPressed,
  });

  final ValueChanged<String> onSearchChanged;
  final VoidCallback onProfilePressed;
  final VoidCallback onCartPressed;
  final VoidCallback onScanPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        12.0, // Tighter left padding
        8.0,  // Compact top padding
        12.0, // Tighter right padding
        10.0, // Compact bottom padding
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16.0), // Compact border radius
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            _HeaderCircleButton(
              tooltip: 'Hồ sơ',
              icon: Icons.person_rounded,
              onPressed: onProfilePressed,
              light: true,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: SizedBox(
                height: 40, // Sleeker search bar height (40px instead of 46px)
                child: TextFormField(
                  key: const Key('explore-search-field'),
                  onChanged: onSearchChanged,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Tìm món ăn',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 0.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.black38,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            _HeaderCircleButton(
              tooltip: 'Quét mã',
              icon: Icons.qr_code_scanner_rounded,
              onPressed: onScanPressed,
            ),
            const SizedBox(width: 8.0),
            _CartButton(onPressed: onCartPressed),
          ],
        ),
      ),
    );
  }
}

class _HeaderCircleButton extends StatelessWidget {
  const _HeaderCircleButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.light = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: Material(
        shape: const CircleBorder(),
        color: light ? Colors.white : Colors.white.withValues(alpha: 0.22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 38,
            height: 38,
            child: Icon(
              icon,
              color: light ? colorScheme.primary : Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: 'Giỏ hàng',
      child: Material(
        shape: const CircleBorder(),
        color: Colors.white, // Matches profile button style
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 38,
            height: 38,
            child: Icon(
              Icons.shopping_cart_rounded,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _ShortcutGrid extends StatelessWidget {
  const _ShortcutGrid({
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onComingSoon,
  });

  final Category selectedCategory;
  final ValueChanged<Category> onCategorySelected;
  final ValueChanged<String> onComingSoon;

  @override
  Widget build(BuildContext context) {
    final shortcuts = [
      _ShortcutData(
        label: 'Xe máy',
        icon: Icons.delivery_dining_rounded,
        onTap: () => onComingSoon('Giao hàng bằng xe máy'),
      ),
      _ShortcutData(
        label: 'Giao nhanh',
        icon: Icons.local_shipping_rounded,
        onTap: () => onComingSoon('Giao nhanh'),
      ),
      _ShortcutData(
        label: 'Đặt bàn',
        icon: Icons.room_service_rounded,
        onTap: () => onComingSoon('Đặt bàn tại quán'),
      ),
      _ShortcutData(
        label: 'Ví',
        icon: Icons.account_balance_wallet_rounded,
        onTap: () => onComingSoon('Ví thanh toán An Ngon'),
      ),
      _ShortcutData(
        label: 'Đồ ăn',
        icon: Icons.restaurant_rounded,
        category: Category.food,
      ),
      _ShortcutData(
        label: 'Đồ uống',
        icon: Icons.local_cafe_rounded,
        category: Category.drink,
      ),
      _ShortcutData(
        label: 'Combo',
        icon: Icons.inventory_2_rounded,
        category: Category.combo,
      ),
      _ShortcutData(
        label: 'Tất cả',
        icon: Icons.grid_view_rounded,
        category: Category.all,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: shortcuts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: AppSizes.sm,
        crossAxisSpacing: AppSizes.sm,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        final shortcut = shortcuts[index];
        final category = shortcut.category;
        final selected = category != null && selectedCategory == category;

        return _ShortcutTile(
          data: shortcut,
          selected: selected,
          onTap: () {
            if (category != null) {
              onCategorySelected(category);
            } else {
              shortcut.onTap?.call();
            }
          },
        );
      },
    );
  }
}

class _ShortcutData {
  const _ShortcutData({
    required this.label,
    required this.icon,
    this.category,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final Category? category;
  final VoidCallback? onTap;
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final _ShortcutData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final category = data.category;

    return Material(
      key: category == null ? null : Key('explore-category-${category.name}'),
      color: selected
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(data.icon, color: colorScheme.primary, size: 34),
              const SizedBox(height: AppSizes.sm),
              Text(
                data.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MomoLinkedCard extends StatelessWidget {
  const _MomoLinkedCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: onPressed,
          child: Container(
            width: 172.0, // Sleeker and compact width
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.18),
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ví MoMo',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.0,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        '9554',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                const _MomoLogo(size: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MomoLogo extends StatelessWidget {
  const _MomoLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFA50064),
      ),
      child: Center(
        child: Text(
          'MoMo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: size * 0.22,
          ),
        ),
      ),
    );
  }
}

class _BuyNowHeader extends StatelessWidget {
  const _BuyNowHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Text(
      'Mua ngay',
      style: theme.textTheme.headlineMedium?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w900,
        height: 1,
      ),
    );
  }
}

class _PromoCarousel extends StatelessWidget {
  const _PromoCarousel({required this.promos});

  final List<_PromoData> promos;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 232,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        children: [
          for (var index = 0; index < promos.length; index++)
            _PromoCard(
              key: index == 0 ? const Key('explore-promo-banner') : null,
              promo: promos[index],
            ),
        ],
      ),
    );
  }
}

class _PromoData {
  const _PromoData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.onOpen,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onOpen;
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({super.key, required this.promo});

  final _PromoData promo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: 318,
      child: Padding(
        padding: const EdgeInsets.only(right: AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 138,
                  child: AppImage.asset(
                    promo.imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    fallbackKind: AppImageFallbackKind.product,
                    semanticLabel: promo.title,
                  ),
                ),
                Positioned(
                  right: AppSizes.sm,
                  top: AppSizes.sm,
                  child: IconButton.filled(
                    key: const Key('promo-open-button'),
                    tooltip: 'Mở món quảng cáo',
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.primary,
                    ),
                    onPressed: promo.onOpen,
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              promo.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              promo.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportChatBubble extends StatelessWidget {
  const _SupportChatBubble({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 7,
      color: colorScheme.surface,
      shape: const CircleBorder(),
      child: Tooltip(
        message: 'Hỗ trợ',
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: 64,
            height: 64,
            child: Icon(
              Icons.support_agent_rounded,
              color: colorScheme.primary,
              size: AppSizes.iconLg,
            ),
          ),
        ),
      ),
    );
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
