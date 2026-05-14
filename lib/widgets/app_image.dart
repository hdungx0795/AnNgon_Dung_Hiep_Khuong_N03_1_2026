import 'package:flutter/material.dart';

import '../core/constants/app_sizes.dart';

enum AppImageSource { asset, network }

enum AppImageFallbackKind { product, avatar, banner, illustration, generic }

class AppImage extends StatelessWidget {
  static const todoAssetProductImage = 'TODO_ASSET_PRODUCT_IMAGE';
  static const todoAssetAvatar = 'TODO_ASSET_AVATAR';
  static const todoAssetBanner = 'TODO_ASSET_BANNER';
  static const todoAssetIllustration = 'TODO_ASSET_ILLUSTRATION';

  const AppImage.asset(
    String? assetPath, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackKind = AppImageFallbackKind.generic,
    this.semanticLabel,
  }) : source = assetPath,
       sourceType = AppImageSource.asset;

  const AppImage.network(
    String? url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackKind = AppImageFallbackKind.generic,
    this.semanticLabel,
  }) : source = url,
       sourceType = AppImageSource.network;

  const AppImage.placeholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.fallbackKind = AppImageFallbackKind.generic,
    this.semanticLabel,
  }) : source = null,
       sourceType = AppImageSource.asset,
       fit = BoxFit.cover;

  final String? source;
  final AppImageSource sourceType;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final AppImageFallbackKind fallbackKind;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(AppSizes.radiusSm);
    final resolvedSource = source?.trim();

    Widget child;
    if (resolvedSource == null || resolvedSource.isEmpty) {
      child = _ImagePlaceholder(
        kind: fallbackKind,
        width: width,
        height: height,
        semanticLabel: semanticLabel,
      );
    } else if (sourceType == AppImageSource.network) {
      child = Image.network(
        resolvedSource,
        width: width,
        height: height,
        fit: fit,
        semanticLabel: semanticLabel,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _ImagePlaceholder(
            kind: fallbackKind,
            width: width,
            height: height,
            semanticLabel: semanticLabel,
            showProgress: true,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _ImagePlaceholder(
            kind: fallbackKind,
            width: width,
            height: height,
            semanticLabel: semanticLabel,
          );
        },
      );
    } else {
      child = Image.asset(
        resolvedSource,
        width: width,
        height: height,
        fit: fit,
        semanticLabel: semanticLabel,
        errorBuilder: (context, error, stackTrace) {
          return _ImagePlaceholder(
            kind: fallbackKind,
            width: width,
            height: height,
            semanticLabel: semanticLabel,
          );
        },
      );
    }

    return ClipRRect(borderRadius: radius, child: child);
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({
    required this.kind,
    this.width,
    this.height,
    this.semanticLabel,
    this.showProgress = false,
  });

  final AppImageFallbackKind kind;
  final double? width;
  final double? height;
  final String? semanticLabel;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: semanticLabel ?? _labelForKind(kind),
      image: true,
      child: Container(
        key: const Key('app-image-placeholder'),
        width: width,
        height: height,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        alignment: Alignment.center,
        child: showProgress
            ? SizedBox(
                width: AppSizes.iconMd,
                height: AppSizes.iconMd,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              )
            : Icon(
                _iconForKind(kind),
                color: colorScheme.onSurfaceVariant,
                size: _iconSizeForKind(kind),
              ),
      ),
    );
  }

  IconData _iconForKind(AppImageFallbackKind kind) {
    switch (kind) {
      case AppImageFallbackKind.product:
        return Icons.fastfood_outlined;
      case AppImageFallbackKind.avatar:
        return Icons.person_outline;
      case AppImageFallbackKind.banner:
        return Icons.image_outlined;
      case AppImageFallbackKind.illustration:
        return Icons.auto_awesome_outlined;
      case AppImageFallbackKind.generic:
        return Icons.image_not_supported_outlined;
    }
  }

  double _iconSizeForKind(AppImageFallbackKind kind) {
    switch (kind) {
      case AppImageFallbackKind.avatar:
        return AppSizes.iconMd;
      case AppImageFallbackKind.banner:
        return AppSizes.iconLg;
      case AppImageFallbackKind.product:
      case AppImageFallbackKind.illustration:
      case AppImageFallbackKind.generic:
        return AppSizes.iconLg;
    }
  }

  String _labelForKind(AppImageFallbackKind kind) {
    switch (kind) {
      case AppImageFallbackKind.product:
        return 'Product image placeholder';
      case AppImageFallbackKind.avatar:
        return 'Avatar placeholder';
      case AppImageFallbackKind.banner:
        return 'Banner placeholder';
      case AppImageFallbackKind.illustration:
        return 'Illustration placeholder';
      case AppImageFallbackKind.generic:
        return 'Image placeholder';
    }
  }
}
