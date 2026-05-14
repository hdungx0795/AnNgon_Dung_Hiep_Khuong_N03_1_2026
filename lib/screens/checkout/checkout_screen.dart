import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/utils/format_utils.dart';
import '../../models/cart_item_model.dart';
import '../../models/enums/order_status.dart';
import '../../models/enums/payment_method.dart';
import '../../models/order_model.dart';
import '../../models/user_model.dart';
import '../../models/voucher_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../services/voucher_service.dart';
import '../../widgets/app_widgets.dart';
import '../tracking/tracking_order_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  final _voucherController = TextEditingController();

  PaymentMethod _paymentMethod = PaymentMethod.cod;
  VoucherModel? _appliedVoucher;
  bool _isPlacingOrder = false;
  String? _voucherError;

  int _selectedQuantity(List<CartItemModel> selectedItems) {
    return selectedItems.fold(0, (sum, item) => sum + item.quantity);
  }

  void _applyVoucher(int total, {String? code}) {
    final requestedCode = (code ?? _voucherController.text).trim();
    if (requestedCode.isEmpty) {
      setState(() {
        _voucherError = 'Vui lòng nhập mã voucher';
        _appliedVoucher = null;
      });
      return;
    }

    final voucher = context.read<VoucherService>().validateVoucher(
      requestedCode,
      total,
    );
    setState(() {
      if (voucher != null) {
        _voucherController.text = voucher.code;
        _appliedVoucher = voucher;
        _voucherError = null;
      } else {
        _appliedVoucher = null;
        _voucherError = 'Mã không hợp lệ hoặc chưa đủ điều kiện';
      }
    });
  }

  void _removeVoucher() {
    setState(() {
      _appliedVoucher = null;
      _voucherError = null;
      _voucherController.clear();
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _noteController.dispose();
    _voucherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final user = context.watch<AuthProvider>().currentUser;
    final selectedItems = cartProvider.items
        .where((item) => item.isSelected)
        .toList();
    final total = cartProvider.totalAmount;
    final discount = _appliedVoucher?.calculateDiscount(total) ?? 0;
    final finalTotal = total - discount;
    final selectedQuantity = _selectedQuantity(selectedItems);
    final availableVouchers = context
        .read<VoucherService>()
        .getAvailableVouchers();

    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CheckoutSummaryBanner(
                selectedItemCount: selectedItems.length,
                selectedQuantity: selectedQuantity,
                total: total,
              ),
              const SizedBox(height: AppSizes.md),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(
                      title: 'Địa chỉ giao hàng',
                      subtitle: 'Thông tin này chỉ dùng cho đơn hiện tại.',
                    ),
                    const SizedBox(height: AppSizes.md),
                    AppTextField(
                      key: const Key('checkout-address-field'),
                      controller: _addressController,
                      labelText: 'Địa chỉ',
                      hintText: 'Nhập địa chỉ giao hàng',
                      prefixIcon: Icons.location_on_outlined,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập địa chỉ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.sm),
                    AppTextField(
                      key: const Key('checkout-note-field'),
                      controller: _noteController,
                      labelText: 'Ghi chú',
                      hintText: 'VD: Không hành, ít cay...',
                      prefixIcon: Icons.sticky_note_2_outlined,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.md),
              _SectionCard(
                child: _VoucherSection(
                  controller: _voucherController,
                  availableVouchers: availableVouchers,
                  appliedVoucher: _appliedVoucher,
                  voucherError: _voucherError,
                  total: total,
                  discount: discount,
                  onApply: () => _applyVoucher(total),
                  onSuggestionSelected: (voucher) =>
                      _applyVoucher(total, code: voucher.code),
                  onRemove: _removeVoucher,
                  onInputChanged: (_) {
                    if (_voucherError != null) {
                      setState(() => _voucherError = null);
                    }
                  },
                ),
              ),
              const SizedBox(height: AppSizes.md),
              _SectionCard(
                child: _PaymentSection(
                  selectedMethod: _paymentMethod,
                  onSelected: (method) =>
                      setState(() => _paymentMethod = method),
                ),
              ),
              const SizedBox(height: AppSizes.md),
              _SectionCard(
                child: _OrderReviewSection(
                  selectedItems: selectedItems,
                  subtotal: total,
                  discount: discount,
                  finalTotal: finalTotal,
                ),
              ),
              if (selectedItems.isEmpty)
                _InlineWarning(
                  message:
                      'Vui lòng chọn ít nhất 1 món trong giỏ hàng để thanh toán.',
                ),
              if (user == null)
                const _InlineWarning(
                  message:
                      'Phiên đăng nhập không hợp lệ. Vui lòng đăng nhập lại.',
                ),
              const SizedBox(height: AppSizes.md),
              PrimaryButton(
                key: const Key('checkout-place-order-button'),
                label: 'Xác nhận đặt hàng',
                icon: Icons.receipt_long_outlined,
                isLoading: _isPlacingOrder,
                onPressed: _isPlacingOrder
                    ? null
                    : () => _placeOrder(
                        user: user,
                        selectedItems: selectedItems,
                        cartProvider: cartProvider,
                        total: total,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _placeOrder({
    required UserModel? user,
    required List<CartItemModel> selectedItems,
    required CartProvider cartProvider,
    required int total,
  }) async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.'),
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ít nhất 1 món để thanh toán'),
        ),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    VoucherModel? voucher = _appliedVoucher;
    if (voucher != null) {
      voucher = context.read<VoucherService>().validateVoucher(
        voucher.code,
        total,
      );
      if (voucher == null) {
        setState(() {
          _appliedVoucher = null;
          _voucherError = 'Mã không hợp lệ hoặc chưa đủ điều kiện';
        });
        return;
      }
    }

    final orderProvider = context.read<OrderProvider>();
    setState(() => _isPlacingOrder = true);
    try {
      final order = await orderProvider.placeOrder(
        userId: user.id,
        items: selectedItems,
        paymentMethod: _paymentMethod,
        address: _addressController.text.trim(),
        note: _noteController.text.trim(),
        voucher: voucher,
      );

      await cartProvider.clearSelected(user.phone);

      if (!mounted) return;
      setState(() => _isPlacingOrder = false);
      await _showOrderConfirmation(order);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }

  Future<void> _showOrderConfirmation(OrderModel order) async {
    final parentContext = context;

    await showModalBottomSheet<void>(
      context: parentContext,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      showDragHandle: true,
      builder: (sheetContext) {
        return _OrderSuccessSheet(
          order: order,
          onTrackOrder: () {
            Navigator.pop(sheetContext);
            Navigator.pushReplacement(
              parentContext,
              MaterialPageRoute(
                builder: (context) =>
                    TrackingOrderScreen(orderId: order.orderId),
              ),
            );
          },
        );
      },
    );
  }
}

class _CheckoutSummaryBanner extends StatelessWidget {
  const _CheckoutSummaryBanner({
    required this.selectedItemCount,
    required this.selectedQuantity,
    required this.total,
  });

  final int selectedItemCount;
  final int selectedQuantity;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.32),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(Icons.shopping_bag_outlined, color: colorScheme.primary),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$selectedItemCount mục, $selectedQuantity món đã chọn',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  'Kiểm tra lại thông tin trước khi đặt hàng.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          PriceText(amount: total),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(padding: const EdgeInsets.all(AppSizes.md), child: child),
    );
  }
}

