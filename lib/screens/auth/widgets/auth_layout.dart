import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';

const _authBackgroundAsset = 'assets/images/log_themes/2.jpeg';
const _authLogoAsset = 'assets/images/logo/logo1.jpeg';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.footer,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authTextButtonStyle = TextButton.styleFrom(
      foregroundColor: colorScheme.onSurface,
      textStyle: theme.textTheme.labelLarge?.copyWith(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w500,
      ),
    );

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            _authBackgroundAsset,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.28),
                  const Color(0xFF2A0705).withValues(alpha: 0.42),
                  Colors.black.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
          SafeArea(
            child: TextButtonTheme(
              data: TextButtonThemeData(style: authTextButtonStyle),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: ListView(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    children: [
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.05,
                      ),
                      Container(
                        padding: const EdgeInsets.all(AppSizes.lg),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusLg,
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.28),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.22),
                              blurRadius: 24,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusMd,
                                ),
                                child: Image.asset(
                                  _authLogoAsset,
                                  width: 88,
                                  height: 88,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSizes.md),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: AppSizes.sm),
                            Text(
                              subtitle,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: AppSizes.lg),
                            ...children,
                            if (footer != null) ...[
                              const SizedBox(height: AppSizes.md),
                              footer!,
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSizes.lg),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthStatusMessage extends StatelessWidget {
  const AuthStatusMessage({
    super.key,
    required this.message,
    this.isError = true,
  });

  final String? message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = isError
        ? colorScheme.errorContainer
        : colorScheme.primaryContainer;
    final foregroundColor = isError
        ? colorScheme.onErrorContainer
        : colorScheme.onPrimaryContainer;

    return Container(
      key: const Key('auth-status-message'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: foregroundColor,
            size: AppSizes.iconSm,
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
