import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/utils/format_utils.dart';
import '../../models/admin_product_model.dart';
import '../../models/enums/admin_image_preset.dart';
import '../../models/enums/category.dart';
import '../../models/enums/order_status.dart';
import '../../models/order_model.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../services/admin_order_read_service.dart';
import '../../services/admin_product_service.dart';
import '../../services/product_service.dart';
import '../../widgets/app_widgets.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['Tổng quan', 'Sản phẩm', 'Đơn hàng'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
        actions: [
          IconButton(
            tooltip: 'Thoát quản trị',
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _AdminOverviewTab(onRefresh: _refresh),
          _AdminProductsTab(onChanged: _refresh),
          const _AdminOrdersTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Tổng quan',
          ),
          NavigationDestination(
            icon: Icon(Icons.fastfood_outlined),
            selectedIcon: Icon(Icons.fastfood),
            label: 'Sản phẩm',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Đơn hàng',
          ),
        ],
      ),
    );
  }
}

class _AdminOverviewTab extends StatelessWidget {
  const _AdminOverviewTab({required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final productService = context.read<ProductService>();
    final adminProductService = context.read<AdminProductService>();
    final orderService = context.read<AdminOrderReadService>();
    final allOrders = orderService.getAllOrders();
    final processingOrders = allOrders
        .where((order) => order.status != OrderStatus.completed)
        .length;

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Doanh thu',
                  value: FormatUtils.formatCurrency(
                    orderService.completedRevenue,
                  ),
                  icon: Icons.payments_outlined,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: _StatCard(
                  label: 'Đơn hàng',
                  value: allOrders.length.toString(),
                  icon: Icons.receipt_long_outlined,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Sản phẩm',
                  value:
                      (productService.getAllProducts().length +
                              adminProductService.getAllAdminProducts().length)
                          .toString(),
                  icon: Icons.fastfood_outlined,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: _StatCard(
                  label: 'Đang xử lý',
                  value: processingOrders.toString(),
                  icon: Icons.pending_actions_outlined,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),

          // 2. Simple Chart Section
          const SectionHeader(
            title: 'Tình trạng đơn hàng',
            subtitle: 'Tỷ lệ các trạng thái đơn hàng hiện tại',
          ),
          const SizedBox(height: AppSizes.sm),
          _StatusDistributionChart(orders: allOrders),
          const SizedBox(height: AppSizes.lg),

          // 3. Recent Orders
          const SectionHeader(
            title: 'Đơn hàng gần đây',
            subtitle: '3 đơn hàng mới nhất cần chú ý',
          ),
          const SizedBox(height: AppSizes.sm),
          if (allOrders.isEmpty)
            const Center(child: Text('Chưa có dữ liệu đơn hàng'))
          else
            ...allOrders.reversed
                .take(3)
                .map((order) => _OrderTile(order: order)),

          const SizedBox(height: AppSizes.xl),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.xs),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusDistributionChart extends StatelessWidget {
  const _StatusDistributionChart({required this.orders});

  final List<OrderModel> orders;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return const SizedBox.shrink();

    final counts = {for (final status in OrderStatus.values) status: 0};

    for (var o in orders) {
      counts[o.status] = (counts[o.status] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 24,
            child: Row(
              children: counts.entries.map((e) {
                final flex = e.value == 0 ? 0 : e.value;
                if (flex == 0) return const SizedBox.shrink();
                return Expanded(
                  flex: flex,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: _getStatusColor(e.key),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Wrap(
            spacing: AppSizes.md,
            runSpacing: AppSizes.xs,
            children: counts.entries.where((e) => e.value > 0).map((e) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _getStatusColor(e.key),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${e.key.label}: ${e.value}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.created:
      case OrderStatus.confirmed:
        return Colors.orange;
      case OrderStatus.preparing:
        return Colors.blue;
      case OrderStatus.delivering:
        return Colors.purple;
      case OrderStatus.delivered:
      case OrderStatus.completed:
        return Colors.green;
    }
  }
}

class _AdminProductsTab extends StatelessWidget {
  const _AdminProductsTab({required this.onChanged});

  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final productService = context.read<ProductService>();
    final adminProductService = context.read<AdminProductService>();
    final seedProducts = productService.getSeedProducts();
    final adminProducts = adminProductService.getAllAdminProducts();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.md,
          AppSizes.md,
          AppSizes.md,
          96,
        ),
        children: [
          const SectionHeader(
            title: 'Món có sẵn',
            subtitle: 'Danh sách mặc định của hệ thống, chỉ dùng để hiển thị.',
          ),
          const SizedBox(height: AppSizes.sm),
          ...seedProducts.map((product) => _SeedProductTile(product: product)),
          const SizedBox(height: AppSizes.lg),
          const SectionHeader(
            title: 'Món tự thêm',
            subtitle: 'Bật/tắt món để kiểm soát hiển thị trong thực đơn.',
          ),
          const SizedBox(height: AppSizes.sm),
          if (adminProducts.isEmpty)
            const EmptyState(
              icon: Icons.add_box_outlined,
              title: 'Chưa có sản phẩm quản trị',
              message:
                  'Sản phẩm tạo mới sẽ hiển thị trong danh mục người dùng.',
            )
          else
            ...adminProducts.map(
              (product) =>
                  _AdminProductTile(product: product, onChanged: onChanged),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('admin-add-product-button'),
        onPressed: () => _openEditor(context),
        icon: const Icon(Icons.add),
        label: const Text('Thêm món'),
      ),
    );
  }

  Future<void> _openEditor(BuildContext context) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => const _AdminProductDialog(),
    );
    if (saved == true && context.mounted) {
      await context.read<ProductProvider>().loadProducts();
      onChanged();
    }
  }
}

class _SeedProductTile extends StatelessWidget {
  const _SeedProductTile({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return _ProductTileShell(
      imagePath: product.imagePath,
      title: product.name,
      subtitle:
          '${product.category.label} · ${FormatUtils.formatCurrency(product.price)}',
      badge: 'Món mặc định',
      badgeColor: Theme.of(context).colorScheme.onSurfaceVariant,
      isDimmed: false,
      trailing: const Icon(Icons.lock_outline),
    );
  }
}

class _AdminProductTile extends StatelessWidget {
  const _AdminProductTile({required this.product, required this.onChanged});

  final AdminProductModel product;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return _ProductTileShell(
      imagePath: product.imagePreset.assetPath,
      title: product.name,
      subtitle:
          '${product.category.label} · ${FormatUtils.formatCurrency(product.price)}',
      badge: product.isActive ? 'Đang hiển thị' : 'Đang ẩn',
      badgeColor: Theme.of(context).colorScheme.primary,
      isDimmed: !product.isActive,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Sửa sản phẩm',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _openEditor(context),
          ),
          Switch(
            value: product.isActive,
            onChanged: (value) async {
              await context.read<AdminProductService>().setActive(
                product.id,
                value,
              );
              if (context.mounted) {
                await context.read<ProductProvider>().loadProducts();
              }
              onChanged();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openEditor(BuildContext context) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => _AdminProductDialog(product: product),
    );
    if (saved == true && context.mounted) {
      await context.read<ProductProvider>().loadProducts();
      onChanged();
    }
  }
}

class _ProductTileShell extends StatelessWidget {
  const _ProductTileShell({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.trailing,
    required this.isDimmed,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final Widget trailing;
  final bool isDimmed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: isDimmed
          ? colorScheme.surfaceContainerHighest
          : colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSizes.sm),
        leading: AppImage.asset(
          imagePath,
          width: 56,
          height: 56,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          fallbackKind: AppImageFallbackKind.product,
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: AppSizes.xs),
            Text(
              badge,
              style: TextStyle(
                color: badgeColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: trailing,
      ),
    );
  }
}

class _AdminProductDialog extends StatefulWidget {
  const _AdminProductDialog({this.product});

  final AdminProductModel? product;

  @override
  State<_AdminProductDialog> createState() => _AdminProductDialogState();
}

class _AdminProductDialogState extends State<_AdminProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late Category _category;
  late AdminImagePreset _imagePreset;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product?.name ?? '');
    _descriptionController = TextEditingController(
      text: product?.description ?? '',
    );
    _priceController = TextEditingController(
      text: product == null ? '' : product.price.toString(),
    );
    _category = product?.category ?? Category.food;
    _imagePreset = product?.imagePreset ?? AdminImagePreset.burger;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Thêm món' : 'Sửa món'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: _nameController,
                labelText: 'Tên món',
                prefixIcon: Icons.fastfood_outlined,
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Vui lòng nhập tên món';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.md),
              AppTextField(
                controller: _descriptionController,
                labelText: 'Mô tả',
                prefixIcon: Icons.notes_outlined,
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Vui lòng nhập mô tả';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.md),
              AppTextField(
                controller: _priceController,
                labelText: 'Giá',
                prefixIcon: Icons.payments_outlined,
                keyboardType: TextInputType.number,
                validator: (value) {
                  final price = int.tryParse((value ?? '').trim());
                  if (price == null || price <= 0) return 'Giá không hợp lệ';
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.md),
              DropdownButtonFormField<Category>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Danh mục'),
                items: Category.values
                    .where((category) => category != Category.all)
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _category = value);
                },
              ),
              const SizedBox(height: AppSizes.md),
              DropdownButtonFormField<AdminImagePreset>(
                initialValue: _imagePreset,
                decoration: const InputDecoration(labelText: 'Ảnh mẫu'),
                items: AdminImagePreset.values
                    .map(
                      (preset) => DropdownMenuItem(
                        value: preset,
                        child: Text(preset.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _imagePreset = value);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Hủy'),
        ),
        FilledButton(onPressed: _save, child: const Text('Lưu')),
      ],
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final service = context.read<AdminProductService>();
    final product = widget.product;
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final price = int.parse(_priceController.text.trim());

    if (product == null) {
      await service.addProduct(
        name: name,
        description: description,
        price: price,
        category: _category,
        imagePreset: _imagePreset,
      );
    } else {
      await service.updateProduct(
        product.copyWith(
          name: name,
          description: description,
          price: price,
          category: _category,
          imagePreset: _imagePreset,
        ),
      );
    }

    if (mounted) Navigator.pop(context, true);
  }
}

class _AdminOrdersTab extends StatelessWidget {
  const _AdminOrdersTab();

  @override
  Widget build(BuildContext context) {
    final orders = context.read<AdminOrderReadService>().getAllOrders();

    if (orders.isEmpty) {
      return const EmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'Chưa có đơn hàng',
        message: 'Đơn hàng người dùng sẽ hiển thị tại đây để theo dõi.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.md),
      itemCount: orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSizes.sm),
      itemBuilder: (context, index) => _OrderTile(order: orders[index]),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final shortId = order.orderId.length <= 8
        ? order.orderId
        : order.orderId.substring(0, 8);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: const Icon(Icons.receipt_long_outlined),
        title: Text(
          'Đơn #$shortId',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          'Khách hàng ID: ${order.userId} · ${order.status.label}',
        ),
        trailing: Text(
          FormatUtils.formatCurrency(order.finalAmount),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
