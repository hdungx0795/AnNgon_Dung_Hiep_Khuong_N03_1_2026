import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pka_food/core/constants/app_sizes.dart';
import 'package:pka_food/providers/auth_provider.dart';
import 'package:pka_food/providers/product_provider.dart';
import 'package:pka_food/providers/cart_provider.dart';
import 'package:pka_food/providers/favorites_provider.dart';
import 'package:pka_food/providers/order_provider.dart';
import 'package:pka_food/services/prefs_service.dart';
import 'package:pka_food/widgets/app_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final productProvider = context.read<ProductProvider>();
    final authProvider = context.read<AuthProvider>();
    final cartProvider = context.read<CartProvider>();
    final favoritesProvider = context.read<FavoritesProvider>();
    final orderProvider = context.read<OrderProvider>();
    final prefsService = context.read<PrefsService>();

    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Load initial data
    await productProvider.loadProducts();
    await authProvider.checkAuth();

    if (!mounted) return;

    final onboardingDone = await prefsService.isOnboardingDone();

    if (!mounted) return;

    final user = authProvider.currentUser;
    if (user != null) {
      await cartProvider.loadCart(user.phone);
      await favoritesProvider.loadFavorites(user.phone);
      await orderProvider.loadOrders(user.id);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      onboardingDone ? '/login' : '/onboarding',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.xl),
        decoration: BoxDecoration(color: colorScheme.primary),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Semantics(
              label: 'PKA Food',
              child: Container(
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: AppImage.asset(
                  'assets/images/products/PKA.png',
                  width: 104,
                  height: 104,
                  fit: BoxFit.contain,
                  fallbackKind: AppImageFallbackKind.generic,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              'PKA Food',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Ăn ngon - Sống khỏe',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onPrimary.withValues(alpha: 0.78),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'Đang chuẩn bị trải nghiệm đặt món',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onPrimary.withValues(alpha: 0.72),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
