import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';

/// Static help center dialog with demo content.
/// No backend, no provider, no service dependency.
class HelpCenterDialog extends StatelessWidget {
  const HelpCenterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      key: const Key('help-center-dialog'),
      title: Row(
        children: [
          Icon(Icons.help_outline, color: colorScheme.primary),
          const SizedBox(width: AppSizes.sm),
          Text(
            'Trung tâm trợ giúp',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HelpContactRow(
              icon: Icons.phone_outlined,
              label: 'Hotline',
              value: '1900-6868',
              colorScheme: colorScheme,
            ),
            const SizedBox(height: AppSizes.md),
            _HelpContactRow(
              icon: Icons.access_time_outlined,
              label: 'Giờ hỗ trợ',
              value: '8:00 – 22:00 hàng ngày',
              colorScheme: colorScheme,
            ),
            const SizedBox(height: AppSizes.md),
            _HelpContactRow(
              icon: Icons.mail_outline,
              label: 'Email',
              value: 'support@pkafood.vn',
              colorScheme: colorScheme,
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              'Câu hỏi thường gặp',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            _FaqBullet(text: 'Cách đặt hàng trên ứng dụng'),
            _FaqBullet(text: 'Cách theo dõi trạng thái đơn hàng'),
            _FaqBullet(text: 'Cách đổi mật khẩu tài khoản'),
            _FaqBullet(text: 'Chính sách hoàn trả và hủy đơn'),
            const SizedBox(height: AppSizes.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Text(
                'Đây là bản demo. Hỗ trợ thực tế chưa được triển khai.',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
      ],
    );
  }
}

class _HelpContactRow extends StatelessWidget {
  const _HelpContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppSizes.iconSm, color: colorScheme.primary),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FaqBullet extends StatelessWidget {
  const _FaqBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
