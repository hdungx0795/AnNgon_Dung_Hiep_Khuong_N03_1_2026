import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pka_food/core/theme/app_theme.dart';
import 'package:pka_food/models/order_model.dart';
import 'package:pka_food/models/user_model.dart';
import 'package:pka_food/models/user_prefs_model.dart';
import 'package:pka_food/providers/auth_provider.dart';
import 'package:pka_food/providers/cart_provider.dart';
import 'package:pka_food/providers/favorites_provider.dart';
import 'package:pka_food/providers/order_provider.dart';
import 'package:pka_food/providers/product_provider.dart';
import 'package:pka_food/screens/onboarding/onboarding_screen.dart';
import 'package:pka_food/screens/splash/splash_screen.dart';
import 'package:pka_food/services/auth_service.dart';
import 'package:pka_food/services/cart_service.dart';
import 'package:pka_food/services/database_service.dart';
import 'package:pka_food/services/order_service.dart';
import 'package:pka_food/services/prefs_service.dart';
import 'package:pka_food/services/product_service.dart';
import 'package:pka_food/widgets/app_widgets.dart';
import 'package:provider/provider.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;
  late _TestProductProvider productProvider;
  late _TestAuthProvider authProvider;
  late _TestCartProvider cartProvider;
  late _TestFavoritesProvider favoritesProvider;
  late _TestOrderProvider orderProvider;
  late _TestPrefsService prefsService;

  setUpAll(() async {
    hiveDirectory = await setUpTestHive();
  });

  setUp(() async {
    await Hive.box<UserModel>(DatabaseService.usersBoxName).clear();
    await Hive.box<OrderModel>(DatabaseService.ordersBoxName).clear();
    await Hive.box<UserPrefsModel>(DatabaseService.userPrefsBoxName).clear();
    await Hive.box(DatabaseService.sessionBoxName).clear();

    productProvider = _TestProductProvider();
    authProvider = _TestAuthProvider();
    cartProvider = _TestCartProvider();
    favoritesProvider = _TestFavoritesProvider();
    orderProvider = _TestOrderProvider();
    prefsService = _TestPrefsService();
  });

  tearDown(() {
    productProvider.dispose();
    authProvider.dispose();
    cartProvider.dispose();
    favoritesProvider.dispose();
    orderProvider.dispose();
  });

  tearDownAll(() async {
    await tearDownTestHive(hiveDirectory);
  });

  testWidgets('splash routes authenticated user to home after preload', (
    tester,
  ) async {
    authProvider.userAfterCheckAuth = _testUser();

    await _pumpSplashApp(
      tester,
      productProvider: productProvider,
      authProvider: authProvider,
      cartProvider: cartProvider,
      favoritesProvider: favoritesProvider,
      orderProvider: orderProvider,
      prefsService: prefsService,
    );
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    expect(find.text('Home route'), findsOneWidget);
    expect(productProvider.loadProductsCallCount, 1);
    expect(authProvider.checkAuthCallCount, 1);
    expect(cartProvider.loadedPhone, '0900000001');
    expect(favoritesProvider.loadedPhone, '0900000001');
    expect(orderProvider.loadedUserId, 1);
  });

  testWidgets('splash routes guest with onboarding incomplete to onboarding', (
    tester,
  ) async {
    await _pumpSplashApp(
      tester,
      productProvider: productProvider,
      authProvider: authProvider,
      cartProvider: cartProvider,
      favoritesProvider: favoritesProvider,
      orderProvider: orderProvider,
      prefsService: prefsService,
    );
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    expect(find.text('Onboarding route'), findsOneWidget);
    expect(productProvider.loadProductsCallCount, 1);
    expect(authProvider.checkAuthCallCount, 1);
    expect(cartProvider.loadCartCallCount, 0);
    expect(favoritesProvider.loadFavoritesCallCount, 0);
    expect(orderProvider.loadOrdersCallCount, 0);
  });

  testWidgets('splash routes guest with onboarding complete to login', (
    tester,
  ) async {
    prefsService.onboardingDone = true;

    await _pumpSplashApp(
      tester,
      productProvider: productProvider,
      authProvider: authProvider,
      cartProvider: cartProvider,
      favoritesProvider: favoritesProvider,
      orderProvider: orderProvider,
      prefsService: prefsService,
    );
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    expect(find.text('Login route'), findsOneWidget);
    expect(productProvider.loadProductsCallCount, 1);
    expect(authProvider.checkAuthCallCount, 1);
  });

  testWidgets('splash does not navigate after disposal before initialization', (
    tester,
  ) async {
    await _pumpSplashApp(
      tester,
      productProvider: productProvider,
      authProvider: authProvider,
      cartProvider: cartProvider,
      favoritesProvider: favoritesProvider,
      orderProvider: orderProvider,
      prefsService: prefsService,
    );

    await tester.pumpWidget(const MaterialApp(home: Text('Disposed')));
    await tester.pump(const Duration(seconds: 3));

    expect(find.text('Disposed'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('onboarding skip persists completion and navigates to login', (
    tester,
  ) async {
    await _pumpOnboardingApp(tester, prefsService);

    await tester.tap(find.byKey(const Key('onboarding-skip-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(await prefsService.isOnboardingDone(), isTrue);
    expect(find.text('Login route'), findsOneWidget);
  });

  testWidgets(
    'onboarding final CTA persists completion and navigates to login',
    (tester) async {
      await _pumpOnboardingApp(tester, prefsService);

      await tester.drag(
        find.byKey(const Key('onboarding-page-view')),
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();
      await tester.drag(
        find.byKey(const Key('onboarding-page-view')),
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('onboarding-primary-button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(await prefsService.isOnboardingDone(), isTrue);
      expect(find.text('Login route'), findsOneWidget);
    },
  );

  testWidgets('onboarding renders safely with image fallback support', (
    tester,
  ) async {
    await _pumpOnboardingApp(tester, prefsService);

    expect(find.text('Chào mừng đến với PKA Food'), findsOneWidget);
    expect(find.byType(AppImage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('onboarding ignores duplicate completion taps', (tester) async {
    final observer = _RouteRecorder();
    await _pumpOnboardingApp(tester, prefsService, observer: observer);

    await tester.tap(find.byKey(const Key('onboarding-skip-button')));
    await tester.tap(
      find.byKey(const Key('onboarding-skip-button')),
      warnIfMissed: false,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(await prefsService.isOnboardingDone(), isTrue);
    expect(observer.replacementCount, 1);
  });
}

Future<void> _pumpSplashApp(
  WidgetTester tester, {
  required _TestProductProvider productProvider,
  required _TestAuthProvider authProvider,
  required _TestCartProvider cartProvider,
  required _TestFavoritesProvider favoritesProvider,
  required _TestOrderProvider orderProvider,
  required PrefsService prefsService,
}) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductProvider>.value(value: productProvider),
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
        ChangeNotifierProvider<FavoritesProvider>.value(
          value: favoritesProvider,
        ),
        ChangeNotifierProvider<OrderProvider>.value(value: orderProvider),
        Provider<PrefsService>.value(value: prefsService),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        routes: {
          '/home': (_) => const Scaffold(body: Text('Home route')),
          '/login': (_) => const Scaffold(body: Text('Login route')),
          '/onboarding': (_) => const Scaffold(body: Text('Onboarding route')),
        },
        home: const SplashScreen(),
      ),
    ),
  );
}

Future<void> _pumpOnboardingApp(
  WidgetTester tester,
  PrefsService prefsService, {
  NavigatorObserver? observer,
}) async {
  await tester.pumpWidget(
    Provider<PrefsService>.value(
      value: prefsService,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        navigatorObservers: [?observer],
        routes: {'/login': (_) => const Scaffold(body: Text('Login route'))},
        home: const OnboardingScreen(),
      ),
    ),
  );
}

UserModel _testUser() {
  return UserModel(
    id: 1,
    name: 'Test User',
    phone: '0900000001',
    email: 'test@example.com',
    dob: '01/01/2000',
    passwordHash: 'hash',
    createdAt: DateTime(2026, 5, 14),
  );
}

class _TestProductProvider extends ProductProvider {
  _TestProductProvider() : super(ProductService());

  int loadProductsCallCount = 0;

  @override
  Future<void> loadProducts() async {
    loadProductsCallCount++;
  }
}

class _TestAuthProvider extends AuthProvider {
  _TestAuthProvider() : super(AuthService());

  UserModel? userAfterCheckAuth;
  int checkAuthCallCount = 0;

  @override
  UserModel? get currentUser => userAfterCheckAuth;

  @override
  Future<void> checkAuth() async {
    checkAuthCallCount++;
  }
}

class _TestCartProvider extends CartProvider {
  _TestCartProvider() : super(CartService());

  int loadCartCallCount = 0;
  String? loadedPhone;

  @override
  Future<void> loadCart(String phone) async {
    loadCartCallCount++;
    loadedPhone = phone;
  }
}

class _TestFavoritesProvider extends FavoritesProvider {
  _TestFavoritesProvider() : super(PrefsService());

  int loadFavoritesCallCount = 0;
  String? loadedPhone;

  @override
  Future<void> loadFavorites(String phone) async {
    loadFavoritesCallCount++;
    loadedPhone = phone;
  }
}

class _TestOrderProvider extends OrderProvider {
  _TestOrderProvider() : super(OrderService());

  int loadOrdersCallCount = 0;
  int? loadedUserId;

  @override
  Future<void> loadOrders(int userId) async {
    loadOrdersCallCount++;
    loadedUserId = userId;
  }
}

class _TestPrefsService implements PrefsService {
  bool onboardingDone = false;
  int setOnboardingDoneCallCount = 0;

  @override
  Future<List<int>> getFavorites(String phone) async => [];

  @override
  Future<bool> isDarkMode() async => false;

  @override
  Future<bool> isFavorite(String phone, int productId) async => false;

  @override
  Future<bool> isOnboardingDone() async {
    return onboardingDone;
  }

  @override
  Future<void> setOnboardingDone() async {
    setOnboardingDoneCallCount++;
    onboardingDone = true;
  }

  @override
  Future<void> setDarkMode(bool value) async {}

  @override
  Future<void> toggleFavorite(String phone, int productId) async {}
}

class _RouteRecorder extends NavigatorObserver {
  int replacementCount = 0;

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    replacementCount++;
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
