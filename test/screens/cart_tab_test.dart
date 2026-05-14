import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/models/cart_item_model.dart';
import 'package:pka_food/models/enums/category.dart';
import 'package:pka_food/models/product_model.dart';
import 'package:pka_food/models/user_model.dart';
import 'package:pka_food/providers/auth_provider.dart';
import 'package:pka_food/providers/cart_provider.dart';
import 'package:pka_food/screens/home/tabs/cart_tab.dart';
import 'package:pka_food/services/auth_service.dart';
import 'package:pka_food/services/cart_service.dart';
import 'package:provider/provider.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;
  late _TestCartProvider cartProvider;

  setUpAll(() async {
    hiveDirectory = await setUpTestHive();
  });

  setUp(() async {
    cartProvider = _TestCartProvider();
  });

  tearDownAll(() async {
    await tearDownTestHive(hiveDirectory);
  });

  testWidgets('CartTab renders empty cart state', (tester) async {
    await tester.pumpWidget(_cartTestApp(cartProvider));

    expect(find.text('Giỏ hàng trống'), findsOneWidget);
    expect(find.text('Chọn vài món ngon để bắt đầu đặt hàng.'), findsOneWidget);
    expect(find.text('Khám phá món ngon'), findsOneWidget);
  });

  testWidgets('CartTab renders selected total summary', (tester) async {
    await _seedCart(cartProvider);
    await cartProvider.toggleSelect(_testUser.phone, 2);

    await tester.pumpWidget(_cartTestApp(cartProvider));

    expect(find.text('1/2 món trong giỏ đã chọn'), findsOneWidget);
    expect(find.text('1 mục, 2 món đã chọn'), findsOneWidget);
    expect(_findCurrencyText('60.000'), findsWidgets);
    await _disposeWidgetTree(tester);
  });

  testWidgets('CartTab disables checkout when no items are selected', (
    tester,
  ) async {
    await _seedCart(cartProvider);
    await cartProvider.selectAll(_testUser.phone, false);

    await tester.pumpWidget(_cartTestApp(cartProvider));

    expect(find.text('Chọn món để thanh toán'), findsOneWidget);
    expect(
      find.text('Nút thanh toán sẽ bật khi có ít nhất 1 món được chọn.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('cart-checkout-button')));
    await tester.pumpAndSettle();

    expect(find.text('Checkout route'), findsNothing);
    await _disposeWidgetTree(tester);
  });

  testWidgets('CartTab toggles a cart item selection', (tester) async {
    await _seedCart(cartProvider);

    await tester.pumpWidget(_cartTestApp(cartProvider));
    expect(find.text('2/2 món trong giỏ đã chọn'), findsOneWidget);

    await tester.tap(find.byKey(const Key('cart-item-select-1')));
    await tester.pumpAndSettle();

    expect(find.text('1/2 món trong giỏ đã chọn'), findsOneWidget);
    expect(find.text('1 mục, 1 món đã chọn'), findsOneWidget);
    await _disposeWidgetTree(tester);
  });

  testWidgets('CartTab select all toggles every item', (tester) async {
    await _seedCart(cartProvider);

    await tester.pumpWidget(_cartTestApp(cartProvider));
    expect(find.text('2/2 món trong giỏ đã chọn'), findsOneWidget);

    await tester.tap(find.byKey(const Key('cart-select-all-checkbox')));
    await tester.pumpAndSettle();

    expect(find.text('0/2 món trong giỏ đã chọn'), findsOneWidget);
    expect(find.text('Chọn món để thanh toán'), findsOneWidget);

    await tester.tap(find.byKey(const Key('cart-select-all-checkbox')));
    await tester.pumpAndSettle();

    expect(find.text('2/2 món trong giỏ đã chọn'), findsOneWidget);
    await _disposeWidgetTree(tester);
  });

  testWidgets('CartTab quantity controls increase and decrease quantity', (
    tester,
  ) async {
    await _seedCart(cartProvider);

    await tester.pumpWidget(_cartTestApp(cartProvider));
    expect(find.byKey(const Key('cart-quantity-1')), findsOneWidget);
    expect(_quantityText('2'), findsOneWidget);

    await tester.tap(find.byKey(const Key('cart-increase-1')));
    await tester.pumpAndSettle();
    expect(_quantityText('3'), findsOneWidget);

    await tester.tap(find.byKey(const Key('cart-decrease-1')));
    await tester.pumpAndSettle();
    expect(_quantityText('2'), findsOneWidget);
    await _disposeWidgetTree(tester);
  });

  testWidgets('CartTab removes an item from the cart', (tester) async {
    await cartProvider.addItem(_testUser.phone, _cartProduct(), 1);

    await tester.pumpWidget(_cartTestApp(cartProvider));
    expect(find.text('Test Burger'), findsOneWidget);

    await tester.tap(find.byKey(const Key('cart-remove-1')));
    await tester.pumpAndSettle();

    expect(find.text('Test Burger'), findsNothing);
    expect(find.text('Giỏ hàng trống'), findsOneWidget);
    await _disposeWidgetTree(tester);
  });

  testWidgets('CartTab checkout button navigates when items are selected', (
    tester,
  ) async {
    await cartProvider.addItem(_testUser.phone, _cartProduct(), 1);

    await tester.pumpWidget(_cartTestApp(cartProvider));

    await tester.tap(find.byKey(const Key('cart-checkout-button')));
    await tester.pumpAndSettle();

    expect(find.text('Checkout route'), findsOneWidget);
    await _disposeWidgetTree(tester);
  });
}

Future<void> _seedCart(CartProvider provider) async {
  (provider as _TestCartProvider).setItems([
    CartItemModel(product: _cartProduct(price: 30000), quantity: 2),
    CartItemModel(
      product: _cartProduct(id: 2, name: 'Test Drink', price: 15000),
      quantity: 1,
    ),
  ]);
}

ProductModel _cartProduct({
  int id = 1,
  String name = 'Test Burger',
  int price = 25000,
}) {
  return ProductModel(
    id: id,
    name: name,
    category: Category.food,
    price: price,
    rating: 4.5,
    imagePath: '',
    description: 'Test product',
  );
}

Widget _cartTestApp(CartProvider cartProvider) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>.value(
        value: _TestAuthProvider(user: _testUser),
      ),
      ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
    ],
    child: MaterialApp(
      home: const Scaffold(body: CartTab()),
      routes: {
        '/home': (_) => const Scaffold(body: Text('Home route')),
        '/checkout': (_) => const Scaffold(body: Text('Checkout route')),
      },
    ),
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

