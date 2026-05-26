import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/format_utils.dart';

const _qrPaymentAsset = 'assets/images/QR/qr.png';
const _merchantName = 'PHENIKAA FOOD APP';

class QrPaymentScreen extends StatefulWidget {
  const QrPaymentScreen({
    super.key,
    required this.amount,
    required this.onPaymentConfirmed,
  });

  final int amount;
  final VoidCallback onPaymentConfirmed;

  @override
  State<QrPaymentScreen> createState() => _QrPaymentScreenState();
}

class _QrPaymentScreenState extends State<QrPaymentScreen>
    with SingleTickerProviderStateMixin {
  late final String _transferContent;
  bool _showConfirmButton = false;
  bool _isConfirming = false;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _transferContent = _generateTransferContent();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _showConfirmButton = true);
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _generateTransferContent() {
    final suffix = DateTime.now().millisecondsSinceEpoch.toString().substring(
      7,
    );
    return 'PKA $suffix';
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép $label'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Future<void> _handleConfirm() async {
    setState(() => _isConfirming = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) widget.onPaymentConfirmed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final amountText = FormatUtils.formatCurrency(widget.amount);

    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán QR')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(color: colorScheme.outlineVariant),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Quét mã để chuyển khoản',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    'Kiểm tra đúng số tiền và nội dung trước khi xác nhận.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Container(
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      child: Image.asset(
                        _qrPaymentAsset,
                        key: const Key('qr-payment-image'),
                        width: 232,
                        height: 232,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.sm,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      amountText,
                      key: const Key('qr-payment-amount'),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Column(
                children: [
                  const _PaymentInfoRow(
                    label: 'Đơn vị nhận thanh toán',
                    value: _merchantName,
                    icon: Icons.storefront_outlined,
                  ),
                  const Divider(height: AppSizes.lg),
                  _PaymentInfoRow(
                    label: 'Số tiền',
                    value: amountText,
                    icon: Icons.payments_outlined,
                    valueColor: colorScheme.primary,
                    onCopy: () => _copyToClipboard(amountText, 'số tiền'),
                  ),
                  const Divider(height: AppSizes.lg),
                  _PaymentInfoRow(
                    label: 'Nội dung chuyển khoản',
                    value: _transferContent,
                    icon: Icons.description_outlined,
                    valueColor: colorScheme.primary,
                    onCopy: () =>
                        _copyToClipboard(_transferContent, 'nội dung'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.28),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.warning,
                    size: AppSizes.iconSm,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      'Nếu ứng dụng ngân hàng chưa tự điền, hãy nhập đúng số tiền và nội dung chuyển khoản ở trên.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            if (!_showConfirmButton)
              Column(
                children: [
                  const SizedBox(
                    width: AppSizes.iconMd,
                    height: AppSizes.iconMd,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    'Đang chờ xác nhận thanh toán...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              )
            else
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  height: AppSizes.buttonHeight,
                  child: FilledButton.icon(
                    key: const Key('qr-payment-confirm-button'),
                    onPressed: _isConfirming ? null : _handleConfirm,
                    icon: _isConfirming
                        ? const SizedBox(
                            width: AppSizes.iconSm,
                            height: AppSizes.iconSm,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_circle_outline),
                    label: Text(
                      _isConfirming ? 'Đang xử lý...' : 'Tôi đã chuyển khoản',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PaymentInfoRow extends StatelessWidget {
  const _PaymentInfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.onCopy,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onCopy;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: AppSizes.iconSm, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        if (onCopy != null)
          IconButton(
            tooltip: 'Sao chép $label',
            onPressed: onCopy,
            icon: const Icon(Icons.copy, size: AppSizes.iconSm),
            color: colorScheme.primary,
          ),
      ],
    );
  }
}
