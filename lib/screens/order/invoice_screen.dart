import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/utils/format_utils.dart';
import '../../models/enums/order_status.dart';
import '../../models/enums/payment_method.dart';
import '../../models/order_model.dart';
import '../../widgets/primary_button.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final shortOrderId = _shortOrderId(order.orderId);

    return Scaffold(
      appBar: AppBar(title: const Text('Hóa đơn')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              key: const Key('invoice-summary-card'),
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 44,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: AppSizes.md),
                  Text(
                    'PHENIKAA FOOD APP',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    'Hóa đơn thanh toán',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Divider(height: AppSizes.lg),
                  _InvoiceInfoRow(label: 'Mã đơn', value: '#$shortOrderId'),
                  _InvoiceInfoRow(
                    label: 'Thời gian',
                    value: FormatUtils.formatDateTime(order.createdAt),
                  ),
                  _InvoiceInfoRow(
                    label: 'Thanh toán',
                    value: order.paymentMethod.label,
                  ),
                  _InvoiceInfoRow(
                    label: 'Trạng thái',
                    value: order.status.label,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),
            _InvoiceSection(
              title: 'Chi tiết món',
              child: Column(
                children: [
                  for (final item in order.items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.sm),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.quantity}x ${item.productName}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.md),
                          Text(
                            FormatUtils.formatCurrency(
                              item.unitPrice * item.quantity,
                            ),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),
            _InvoiceSection(
              title: 'Thanh toán',
              child: Column(
                children: [
                  _AmountLine(label: 'Tạm tính', amount: order.totalAmount),
                  if (order.discount > 0)
                    _AmountLine(
                      label: order.voucherCode == null
                          ? 'Giảm giá'
                          : 'Giảm giá (${order.voucherCode})',
                      amount: -order.discount,
                      color: colorScheme.error,
                    ),
                  const Divider(height: AppSizes.lg),
                  _AmountLine(
                    label: 'Tổng thanh toán',
                    amount: order.finalAmount,
                    emphasized: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),
            _InvoiceSection(
              title: 'Giao hàng',
              child: Column(
                children: [
                  _InvoiceInfoRow(
                    label: 'Địa chỉ',
                    value: order.deliveryAddress,
                    multiline: true,
                  ),
                  if (order.note.trim().isNotEmpty)
                    _InvoiceInfoRow(
                      label: 'Ghi chú',
                      value: order.note,
                      multiline: true,
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),
            SecondaryButton(
              label: 'Sao chép mã đơn',
              icon: Icons.copy_outlined,
              onPressed: () => _copyOrderId(context),
            ),
          ],
        ),
      ),
    );
  }

  String _shortOrderId(String orderId) {
    return orderId.length <= 8 ? orderId : orderId.substring(0, 8);
  }

  void _copyOrderId(BuildContext context) {
    Clipboard.setData(ClipboardData(text: order.orderId));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã sao chép mã đơn')));
  }
}

class _InvoiceSection extends StatelessWidget {
  const _InvoiceSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          child,
        ],
      ),
    );
  }
}

class _InvoiceInfoRow extends StatelessWidget {
  const _InvoiceInfoRow({
    required this.label,
    required this.value,
    this.multiline = false,
  });

  final String label;
  final String value;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: Row(
        crossAxisAlignment: multiline
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              value,
              textAlign: multiline ? TextAlign.start : TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountLine extends StatelessWidget {
  const _AmountLine({
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
        children: [
          Expanded(
            child: Text(
              label,
              style: emphasized
                  ? theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    )
                  : theme.textTheme.bodyMedium,
            ),
          ),
          Text(
            amountText,
            key: emphasized ? const Key('invoice-final-total') : null,
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
