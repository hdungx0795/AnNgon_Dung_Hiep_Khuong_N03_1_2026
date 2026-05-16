import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/order_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'services/auth_service.dart';
import 'services/admin_auth_service.dart';
import 'services/admin_order_read_service.dart';
import 'services/admin_product_service.dart';
import 'services/cart_service.dart';
import 'services/order_service.dart';
import 'services/prefs_service.dart';
import 'services/product_service.dart';
import 'services/voucher_service.dart';

class PkaFoodApp extends StatelessWidget {
  const PkaFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => AdminAuthService()),
        Provider(create: (_) => AdminProductService()),
        Provider(create: (_) => AdminOrderReadService()),
        Provider(create: (_) => CartService()),
        Provider(create: (_) => ProductService()),
        Provider(create: (_) => OrderService()),
        Provider(create: (_) => PrefsService()),
        Provider(create: (_) => VoucherService()),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(context.read<AuthService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(context.read<CartService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(context.read<ProductService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(context.read<OrderService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoritesProvider(context.read<PrefsService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ThemeProvider(context.read<PrefsService>())..loadTheme(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'PKA Food v2.0',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/admin-login': (context) => const AdminLoginScreen(),
              '/admin': (context) => const AdminDashboardScreen(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => const HomeScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/forgot-password': (context) => const ForgotPasswordScreen(),
              '/checkout': (context) => const CheckoutScreen(),
              '/profile': (context) => const ProfileScreen(),
            },
          );
        },
      ),
    );
  }
}
