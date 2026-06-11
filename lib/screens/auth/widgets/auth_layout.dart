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
    this.eyebrow,
    this.highlights = const [],
    this.footer,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final String? eyebrow;
  final List<AuthHighlight> highlights;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authTextButtonStyle = TextButton.styleFrom(
      foregroundColor: colorScheme.onSurface,
      textStyle: theme.textTheme.labelLarge?.copyWith(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600,
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
                  Colors.black.withValues(alpha: 0.32),
                  const Color(0xFF2A0705).withValues(alpha: 0.44),
                  Colors.black.withValues(alpha: 0.56),
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
                        height: MediaQuery.sizeOf(context).height * 0.035,
                      ),
                      Container(
                        padding: const EdgeInsets.all(AppSizes.lg),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusLg,
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.24),
                              blurRadius: 28,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _AuthHeader(
                              eyebrow: eyebrow,
                              title: title,
                              subtitle: subtitle,
                            ),
                            if (highlights.isNotEmpty) ...[
                              const SizedBox(height: AppSizes.md),
                              _AuthHighlights(highlights: highlights),
                            ],
                            const SizedBox(height: AppSizes.lg),
                            ...children,
                            if (footer != null) ...[
                              const SizedBox(height: AppSizes.md),
                              _AuthFooter(child: footer!),
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

class AuthHighlight {
  const AuthHighlight({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String? eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 116,
              height: 116,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.24),
                    colorScheme.primary.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSizes.xs),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(color: colorScheme.outlineVariant),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: Image.asset(
                  _authLogoAsset,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        Text(
          'PKA Food',
          textAlign: TextAlign.center,
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
        if (eyebrow != null && eyebrow!.trim().isNotEmpty) ...[
          const SizedBox(height: AppSizes.xs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.xs,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Text(
              eyebrow!,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSizes.md),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthHighlights extends StatelessWidget {
  const _AuthHighlights({required this.highlights});

  final List<AuthHighlight> highlights;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSizes.sm,
      runSpacing: AppSizes.sm,
      children: highlights.map((highlight) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.sm,
            vertical: AppSizes.xs,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.64),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(highlight.icon, size: 15, color: colorScheme.primary),
              const SizedBox(width: AppSizes.xs),
              Text(
                highlight.label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _AuthFooter extends StatelessWidget {
  const _AuthFooter({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      alignment: Alignment.center,
      child: child,
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
