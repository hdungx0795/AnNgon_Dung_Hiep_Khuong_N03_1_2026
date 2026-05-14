import 'package:flutter/material.dart';

import '../core/constants/app_sizes.dart';
import 'app_image.dart';
import 'primary_button.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.image,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final String? message;
  final IconData? icon;
  final Widget? image;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            image ??
                Icon(
                  icon ?? Icons.inbox_outlined,
                  size: 56,
                  color: colorScheme.onSurfaceVariant,
                ),
            const SizedBox(height: AppSizes.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: AppSizes.sm),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: AppSizes.lg),
              PrimaryButton(
                label: actionLabel!,
                onPressed: onActionPressed,
                fullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyStateIllustration extends StatelessWidget {
  const EmptyStateIllustration({super.key, this.assetPath});

  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    return AppImage.asset(
      assetPath,
      width: 120,
      height: 120,
      fit: BoxFit.contain,
      fallbackKind: AppImageFallbackKind.illustration,
    );
  }
}
