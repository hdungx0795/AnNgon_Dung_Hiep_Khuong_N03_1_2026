import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';

class DeliveryCallScreen extends StatelessWidget {
  final String shipperName;

  const DeliveryCallScreen({super.key, required this.shipperName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.16),
      colorScheme.surface,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  key: const Key('delivery-call-close-button'),
                  tooltip: 'Kết thúc cuộc gọi',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
              const Spacer(),
              Container(
                width: 132,
                height: 132,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primaryContainer,
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.24),
                    width: 6,
                  ),
                ),
                child: Icon(
                  Icons.delivery_dining,
                  size: 72,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              Text(
                shipperName,
                key: const Key('delivery-call-shipper-name'),
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                'Đang gọi...',
                key: const Key('delivery-call-status'),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _CallAction(icon: Icons.mic_off_outlined, label: 'Tắt tiếng'),
                  _CallAction(
                    icon: Icons.volume_up_outlined,
                    label: 'Loa ngoài',
                  ),
                  _CallAction(
                    icon: Icons.videocam_off_outlined,
                    label: 'Video',
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xl),
              FloatingActionButton.large(
                key: const Key('delivery-call-end-button'),
                tooltip: 'Kết thúc cuộc gọi',
                heroTag: 'delivery-call-end',
                onPressed: () => Navigator.pop(context),
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
                child: const Icon(Icons.call_end_rounded),
              ),
              const SizedBox(height: AppSizes.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _CallAction extends StatelessWidget {
  const _CallAction({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSizes.sm),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
