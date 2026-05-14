import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pka_food/models/enums/order_status.dart';
import 'package:pka_food/models/enums/payment_method.dart';
import 'package:pka_food/models/order_item_model.dart';
import 'package:pka_food/models/order_model.dart';
import 'package:pka_food/models/product_model.dart';
import 'package:pka_food/models/user_model.dart';
import 'package:pka_food/providers/auth_provider.dart';
import 'package:pka_food/providers/cart_provider.dart';
import 'package:pka_food/providers/order_provider.dart';
import 'package:pka_food/screens/home/tabs/orders_tab.dart';
import 'package:pka_food/screens/order/order_history_screen.dart';
import 'package:pka_food/services/auth_service.dart';
import 'package:pka_food/services/cart_service.dart';
import 'package:pka_food/services/database_service.dart';
import 'package:pka_food/services/order_service.dart';
import 'package:pka_food/services/product_service.dart';
import 'package:provider/provider.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;
  late _TestOrderProvider orderProvider;
  late _TestCartProvider cartProvider;

  setUpAll(() async {
    hiveDirectory = await setUpTestHive();
  });

  setUp(() async {
    await Hive.box<ProductModel>(DatabaseService.productsBoxName).clear();
    orderProvider = _TestOrderProvider();
    cartProvider = _TestCartProvider();
  });

  tearDown(() {
    orderProvider.dispose();
    cartProvider.dispose();
  });

  tearDownAll(() async {
    await tearDownTestHive(hiveDirectory);
  });

  testWidgets('OrdersTab shows login state for guests', (tester) async {
    await tester.pumpWidget(
      _ordersTestApp(
        authProvider: _TestAuthProvider(user: null),
        orderProvider: orderProvider,
        cartProvider: cartProvider,
        child: const Scaffold(body: OrdersTab()),
      ),
    );

    expect(find.text('Đăng nhập để xem đơn hàng'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
  });

  testWidgets('OrdersTab shows empty active order state', (tester) async {
    await tester.pumpWidget(
      _ordersTestApp(
        orderProvider: orderProvider,
        cartProvider: cartProvider,
        child: const Scaffold(body: OrdersTab()),
      ),
    );

    expect(find.text('Chưa có đơn đang xử lý'), findsOneWidget);
    expect(
      find.text('Khi đặt món, trạng thái giao hàng sẽ hiển thị tại đây.'),
      findsOneWidget,
    );
  });

  testWidgets('OrdersTab renders active orders with status and progress', (
    tester,
  ) async {
    orderProvider.setActiveOrders([
      _order(orderId: 'active-order-123', status: OrderStatus.delivering),
    ]);

    await tester.pumpWidget(
      _ordersTestApp(
        orderProvider: orderProvider,
        cartProvider: cartProvider,
        child: const Scaffold(body: OrdersTab()),
      ),
    );

    expect(find.text('Đơn đang xử lý'), findsOneWidget);
    expect(find.text('Đơn hàng #active-o'), findsOneWidget);
    expect(find.text('Đang giao hàng'), findsWidgets);
    expect(find.byKey(const Key('order-progress-delivering')), findsOneWidget);
    expect(find.text('2x Test Burger, 1x Test Drink'), findsOneWidget);
  });

  testWidgets('OrdersTab opens tracking when an active order is tapped', (
    tester,
  ) async {
    orderProvider.setActiveOrders([_order(orderId: 'active-track-123')]);

    await tester.pumpWidget(
      _ordersTestApp(
        orderProvider: orderProvider,
        cartProvider: cartProvider,
        child: const Scaffold(body: OrdersTab()),
      ),
    );

    await tester.tap(find.byKey(const Key('order-card-active-track-123')));
    await tester.pumpAndSettle();

    expect(find.text('Theo dõi đơn hàng'), findsOneWidget);
    expect(find.text('Trạng thái đơn hàng'), findsOneWidget);
  });

  testWidgets('OrderHistoryScreen renders completed order history', (
    tester,
  ) async {
    orderProvider.setHistory([
      _order(orderId: 'history-order-123', status: OrderStatus.completed),
    ]);

    await tester.pumpWidget(
      _ordersTestApp(
        orderProvider: orderProvider,
        cartProvider: cartProvider,
        child: const OrderHistoryScreen(),
      ),
    );

    expect(find.text('Lịch sử đơn hàng'), findsOneWidget);
    expect(find.text('Đơn đã hoàn tất'), findsOneWidget);
    expect(find.text('Đơn hàng #history-'), findsOneWidget);
    expect(find.text('Hoàn thành'), findsOneWidget);
    expect(find.text('Đặt lại'), findsOneWidget);
  });

  testWidgets('OrderHistoryScreen reorder trigger shows unavailable feedback', (
    tester,
  ) async {
    orderProvider.setHistory([_order(orderId: 'history-reorder-123')]);

    await tester.pumpWidget(
      _ordersTestApp(
        orderProvider: orderProvider,
        cartProvider: cartProvider,
        child: const OrderHistoryScreen(),
      ),
    );

    tester
        .widget<OutlinedButton>(find.widgetWithText(OutlinedButton, 'Đặt lại'))
        .onPressed!();
    await tester.pump();

    expect(cartProvider.addedProductIds, isEmpty);
    expect(
      find.text('Không thể thêm lại sản phẩm từ đơn này.'),
      findsOneWidget,
    );
    await _disposeWidgetTree(tester);
  });

  test(
    'reorderOrderItems reports partial product lookup availability',
    () async {
      final addedProductIds = <int>[];
      final addedQuantities = <int>[];

      final result = await reorderOrderItems(
        order: _order(orderId: 'history-partial-123'),
        findProduct: (productId) async =>
            productId == 1 ? testProduct(id: productId) : null,
        addToCart: (product, quantity) async {
          addedProductIds.add(product.id);
          addedQuantities.add(quantity);
        },
      );

      expect(result.addedCount, 1);
      expect(result.totalCount, 2);
      expect(
        result.feedbackMessage,
        'Đã thêm 1/2 sản phẩm còn bán vào giỏ hàng.',
      );
      expect(addedProductIds, [1]);
      expect(addedQuantities, [2]);
    },
  );
}

Widget _ordersTestApp({
  _TestAuthProvider? authProvider,
  required _TestOrderProvider orderProvider,
  required _TestCartProvider cartProvider,
  required Widget child,
}) {
  return MultiProvider(
    providers: [
      Provider<ProductService>.value(value: ProductService()),
      ChangeNotifierProvider<AuthProvider>.value(
        value: authProvider ?? _TestAuthProvider(user: _testUser),
      ),
      ChangeNotifierProvider<OrderProvider>.value(value: orderProvider),
      ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
    ],
    child: MaterialApp(
      home: child,
      routes: {
        '/login': (_) => const Scaffold(body: Text('Login route')),
        '/home': (_) => const Scaffold(body: Text('Home route')),
      },
    ),
  );
}

Future<void> _disposeWidgetTree(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
}

OrderModel _order({
  required String orderId,
  OrderStatus status = OrderStatus.created,
}) {
  return OrderModel(
    orderId: orderId,
    userId: _testUser.id,
    items: [
      OrderItemModel(
        productId: 1,
        productName: 'Test Burger',
        quantity: 2,
        unitPrice: 30000,
      ),
      OrderItemModel(
        productId: 2,
        productName: 'Test Drink',
        quantity: 1,
        unitPrice: 15000,
      ),
    ],
    totalAmount: 75000,
    paymentMethod: PaymentMethod.cod,
    deliveryAddress: 'Phenikaa University',
    note: '',
    status: status,
    shipperName: 'Test Shipper',
    createdAt: DateTime(2026, 5, 14),
  );
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
  _TestAuthProvider({required UserModel? user})
    : _user = user,
      super(AuthService());

  final UserModel? _user;

  @override
  UserModel? get currentUser => _user;
}

class _TestOrderProvider extends OrderProvider {
  _TestOrderProvider() : super(OrderService());

  final List<OrderModel> _activeOrders = [];
  final List<OrderModel> _history = [];
  bool _loading = false;

  void setActiveOrders(List<OrderModel> orders) {
    _activeOrders
      ..clear()
      ..addAll(orders);
    notifyListeners();
  }

  void setHistory(List<OrderModel> orders) {
    _history
      ..clear()
      ..addAll(orders);
    notifyListeners();
  }

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  @override
  List<OrderModel> get activeOrders => List.unmodifiable(_activeOrders);

  @override
  List<OrderModel> get orderHistory => List.unmodifiable(_history);

  @override
  bool get isLoading => _loading;

  @override
  Future<void> loadOrders(int userId) async {}
}

class _TestCartProvider extends CartProvider {
  _TestCartProvider() : super(CartService());

  final List<int> addedProductIds = [];
  final List<int> addedQuantities = [];

  @override
  Future<void> addItem(String phone, ProductModel product, int quantity) async {
    addedProductIds.add(product.id);
    addedQuantities.add(quantity);
    notifyListeners();
  }
}
