import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pka_food/models/product_model.dart';
import 'package:pka_food/models/user_model.dart';
import 'package:pka_food/models/user_prefs_model.dart';
import 'package:pka_food/providers/auth_provider.dart';
import 'package:pka_food/providers/favorites_provider.dart';
import 'package:pka_food/providers/product_provider.dart';
import 'package:pka_food/screens/home/tabs/favorites_tab.dart';
import 'package:pka_food/services/auth_service.dart';
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
    await Hive.box(DatabaseService.sessionBoxName).clear();
    await Hive.box<UserPrefsModel>(DatabaseService.userPrefsBoxName).clear();
    await Hive.box<UserModel>(DatabaseService.usersBoxName).clear();
    await productsBox.put(1, testProduct(id: 1, name: 'Saved Burger'));
  });

  tearDownAll(() async {
    await tearDownTestHive(hiveDirectory);
  });

  testWidgets('FavoritesTab shows empty state when no favorites exist', (
    tester,
  ) async {
    final productProvider = ProductProvider(ProductService());
    await productProvider.loadProducts();
    final favoritesProvider = _TestFavoritesProvider();

    await tester.pumpWidget(
      _favoritesTestApp(
        authProvider: AuthProvider(AuthService()),
        productProvider: productProvider,
        favoritesProvider: favoritesProvider,
      ),
    );

    expect(find.text('Chưa có món yêu thích'), findsOneWidget);
  });

  testWidgets(
    'FavoritesTab renders favorites and responds to favorite removal',
    (tester) async {
      const phone = '0123456789';
      final authProvider = _TestAuthProvider(phone);

      final productProvider = ProductProvider(ProductService());
      await productProvider.loadProducts();
      final favoritesProvider = _TestFavoritesProvider(initialFavoriteIds: {1});

      await tester.pumpWidget(
        _favoritesTestApp(
          authProvider: authProvider,
          productProvider: productProvider,
          favoritesProvider: favoritesProvider,
        ),
      );

      expect(find.text('Saved Burger'), findsOneWidget);

      await tester.tap(find.byTooltip('Bỏ yêu thích'));
      await tester.pump();

      expect(find.text('Saved Burger'), findsNothing);
      expect(find.text('Chưa có món yêu thích'), findsOneWidget);
    },
  );
}

class _TestAuthProvider extends AuthProvider {
  _TestAuthProvider(String phone)
    : _user = UserModel(
        id: 1,
        name: 'Test User',
        phone: phone,
        email: 'test@example.com',
        dob: '',
        passwordHash: 'unused',
        createdAt: DateTime(2026, 1, 1),
      ),
      super(AuthService());

  final UserModel _user;

  @override
  UserModel? get currentUser => _user;
}

class _TestFavoritesProvider extends FavoritesProvider {
  _TestFavoritesProvider({Set<int> initialFavoriteIds = const {}})
    : _favoriteIds = Set<int>.from(initialFavoriteIds),
      super(PrefsService());

  Set<int> _favoriteIds;

  @override
  Set<int> get favoriteIds => _favoriteIds;

  @override
  bool isFavorite(int productId) => _favoriteIds.contains(productId);

  @override
  Future<void> toggleFavorite(String phone, int productId) async {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds = {..._favoriteIds}..remove(productId);
    } else {
      _favoriteIds = {..._favoriteIds, productId};
    }
    notifyListeners();
  }
}

Widget _favoritesTestApp({
  required AuthProvider authProvider,
  required ProductProvider productProvider,
  required FavoritesProvider favoritesProvider,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
      ChangeNotifierProvider<ProductProvider>.value(value: productProvider),
      ChangeNotifierProvider<FavoritesProvider>.value(value: favoritesProvider),
    ],
    child: const MaterialApp(home: Scaffold(body: FavoritesTab())),
  );
}