Finder _quantityText(String value) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Text &&
        widget.key == const Key('cart-quantity-1') &&
        widget.data == value,
  );
}

Future<void> _disposeWidgetTree(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
}

final _testUser = UserModel(
  id: 1,
  name: 'Test User',
  phone: '0900000000',
  email: 'test@example.com',
  dob: '2000-01-01',
  passwordHash: 'hash',
  createdAt: DateTime(2026),
);

class _TestAuthProvider extends AuthProvider {
  _TestAuthProvider({required UserModel user})
    : _user = user,
      super(AuthService());

  final UserModel _user;

  @override
  UserModel? get currentUser => _user;
}

class _TestCartProvider extends CartProvider {
  _TestCartProvider() : super(CartService());

  final List<CartItemModel> _testItems = [];

  void setItems(List<CartItemModel> items) {
    _testItems
      ..clear()
      ..addAll(items);
    notifyListeners();
  }

  @override
  List<CartItemModel> get items => List.unmodifiable(_testItems);

  @override
  int get totalAmount => _testItems
      .where((item) => item.isSelected)
      .fold(0, (sum, item) => sum + item.totalPrice);

  @override
  int get itemCount => _testItems.length;

  @override
  bool get isAllSelected =>
      _testItems.isNotEmpty && _testItems.every((item) => item.isSelected);

  @override
  Future<void> loadCart(String phone) async {}

  @override
  Future<void> addItem(String phone, ProductModel product, int quantity) async {
    _testItems.add(CartItemModel(product: product, quantity: quantity));
    notifyListeners();
  }

  @override
  Future<void> updateQuantity(String phone, int productId, int quantity) async {
    final index = _testItems.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;

    if (quantity <= 0) {
      _testItems.removeAt(index);
    } else {
      _testItems[index].quantity = quantity;
    }
    notifyListeners();
  }

  @override
  Future<void> removeItem(String phone, int productId) async {
    _testItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  @override
  Future<void> toggleSelect(String phone, int productId) async {
    final index = _testItems.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;

    _testItems[index].isSelected = !_testItems[index].isSelected;
    notifyListeners();
  }

  @override
  Future<void> selectAll(String phone, bool value) async {
    for (final item in _testItems) {
      item.isSelected = value;
    }
    notifyListeners();
  }

  @override
  Future<void> clearCart(String phone) async {
    _testItems.clear();
    notifyListeners();
  }

  @override
  Future<void> clearSelected(String phone) async {
    _testItems.removeWhere((item) => item.isSelected);
    notifyListeners();
  }
}
