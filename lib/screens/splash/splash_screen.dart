// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pka_food/providers/auth_provider.dart';
import 'package:pka_food/providers/product_provider.dart';
import 'package:pka_food/providers/cart_provider.dart';
import 'package:pka_food/providers/favorites_provider.dart';
import 'package:pka_food/providers/order_provider.dart';
import 'package:pka_food/core/constants/app_colors.dart';
import 'package:pka_food/services/prefs_service.dart';

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
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Load initial data
    await context.read<ProductProvider>().loadProducts();
    await context.read<AuthProvider>().checkAuth();

    if (!mounted) return;

    final onboardingDone = await PrefsService().isOnboardingDone();

    if (!mounted) return;

    final auth = context.read<AuthProvider>();
    if (auth.isAuthenticated) {
      final phone = auth.currentUser!.phone;
      await context.read<CartProvider>().loadCart(phone);
      await context.read<FavoritesProvider>().loadFavorites(phone);
      await context.read<OrderProvider>().loadOrders(auth.currentUser!.id);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      if (onboardingDone) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/products/PKA.png',
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.fastfood,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'PKA Food',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ăn ngon - Sống khỏe',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
