import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/core/theme/app_theme.dart';
import 'package:pka_food/models/enums/category.dart';
import 'package:pka_food/models/product_model.dart';
import 'package:pka_food/models/user_model.dart';
import 'package:pka_food/providers/auth_provider.dart';
import 'package:pka_food/providers/cart_provider.dart';
import 'package:pka_food/providers/favorites_provider.dart';
import 'package:pka_food/providers/order_provider.dart';
import 'package:pka_food/providers/product_provider.dart';
import 'package:pka_food/screens/home/home_screen.dart';
import 'package:pka_food/services/auth_service.dart';
import 'package:pka_food/services/cart_service.dart';
import 'package:pka_food/services/order_service.dart';
import 'package:pka_food/services/prefs_service.dart';
import 'package:pka_food/services/product_service.dart';
import 'package:provider/provider.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;
  late _TestAuthProvider authProvider;
  late _TestProductProvider productProvider;
  late _TestCartProvider cartProvider;
  late _TestFavoritesProvider favoritesProvider;
  late _TestOrderProvider orderProvider;

  setUpAll(() async {
    hiveDirectory = await setUpTestHive();
  });

  setUp(() {
    authProvider = _TestAuthProvider();
    productProvider = _TestProductProvider();
    cartProvider = _TestCartProvider();
    favoritesProvider = _TestFavoritesProvider();
    orderProvider = _TestOrderProvider();
  });

  tearDown(() {
    authProvider.dispose();
    productProvider.dispose();
    cartProvider.dispose();
    favoritesProvider.dispose();
    orderProvider.dispose();
  });

  tearDownAll(() async {
    await tearDownTestHive(hiveDirectory);
  });

  testWidgets('home shell renders initial explore tab', (tester) async {
    await _pumpHomeShell(
      tester,
      authProvider: authProvider,
      productProvider: productProvider,
      cartProvider: cartProvider,
      favoritesProvider: favoritesProvider,
      orderProvider: orderProvider,
    );

    expect(find.byKey(const Key('home-shell-app-bar')), findsOneWidget);
    expect(find.byKey(const Key('home-shell-navigation-bar')), findsOneWidget);
    expect(find.byKey(const Key('home-shell-indexed-stack')), findsOneWidget);
    expect(find.text('Khám phá'), findsOneWidget);
    expect(find.text('Bạn muốn ăn gì hôm nay?'), findsOneWidget);
  });

  testWidgets('home shell switches tabs in the approved order', (tester) async {
    await _pumpHomeShell(
      tester,
      authProvider: authProvider,
      productProvider: productProvider,
      cartProvider: cartProvider,
      favoritesProvider: favoritesProvider,
      orderProvider: orderProvider,
    );

    await tester.tap(find.text('Giỏ hàng'));
    await tester.pumpAndSettle();
    expect(find.text('Giỏ hàng'), findsWidgets);
    expect(find.text('Vui lòng đăng nhập'), findsOneWidget);

    await tester.tap(find.text('Đơn hàng'));
    await tester.pumpAndSettle();
    expect(find.text('Đơn hàng'), findsWidgets);
    expect(find.text('Đăng nhập để xem đơn hàng'), findsOneWidget);

    await tester.tap(find.text('Yêu thích'));
    await tester.pumpAndSettle();
    expect(find.text('Yêu thích'), findsWidgets);
    expect(find.text('Chưa có món yêu thích'), findsOneWidget);
  });

  testWidgets('profile affordance navigates to profile route', (tester) async {
    await _pumpHomeShell(
      tester,
      authProvider: authProvider,
      productProvider: productProvider,
      cartProvider: cartProvider,
      favoritesProvider: favoritesProvider,
      orderProvider: orderProvider,
    );

    await tester.tap(find.byTooltip('Hồ sơ'));
    await tester.pumpAndSettle();

    expect(find.text('Profile route'), findsOneWidget);
  });

  testWidgets('home shell keeps tab state with IndexedStack', (tester) async {
    await _pumpHomeShell(
      tester,
      authProvider: authProvider,
      productProvider: productProvider,
      cartProvider: cartProvider,
      favoritesProvider: favoritesProvider,
      orderProvider: orderProvider,
    );

    final indexedStack = tester.widget<IndexedStack>(
      find.byKey(const Key('home-shell-indexed-stack')),
    );
    expect(indexedStack.children.length, 4);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Tìm kiếm món ngon'),
      'burger',
    );
    await tester.tap(find.text('Giỏ hàng'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Trang chủ'));
    await tester.pumpAndSettle();

    expect(find.text('burger'), findsOneWidget);
  });

  testWidgets('home shell renders in dark theme', (tester) async {
    await _pumpHomeShell(
      tester,
      authProvider: authProvider,
      productProvider: productProvider,
      cartProvider: cartProvider,
      favoritesProvider: favoritesProvider,
      orderProvider: orderProvider,
      themeMode: ThemeMode.dark,
    );

    expect(find.byKey(const Key('home-shell-app-bar')), findsOneWidget);
    expect(find.byKey(const Key('home-shell-navigation-bar')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpHomeShell(
  WidgetTester tester, {
  required _TestAuthProvider authProvider,
  required _TestProductProvider productProvider,
  required _TestCartProvider cartProvider,
  required _TestFavoritesProvider favoritesProvider,
  required _TestOrderProvider orderProvider,
  ThemeMode themeMode = ThemeMode.light,
}) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<ProductProvider>.value(value: productProvider),
        ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
        ChangeNotifierProvider<FavoritesProvider>.value(
          value: favoritesProvider,
        ),
        ChangeNotifierProvider<OrderProvider>.value(value: orderProvider),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        routes: {
          '/profile': (_) => const Scaffold(body: Text('Profile route')),
          '/login': (_) => const Scaffold(body: Text('Login route')),
          '/home': (_) => const HomeScreen(),
          '/checkout': (_) => const Scaffold(body: Text('Checkout route')),
        },
        home: const HomeScreen(),
      ),
    ),
  );
}

class _TestAuthProvider extends AuthProvider {
  _TestAuthProvider() : super(AuthService());

  @override
  UserModel? get currentUser => null;
}

class _TestProductProvider extends ProductProvider {
  _TestProductProvider() : super(ProductService());

  Category _selectedCategory = Category.all;
  String searchQuery = '';

  @override
  List<ProductModel> get products => [];

  @override
  Category get selectedCategory => _selectedCategory;

  @override
  bool get isLoading => false;

  @override
  void setCategory(Category category) {
    _selectedCategory = category;
    notifyListeners();
  }

  @override
  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }
}

class _TestCartProvider extends CartProvider {
  _TestCartProvider() : super(CartService());
}

class _TestFavoritesProvider extends FavoritesProvider {
  _TestFavoritesProvider() : super(PrefsService());

  @override
  bool isFavorite(int productId) => false;
}

class _TestOrderProvider extends OrderProvider {
  _TestOrderProvider() : super(OrderService());

  @override
  bool get isLoading => false;
}
