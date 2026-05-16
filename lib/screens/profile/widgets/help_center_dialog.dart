import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../chat/delivery_chat_screen.dart';
import '../help_center_screen.dart';

/// Static help center dialog with professional content.
class HelpCenterDialog extends StatelessWidget {
  const HelpCenterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      key: const Key('help-center-dialog'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      title: Row(
        children: [
          Icon(Icons.help_outline, color: colorScheme.primary),
          const SizedBox(width: AppSizes.sm),
          Text(
            'Trung tâm trợ giúp',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          const Divider(),
          const SizedBox(height: AppSizes.md),
          
          // Action Buttons
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeliveryChatScreen(
                    shipperName: 'Hỗ trợ viên AnNgon',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline, size: 18),
            label: const Text('Chat với hỗ trợ viên'),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
              );
            },
            icon: const Icon(Icons.menu_book_outlined, size: 18),
            label: const Text('Xem câu hỏi thường gặp'),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
            ),
          ),
          
          const SizedBox(height: AppSizes.lg),
          Text(
            'AnNgon luôn sẵn sàng hỗ trợ bạn 24/7.',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
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

