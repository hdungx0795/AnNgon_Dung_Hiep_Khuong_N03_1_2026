import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pka_food/core/theme/app_theme.dart';
import 'package:pka_food/models/enums/category.dart';
import 'package:pka_food/models/product_model.dart';
import 'package:pka_food/providers/auth_provider.dart';
import 'package:pka_food/providers/cart_provider.dart';
import 'package:pka_food/providers/favorites_provider.dart';
import 'package:pka_food/providers/product_provider.dart';
import 'package:pka_food/screens/home/tabs/explore_tab.dart';
import 'package:pka_food/screens/product/product_detail_screen.dart';
import 'package:pka_food/services/auth_service.dart';
import 'package:pka_food/services/cart_service.dart';
import 'package:pka_food/services/database_service.dart';
import 'package:pka_food/services/prefs_service.dart';
import 'package:pka_food/services/product_service.dart';
import 'package:provider/provider.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = await setUpTestHive();
  });

  setUp(() async {
    final productsBox = Hive.box<ProductModel>(DatabaseService.productsBoxName);
    await productsBox.clear();
    await _seedProducts();
  });

  tearDownAll(() async {
    await tearDownTestHive(hiveDirectory);
  });

  testWidgets('ExploreTab renders search and seeded product grid', (
    tester,
  ) async {
    final provider = await _loadedProductProvider();

    await tester.pumpWidget(_exploreTestApp(provider));

    expect(find.byKey(const Key('explore-search-field')), findsOneWidget);
    expect(find.byKey(const Key('explore-product-grid')), findsOneWidget);
    expect(find.text('Test Burger'), findsOneWidget);
    expect(find.text('Test Drink'), findsOneWidget);
  });

  testWidgets('ExploreTab preserves provider search behavior', (tester) async {
    final provider = await _loadedProductProvider();

    await tester.pumpWidget(_exploreTestApp(provider));

    await tester.enterText(find.byType(TextFormField), 'Drink');
    await tester.pump();

    expect(provider.products.map((product) => product.name), ['Test Drink']);
    expect(find.text('Test Drink'), findsOneWidget);
    expect(find.text('Test Burger'), findsNothing);
  });

  testWidgets('ExploreTab preserves provider category behavior', (
    tester,
  ) async {
    final provider = await _loadedProductProvider();

    await tester.pumpWidget(_exploreTestApp(provider));

    await tester.tap(find.byKey(const Key('explore-category-drink')));
    await tester.pump();

    expect(provider.selectedCategory, Category.drink);
    expect(provider.products.map((product) => product.category), [
      Category.drink,
    ]);
    expect(find.text('Test Drink'), findsOneWidget);
    expect(find.text('Test Burger'), findsNothing);
  });

  testWidgets('ExploreTab promo CTA selects combo category', (tester) async {
    final provider = await _loadedProductProvider();

    await tester.pumpWidget(_exploreTestApp(provider));

    await tester.tap(find.text('Xem ngay'));
    await tester.pump();

    expect(provider.selectedCategory, Category.combo);
  });

  testWidgets('ExploreTab shows empty state for no search matches', (
    tester,
  ) async {
    final provider = await _loadedProductProvider();

    await tester.pumpWidget(_exploreTestApp(provider));

    await tester.enterText(find.byType(TextFormField), 'khong-co-mon');
    await tester.pump();

    expect(find.byKey(const Key('explore-no-results-state')), findsOneWidget);
    expect(find.text('Không tìm thấy món phù hợp'), findsOneWidget);
    expect(find.text('Test Burger'), findsNothing);
  });

  testWidgets('ExploreTab shows empty state when no products exist', (
    tester,
  ) async {
    final provider = ProductProvider(ProductService());

    await tester.pumpWidget(_exploreTestApp(provider));

    expect(find.byKey(const Key('explore-empty-state')), findsOneWidget);
    expect(find.text('Chưa có món nào'), findsOneWidget);
  });

  testWidgets('ExploreTab preserves product detail navigation', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final provider = await _loadedProductProvider();

    await tester.pumpWidget(_exploreTestApp(provider));

    await tester.tap(find.text('Test Burger'));
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailScreen), findsOneWidget);
    expect(find.text('Test Burger'), findsWidgets);
  });

  testWidgets('ExploreTab renders in dark mode', (tester) async {
    final provider = await _loadedProductProvider();

    await tester.pumpWidget(
      _exploreTestApp(provider, themeMode: ThemeMode.dark),
    );

    expect(find.byKey(const Key('explore-search-field')), findsOneWidget);
    expect(find.text('Test Burger'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ExploreTab remains stable on narrow layout', (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final provider = await _loadedProductProvider();

    await tester.pumpWidget(_exploreTestApp(provider));

    expect(find.byKey(const Key('explore-product-grid')), findsOneWidget);
    expect(find.text('Test Burger'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _seedProducts() async {
  final productsBox = Hive.box<ProductModel>(DatabaseService.productsBoxName);
  await productsBox.put(
    1,
    testProduct(id: 1, name: 'Test Burger', price: 30000),
  );
  await productsBox.put(
    2,
    testProduct(
      id: 2,
      name: 'Test Drink',
      price: 15000,
      category: Category.drink,
    ),
  );
}

Future<ProductProvider> _loadedProductProvider() async {
  final provider = ProductProvider(ProductService());
  await provider.loadProducts();
  return provider;
}

Widget _exploreTestApp(
  ProductProvider provider, {
  ThemeMode themeMode = ThemeMode.light,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<ProductProvider>.value(value: provider),
      ChangeNotifierProvider<AuthProvider>(
        create: (_) => AuthProvider(AuthService()),
      ),
      ChangeNotifierProvider<CartProvider>(
        create: (_) => CartProvider(CartService()),
      ),
      ChangeNotifierProvider<FavoritesProvider>(
        create: (_) => FavoritesProvider(PrefsService()),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const Scaffold(body: ExploreTab()),
    ),
  );
}
