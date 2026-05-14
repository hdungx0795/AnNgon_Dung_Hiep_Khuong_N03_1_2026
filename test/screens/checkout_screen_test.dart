import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pka_food/models/cart_item_model.dart';
import 'package:pka_food/models/enums/category.dart';
import 'package:pka_food/models/enums/order_status.dart';
import 'package:pka_food/models/enums/payment_method.dart';
import 'package:pka_food/models/order_item_model.dart';
import 'package:pka_food/models/order_model.dart';
import 'package:pka_food/models/product_model.dart';
import 'package:pka_food/models/user_model.dart';
import 'package:pka_food/models/voucher_model.dart';
import 'package:pka_food/providers/auth_provider.dart';
import 'package:pka_food/providers/cart_provider.dart';
import 'package:pka_food/providers/order_provider.dart';
import 'package:pka_food/screens/checkout/checkout_screen.dart';
import 'package:pka_food/services/auth_service.dart';
import 'package:pka_food/services/cart_service.dart';
import 'package:pka_food/services/database_service.dart';
import 'package:pka_food/services/order_service.dart';
import 'package:pka_food/services/voucher_service.dart';
import 'package:provider/provider.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;
  late _TestCartProvider cartProvider;
  late _TestOrderProvider orderProvider;

  setUpAll(() async {
    hiveDirectory = await setUpTestHive();
  });

  setUp(() async {
    await Hive.box<VoucherModel>(DatabaseService.vouchersBoxName).clear();
    await _seedVouchers();
    cartProvider = _TestCartProvider()..setDefaultItems();
    orderProvider = _TestOrderProvider();
  });

  tearDownAll(() async {
    await tearDownTestHive(hiveDirectory);
  });

  testWidgets('CheckoutScreen shows address validation inline', (tester) async {
    await _pumpCheckout(tester, cartProvider, orderProvider);

    await _scrollTo(
      tester,
      find.byKey(const Key('checkout-place-order-button')),
    );
    await _pressPlaceOrder(tester);

    expect(find.text('Vui lòng nhập địa chỉ'), findsOneWidget);
    expect(orderProvider.placeOrderCallCount, 0);
  });

  testWidgets('CheckoutScreen applies a valid voucher', (tester) async {
    await _pumpCheckout(tester, cartProvider, orderProvider);

    await tester.enterText(
      find.byKey(const Key('checkout-voucher-field')),
      'SAVE10',
    );
    await tester.ensureVisible(
      find.byKey(const Key('checkout-apply-voucher-button')),
    );
    await tester.tap(find.byKey(const Key('checkout-apply-voucher-button')));
    await tester.pump();

    expect(find.byKey(const Key('checkout-applied-voucher')), findsOneWidget);
    expect(find.textContaining('Đã áp dụng SAVE10'), findsOneWidget);
    expect(_currencyText('50.000'), findsWidgets);
  });

  testWidgets('CheckoutScreen shows invalid voucher feedback', (tester) async {
    await _pumpCheckout(tester, cartProvider, orderProvider);

    await tester.enterText(
      find.byKey(const Key('checkout-voucher-field')),
      'MISSING',
    );
    await tester.ensureVisible(
      find.byKey(const Key('checkout-apply-voucher-button')),
    );
    await tester.tap(find.byKey(const Key('checkout-apply-voucher-button')));
    await tester.pump();

    expect(find.byKey(const Key('checkout-voucher-error')), findsOneWidget);
    expect(find.text('Mã không hợp lệ hoặc chưa đủ điều kiện'), findsOneWidget);
    expect(find.byKey(const Key('checkout-applied-voucher')), findsNothing);
  });

  testWidgets('CheckoutScreen selects e-wallet payment', (tester) async {
    await _pumpCheckout(tester, cartProvider, orderProvider);

    await tester.enterText(
      find.byKey(const Key('checkout-address-field')),
      'Phenikaa',
    );
    await _scrollTo(tester, find.byKey(const Key('checkout-payment-ewallet')));
    _selectEwallet();
    await _scrollTo(
      tester,
      find.byKey(const Key('checkout-place-order-button')),
    );
    await _pressPlaceOrder(tester);
    await tester.pumpAndSettle();

    expect(orderProvider.lastPaymentMethod, PaymentMethod.ewallet);
    expect(find.text('Ví điện tử'), findsWidgets);
  });

  testWidgets('CheckoutScreen renders order review totals', (tester) async {
    await _pumpCheckout(tester, cartProvider, orderProvider);

    await _scrollTo(tester, find.text('2x Test Burger'));
    expect(find.text('2x Test Burger'), findsOneWidget);
    expect(find.text('1x Test Drink'), findsOneWidget);
    expect(find.text('Tạm tính'), findsOneWidget);
    expect(find.byKey(const Key('checkout-final-total')), findsOneWidget);
    expect(_currencyText('60.000'), findsWidgets);
  });

  testWidgets('CheckoutScreen places order and opens confirmation sheet', (
    tester,
  ) async {
    await _pumpCheckout(tester, cartProvider, orderProvider);

    await tester.enterText(
      find.byKey(const Key('checkout-address-field')),
      'Phenikaa',
    );
    await _scrollTo(
      tester,
      find.byKey(const Key('checkout-place-order-button')),
    );
    await _pressPlaceOrder(tester);
    await tester.pumpAndSettle();

    expect(orderProvider.placeOrderCallCount, 1);
    expect(cartProvider.clearSelectedCallCount, 1);
    expect(find.byKey(const Key('checkout-success-title')), findsOneWidget);
    expect(find.text('Đặt hàng thành công'), findsOneWidget);

    await tester.tap(find.byKey(const Key('checkout-track-order-button')));
    await tester.pumpAndSettle();

    expect(find.text('Không tìm thấy đơn hàng'), findsOneWidget);
  });

  testWidgets('CheckoutScreen disables submit while placing order', (
    tester,
  ) async {
    final pendingOrder = Completer<OrderModel>();
    orderProvider.pendingOrder = pendingOrder;

    await _pumpCheckout(tester, cartProvider, orderProvider);

    await tester.enterText(
      find.byKey(const Key('checkout-address-field')),
      'Phenikaa',
    );
    await _scrollTo(
      tester,
      find.byKey(const Key('checkout-place-order-button')),
    );
    await _pressPlaceOrder(tester);

    expect(orderProvider.placeOrderCallCount, 1);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    expect(
      tester.widget<FilledButton>(find.byType(FilledButton).last).onPressed,
      isNull,
    );
    expect(orderProvider.placeOrderCallCount, 1);

    pendingOrder.complete(
      orderProvider.buildOrder(paymentMethod: PaymentMethod.cod),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('checkout-success-title')), findsOneWidget);
  });
}

Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump();
}