class _VoucherSection extends StatelessWidget {
  const _VoucherSection({
    required this.controller,
    required this.availableVouchers,
    required this.appliedVoucher,
    required this.voucherError,
    required this.total,
    required this.discount,
    required this.onApply,
    required this.onSuggestionSelected,
    required this.onRemove,
    required this.onInputChanged,
  });

  final TextEditingController controller;
  final List<VoucherModel> availableVouchers;
  final VoucherModel? appliedVoucher;
  final String? voucherError;
  final int total;
  final int discount;
  final VoidCallback onApply;
  final ValueChanged<VoucherModel> onSuggestionSelected;
  final VoidCallback onRemove;
  final ValueChanged<String> onInputChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Voucher giảm giá',
          subtitle: 'Chọn mã phù hợp hoặc nhập mã thủ công.',
        ),
        if (availableVouchers.isNotEmpty) ...[
          const SizedBox(height: AppSizes.md),
          Wrap(
            spacing: AppSizes.sm,
            runSpacing: AppSizes.sm,
            children: availableVouchers
                .map(
                  (voucher) => _VoucherChip(
                    voucher: voucher,
                    enabled: total >= voucher.minOrderAmount,
                    isSelected: appliedVoucher?.code == voucher.code,
                    onSelected: () => onSuggestionSelected(voucher),
                  ),
                )
                .toList(),
          ),
        ],
        const SizedBox(height: AppSizes.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextField(
                key: const Key('checkout-voucher-field'),
                controller: controller,
                labelText: 'Mã voucher',
                hintText: 'Nhập mã voucher',
                prefixIcon: Icons.local_offer_outlined,
                textInputAction: TextInputAction.done,
                onChanged: onInputChanged,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            SecondaryButton(
              key: const Key('checkout-apply-voucher-button'),
              label: 'Áp dụng',
              onPressed: onApply,
              fullWidth: false,
            ),
          ],
        ),
        if (voucherError != null) ...[
          const SizedBox(height: AppSizes.sm),
          Text(
            voucherError!,
            key: const Key('checkout-voucher-error'),
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        if (appliedVoucher != null) ...[
          const SizedBox(height: AppSizes.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, color: colorScheme.secondary),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Text(
                    'Đã áp dụng ${appliedVoucher!.code}: -${FormatUtils.formatCurrency(discount)}',
                    key: const Key('checkout-applied-voucher'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  key: const Key('checkout-remove-voucher-button'),
                  tooltip: 'Bỏ voucher',
                  onPressed: onRemove,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _VoucherChip extends StatelessWidget {
  const _VoucherChip({
    required this.voucher,
    required this.enabled,
    required this.isSelected,
    required this.onSelected,
  });

  final VoucherModel voucher;
  final bool enabled;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final discountLabel = voucher.discountPercent > 0
        ? '${(voucher.discountPercent * 100).round()}%'
        : FormatUtils.formatCurrency(voucher.discountAmount);

    return ChoiceChip(
      key: Key('checkout-voucher-chip-${voucher.code}'),
      selected: isSelected,
      onSelected: enabled ? (_) => onSelected() : null,
      label: Text('$discountLabel - ${voucher.code}'),
      tooltip: enabled
          ? 'Áp dụng ${voucher.code}'
          : 'Đơn tối thiểu ${FormatUtils.formatCurrency(voucher.minOrderAmount)}',
    );
  }
}

class _PaymentSection extends StatelessWidget {
  const _PaymentSection({
    required this.selectedMethod,
    required this.onSelected,
  });

  final PaymentMethod selectedMethod;
  final ValueChanged<PaymentMethod> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Phương thức thanh toán',
          subtitle: 'Thanh toán vẫn là mô phỏng trong ứng dụng demo.',
        ),
        const SizedBox(height: AppSizes.md),
        _PaymentMethodCard(
          key: const Key('checkout-payment-cod'),
          method: PaymentMethod.cod,
          icon: Icons.payments_outlined,
          description: 'Trả tiền mặt khi nhận món.',
          selected: selectedMethod == PaymentMethod.cod,
          onTap: () => onSelected(PaymentMethod.cod),
        ),
        const SizedBox(height: AppSizes.sm),
        _PaymentMethodCard(
          key: const Key('checkout-payment-ewallet'),
          method: PaymentMethod.ewallet,
          icon: Icons.account_balance_wallet_outlined,
          description: 'Ví điện tử mô phỏng, không lưu thông tin thật.',
          selected: selectedMethod == PaymentMethod.ewallet,
          onTap: () => onSelected(PaymentMethod.ewallet),
        ),
      ],
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    super.key,
    required this.method,
    required this.icon,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethod method;
  final IconData icon;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primaryContainer.withValues(alpha: 0.36)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.38),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? colorScheme.primary : null),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? colorScheme.primary : colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderReviewSection extends StatelessWidget {
  const _OrderReviewSection({
    required this.selectedItems,
    required this.subtotal,
    required this.discount,
    required this.finalTotal,
  });

  final List<CartItemModel> selectedItems;
  final int subtotal;
  final int discount;
  final int finalTotal;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Tóm tắt đơn hàng',
          subtitle:
              '${selectedItems.length} mục trong đơn thanh toán hiện tại.',
        ),
        const SizedBox(height: AppSizes.md),
        ...selectedItems.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.sm),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${item.quantity}x ${item.product.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Text(FormatUtils.formatCurrency(item.totalPrice)),
              ],
            ),
          ),
        ),
        Divider(color: colorScheme.outlineVariant),
        _AmountRow(label: 'Tạm tính', amount: subtotal),
        if (discount > 0)
          _AmountRow(
            label: 'Giảm giá',
            amount: -discount,
            color: colorScheme.error,
          ),
        const SizedBox(height: AppSizes.xs),
        _AmountRow(
          label: 'Tổng thanh toán',
          amount: finalTotal,
          emphasized: true,
        ),
      ],
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.amount,
    this.color,
    this.emphasized = false,
  });

  final String label;
  final int amount;
  final Color? color;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amountText = amount < 0
        ? '-${FormatUtils.formatCurrency(amount.abs())}'
        : FormatUtils.formatCurrency(amount);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: emphasized
                ? theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  )
                : theme.textTheme.bodyMedium,
          ),
          Text(
            amountText,
            key: emphasized ? const Key('checkout-final-total') : null,
            style:
                (emphasized
                        ? theme.textTheme.titleMedium
                        : theme.textTheme.bodyMedium)
                    ?.copyWith(
                      color:
                          color ??
                          (emphasized ? theme.colorScheme.primary : null),
                      fontWeight: emphasized
                          ? FontWeight.w900
                          : FontWeight.w700,
                    ),
          ),
        ],
      ),
    );
  }
}

