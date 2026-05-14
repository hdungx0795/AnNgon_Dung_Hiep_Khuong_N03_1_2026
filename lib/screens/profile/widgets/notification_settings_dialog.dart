import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';

/// Self-contained notification settings dialog with ephemeral local state.
/// No provider, service, persistence, or OS permission dependency.
class NotificationSettingsDialog extends StatefulWidget {
  const NotificationSettingsDialog({super.key});

  @override
  State<NotificationSettingsDialog> createState() =>
      _NotificationSettingsDialogState();
}

class _NotificationSettingsDialogState
    extends State<NotificationSettingsDialog> {
  bool _enabled = false;
  bool _orderNotifications = true;
  bool _promoNotifications = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      key: const Key('notification-settings-dialog'),
      title: Row(
        children: [
          Icon(Icons.notifications_outlined, color: colorScheme.primary),
          const SizedBox(width: AppSizes.sm),
          Text(
            _enabled ? 'Cài đặt thông báo' : 'Thông báo',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
      content: _enabled ? _buildEnabledContent(colorScheme) : _buildDisabledContent(colorScheme, textTheme),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
      ],
    );
  }

  Widget _buildDisabledContent(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Column(
            children: [
              Icon(
                Icons.notifications_off_outlined,
                size: AppSizes.iconLg,
                color: colorScheme.onPrimaryContainer,
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                'Bật thông báo để nhận cập nhật đơn hàng và ưu đãi hấp dẫn.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.md),
        FilledButton.icon(
          key: const Key('notification-enable-button'),
          onPressed: () => setState(() => _enabled = true),
          icon: const Icon(Icons.notifications_active_outlined),
          label: const Text('Bật thông báo'),
        ),
      ],
    );
  }

  Widget _buildEnabledContent(ColorScheme colorScheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SwitchListTile(
          key: const Key('notification-order-toggle'),
          title: const Text('Thông báo đơn hàng'),
          subtitle: const Text('Cập nhật trạng thái giao hàng'),
          secondary: Icon(Icons.local_shipping_outlined,
              color: colorScheme.primary),
          value: _orderNotifications,
          onChanged: (val) => setState(() => _orderNotifications = val),
        ),
        const Divider(height: 1),
        SwitchListTile(
          key: const Key('notification-promo-toggle'),
          title: const Text('Deal / Khuyến mãi hot'),
          subtitle: const Text('Ưu đãi và mã giảm giá mới'),
          secondary:
              Icon(Icons.local_offer_outlined, color: colorScheme.primary),
          value: _promoNotifications,
          onChanged: (val) => setState(() => _promoNotifications = val),
        ),
        const Divider(height: 1),
        const SizedBox(height: AppSizes.sm),
        TextButton.icon(
          key: const Key('notification-disable-button'),
          onPressed: () => setState(() {
            _enabled = false;
            _orderNotifications = true;
            _promoNotifications = true;
          }),
          icon: const Icon(Icons.notifications_off_outlined),
          label: const Text('Tắt tất cả thông báo'),
        ),
      ],
    );
  }
}
