import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/models/enums/category.dart';
import 'package:pka_food/models/product_model.dart';
import 'package:pka_food/models/user_model.dart';
import 'package:pka_food/providers/auth_provider.dart';
import 'package:pka_food/providers/cart_provider.dart';
import 'package:pka_food/providers/favorites_provider.dart';
import 'package:pka_food/screens/product/product_detail_screen.dart';
import 'package:pka_food/services/auth_service.dart';
import 'package:pka_food/services/cart_service.dart';
import 'package:pka_food/services/prefs_service.dart';
import 'package:provider/provider.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = await setUpTestHive();
  });

  tearDownAll(() async {
    await tearDownTestHive(hiveDirectory);
  });

  testWidgets('ProductDetailScreen renders product details and initial total', (
    tester,
  ) async {
    final product = _detailProduct();

    await tester.pumpWidget(_productDetailTestApp(product: product));

    expect(find.text('Test Burger'), findsOneWidget);
    expect(find.text('A reliable test product'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(_findCurrencyText('25.000'), findsWidgets);
  });

  testWidgets('ProductDetailScreen renders image fallback for missing asset', (
    tester,
  ) async {
    final product = _detailProduct(
      imagePath: 'assets/images/products/missing.png',
    );

    await tester.pumpWidget(_productDetailTestApp(product: product));
    await tester.pump();

    expect(find.byKey(const Key('app-image-placeholder')), findsOneWidget);
  });

  testWidgets('quantity increment updates quantity and total price', (
    tester,
  ) async {
    final product = _detailProduct();

    await tester.pumpWidget(_productDetailTestApp(product: product));
    await _scrollQuantityIntoView(tester);

    await tester.tap(find.byTooltip('Tăng số lượng'));
    await tester.pump();

    expect(find.text('2'), findsOneWidget);
    expect(_findCurrencyText('50.000'), findsOneWidget);
  });

  testWidgets('quantity decrement is blocked at one and then decrements', (
    tester,
  ) async {
    final product = _detailProduct();

    await tester.pumpWidget(_productDetailTestApp(product: product));
    await _scrollQuantityIntoView(tester);

    await tester.tap(find.byTooltip('Giảm số lượng'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byTooltip('Tăng số lượng'));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.byTooltip('Giảm số lượng'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('unauthenticated add to cart shows guard snackbar', (
    tester,
  ) async {
    final product = _detailProduct();

    await tester.pumpWidget(_productDetailTestApp(product: product));

    await tester.tap(find.text('THÊM VÀO GIỎ'));
    await tester.pump();

    expect(find.text('Vui lòng đăng nhập để mua hàng'), findsOneWidget);
  });

  testWidgets('favorite button renders selected and unselected state', (
    tester,
  ) async {
    final product = _detailProduct();

    await tester.pumpWidget(
      _productDetailTestApp(
        product: product,
        favoritesProvider: _TestFavoritesProvider(),
      ),
    );
    expect(find.byTooltip('Thêm yêu thích'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    await tester.pumpWidget(
      _productDetailTestApp(
        product: product,
        favoritesProvider: _TestFavoritesProvider(initialFavoriteIds: {1}),
      ),
    );
    expect(find.byTooltip('Bỏ yêu thích'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}

ProductModel _detailProduct({
  String imagePath = 'assets/images/products/PKA.png',
}) {
  return ProductModel(
    id: 1,
    name: 'Test Burger',
    category: Category.food,
    price: 25000,
    rating: 4.5,
    imagePath: imagePath,
    description: 'A reliable test product',
  );
}

Finder _findCurrencyText(String amount) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Text &&
        widget.data != null &&
        widget.data!.contains(amount) &&
        widget.data!.contains('đ'),
  );
}

Future<void> _scrollQuantityIntoView(WidgetTester tester) async {
  await tester.drag(find.byType(CustomScrollView), const Offset(0, -180));
  await tester.pump();
}

Widget _productDetailTestApp({
  required ProductModel product,
  AuthProvider? authProvider,
  FavoritesProvider? favoritesProvider,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>.value(
        value: authProvider ?? _TestAuthProvider(),
      ),
      ChangeNotifierProvider<CartProvider>(
        create: (_) => CartProvider(CartService()),
      ),
      ChangeNotifierProvider<FavoritesProvider>.value(
        value: favoritesProvider ?? _TestFavoritesProvider(),
      ),
    ],
    child: MaterialApp(home: ProductDetailScreen(product: product)),
  );
}

class _TestAuthProvider extends AuthProvider {
  _TestAuthProvider({UserModel? user}) : _user = user, super(AuthService());

  final UserModel? _user;

  @override
  UserModel? get currentUser => _user;
}

class _TestFavoritesProvider extends FavoritesProvider {
  _TestFavoritesProvider({Set<int> initialFavoriteIds = const {}})
    : _favoriteIds = Set<int>.from(initialFavoriteIds),
      super(PrefsService());

  final Set<int> _favoriteIds;

  @override
  bool isFavorite(int productId) => _favoriteIds.contains(productId);

  @override
  Future<void> toggleFavorite(String phone, int productId) async {}
}