class _InlineWarning extends StatelessWidget {
  const _InlineWarning({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.sm),
      child: Text(
        message,
        style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _OrderSuccessSheet extends StatelessWidget {
  const _OrderSuccessSheet({required this.order, required this.onTrackOrder});

  final OrderModel order;
  final VoidCallback onTrackOrder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final shortOrderId = order.orderId.length <= 8
        ? order.orderId
        : order.orderId.substring(0, 8);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.md,
            AppSizes.sm,
            AppSizes.md,
            AppSizes.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 56,
                color: colorScheme.primary,
              ),
              const SizedBox(height: AppSizes.md),
              Text(
                'Đặt hàng thành công',
                key: const Key('checkout-success-title'),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                'Đơn #$shortOrderId đang chờ xác nhận.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSizes.md),
              _AmountRow(
                label: 'Tổng thanh toán',
                amount: order.finalAmount,
                emphasized: true,
              ),
              _SuccessInfoRow(
                label: 'Thanh toán',
                value: order.paymentMethod.label,
              ),
              _SuccessInfoRow(
                label: 'Trạng thái',
                value: OrderStatus.created.displayName,
              ),
              const SizedBox(height: AppSizes.md),
              PrimaryButton(
                key: const Key('checkout-track-order-button'),
                label: 'Theo dõi đơn hàng',
                icon: Icons.delivery_dining_outlined,
                onPressed: onTrackOrder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessInfoRow extends StatelessWidget {
  const _SuccessInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