Future<void> _pumpCheckout(
  WidgetTester tester,
  _TestCartProvider cartProvider,
  _TestOrderProvider orderProvider,
) async {
  await tester.binding.setSurfaceSize(const Size(800, 1000));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(_checkoutTestApp(cartProvider, orderProvider));
}

Future<void> _seedVouchers() async {
  final vouchersBox = Hive.box<VoucherModel>(DatabaseService.vouchersBoxName);
  await vouchersBox.put(
    'SAVE10',
    VoucherModel(
      code: 'SAVE10',
      discountAmount: 10000,
      discountPercent: 0,
      minOrderAmount: 50000,
      expiresAt: DateTime(2030),
    ),
  );
  await vouchersBox.put(
    'BIG20',
    VoucherModel(
      code: 'BIG20',
      discountAmount: 0,
      discountPercent: 0.2,
      minOrderAmount: 100000,
      expiresAt: DateTime(2030),
    ),
  );
}

Widget _checkoutTestApp(
  _TestCartProvider cartProvider,
  _TestOrderProvider orderProvider,
) {
  return MultiProvider(
    providers: [
      Provider<VoucherService>.value(value: VoucherService()),
      ChangeNotifierProvider<AuthProvider>.value(
        value: _TestAuthProvider(user: _testUser),
      ),
      ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
      ChangeNotifierProvider<OrderProvider>.value(value: orderProvider),
    ],
    child: const MaterialApp(home: CheckoutScreen()),
  );
}

Finder _currencyText(String amount) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Text &&
        widget.data != null &&
        widget.data!.contains(amount) &&
        widget.data!.contains('đ'),
  );
}

Finder _placeOrderButton() {
  return find.widgetWithText(FilledButton, 'Xác nhận đặt hàng');
}

Future<void> _pressPlaceOrder(WidgetTester tester) async {
  tester.widget<FilledButton>(_placeOrderButton()).onPressed!();
  await tester.pump();
}

void _selectEwallet() {
  final inkWellFinder = find.ancestor(
    of: find.text('Ví điện tử'),
    matching: find.byType(InkWell),
  );
  final inkWell = inkWellFinder.evaluate().last.widget as InkWell;
  inkWell.onTap!();
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

ProductModel _product({
  int id = 1,
  String name = 'Test Burger',
  int price = 30000,
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
  int clearSelectedCallCount = 0;

  void setDefaultItems() {
    _testItems
      ..clear()
      ..addAll([
        CartItemModel(product: _product(), quantity: 2),
        CartItemModel(
          product: _product(id: 2, name: 'Test Drink', price: 0),
          quantity: 1,
        ),
      ]);
    notifyListeners();
  }

  @override
  List<CartItemModel> get items => List.unmodifiable(_testItems);

  @override
  int get totalAmount => _testItems
      .where((item) => item.isSelected)
      .fold(0, (sum, item) => sum + item.totalPrice);

  @override
  Future<void> clearSelected(String phone) async {
    clearSelectedCallCount++;
    _testItems.removeWhere((item) => item.isSelected);
    notifyListeners();
  }
}

class _TestOrderProvider extends OrderProvider {
  _TestOrderProvider() : super(OrderService());

  int placeOrderCallCount = 0;
  PaymentMethod? lastPaymentMethod;
  Completer<OrderModel>? pendingOrder;

  @override
  Future<OrderModel> placeOrder({
    required int userId,
    required List<CartItemModel> items,
    required PaymentMethod paymentMethod,
    required String address,
    required String note,
    VoucherModel? voucher,
  }) async {
    placeOrderCallCount++;
    lastPaymentMethod = paymentMethod;

    final pending = pendingOrder;
    if (pending != null) {
      return pending.future;
    }

    return buildOrder(
      paymentMethod: paymentMethod,
      voucher: voucher,
      address: address,
      note: note,
    );
  }

  OrderModel buildOrder({
    required PaymentMethod paymentMethod,
    VoucherModel? voucher,
    String address = 'Phenikaa',
    String note = '',
  }) {
    const total = 60000;
    final discount = voucher?.calculateDiscount(total) ?? 0;

    return OrderModel(
      orderId: 'order-123456',
      userId: _testUser.id,
      items: [
        OrderItemModel(
          productId: 1,
          productName: 'Test Burger',
          quantity: 2,
          unitPrice: 30000,
        ),
      ],
      totalAmount: total,
      paymentMethod: paymentMethod,
      deliveryAddress: address,
      note: note,
      status: OrderStatus.created,
      shipperName: 'Đang tìm shipper...',
      createdAt: DateTime(2026),
      voucherCode: voucher?.code,
      discount: discount,
    );
  }
}
