import 'dart:io';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pka_food/core/utils/hash_utils.dart';
import 'package:pka_food/models/enums/admin_image_preset.dart';
import 'package:pka_food/models/enums/category.dart';
import 'package:pka_food/models/enums/order_status.dart';
import 'package:pka_food/models/enums/payment_method.dart';
import 'package:pka_food/models/product_model.dart';
import 'package:pka_food/models/user_model.dart';
import 'package:pka_food/providers/auth_provider.dart';
import 'package:pka_food/providers/cart_provider.dart';
import 'package:pka_food/providers/order_provider.dart';
import 'package:pka_food/providers/product_provider.dart';
import 'package:pka_food/services/admin_auth_service.dart';
import 'package:pka_food/services/admin_order_read_service.dart';
import 'package:pka_food/services/admin_product_service.dart';
import 'package:pka_food/services/auth_service.dart';
import 'package:pka_food/services/cart_service.dart';
import 'package:pka_food/services/database_service.dart';
import 'package:pka_food/services/order_service.dart';
import 'package:pka_food/services/product_service.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;

  setUp(() async {
    hiveDirectory = await setUpTestHive();
  });

  tearDown(() async {
    OrderService().cancelAllDeliverySimulations();
    await tearDownTestHive(hiveDirectory);
  });

  group('TC8: Workflow Logic Tests (3-4 steps/actions)', () {
    test('1. Auth workflow: Onboarding/Login -> Submit -> Home', () async {
      // Setup
      final authService = AuthService(firestore: FakeFirebaseFirestore());
      final authProvider = AuthProvider(authService);
      
      final testUser = UserModel(
        id: 1, name: 'Workflow User', phone: '0901112222', email: 'test@example.com', dob: '2000-01-01',
        passwordHash: HashUtils.hashPassword('pass123'), createdAt: DateTime.now(),
      );
      final usersBox = Hive.box<UserModel>(DatabaseService.usersBoxName);
      await usersBox.put(testUser.id, testUser);

      // Step 1: Open Login Screen & Enter credentials
      // Step 2: Submit
      final success = await authProvider.login('0901112222', 'pass123');
      
      // Step 3: Transition to Home
      expect(success, isTrue);
      expect(authProvider.currentUser, isNotNull);
      expect(authProvider.currentUser!.phone, '0901112222');
    });

    test('2. Explore workflow: Explore -> Tap product -> Detail -> Add to cart', () async {
      // Setup
      final productsBox = Hive.box<ProductModel>(DatabaseService.productsBoxName);
      final product = testProduct(id: 1, name: 'Workflow Burger', price: 30000);
      await productsBox.put(product.id, product);

      final productProvider = ProductProvider(ProductService(firestore: FakeFirebaseFirestore()));
      final cartProvider = CartProvider(CartService());

      // Step 1: Explore screen loads products
      await productProvider.loadProducts();
      expect(productProvider.products.isNotEmpty, isTrue);

      // Step 2: Tap product -> Detail screen
      final selectedProduct = productProvider.products.firstWhere((p) => p.name == 'Workflow Burger');
      expect(selectedProduct.price, 30000);

      // Step 3: Action -> Add to cart
      await cartProvider.addItem('0900', selectedProduct, 1);
      
      // Step 4: Verify cart updated
      expect(cartProvider.itemCount, 1);
      expect(cartProvider.items.first.product.name, 'Workflow Burger');
    });

    test('3. Checkout workflow: Cart -> Checkout -> Submit -> Success state', () async {
      // Setup
      final cartProvider = CartProvider(CartService());
      await cartProvider.clearCart('0900'); // Ensure fresh state
      await cartProvider.addItem('0900', testProduct(id: 1, name: 'Test Food', price: 100), 2);
      final orderService = OrderService(firestore: FakeFirebaseFirestore());
      final orderProvider = OrderProvider(orderService);
      addTearDown(() => orderService.cancelAllDeliverySimulations());

      // Step 1: Cart screen -> Go to Checkout
      expect(cartProvider.items.length, 1);
      expect(cartProvider.totalAmount, 200);

      // Step 2: Checkout screen -> Fill details & Place order
      final order = await orderProvider.placeOrder(
        userId: 1,
        items: cartProvider.items,
        address: 'Phenikaa University',
        paymentMethod: PaymentMethod.cod,
        note: 'Giao nhanh',
      );

      // Step 3: Success state & Cart cleared
      expect(order, isNotNull);
      expect(order.totalAmount, 200);
      expect(order.deliveryAddress, 'Phenikaa University');

      await cartProvider.clearSelected('0900');
      expect(cartProvider.itemCount, 0); // Cart is cleared after checkout
    });

    test('4. Order workflow: Orders -> Tap active -> Tracking -> Complete', () async {
      // Setup
      final fakeFirestore = FakeFirebaseFirestore();
      final orderService = OrderService(firestore: fakeFirestore);
      final orderProvider = OrderProvider(orderService);
      addTearDown(() => orderService.cancelAllDeliverySimulations());
      
      // Inject mock order directly via OrderService to properly test the flow
      // without relying purely on a Hive box fallback hack.
      await orderService.createOrder(
        userId: 1,
        items: [],
        paymentMethod: PaymentMethod.cod,
        address: 'Home',
        note: '',
      );
      
      // Step 1: Load orders for user
      await orderProvider.loadOrders(1);
      
      // Step 2: Tap active order -> Open tracking
      final trackingOrder = orderProvider.activeOrders.first;
      expect(trackingOrder.status, OrderStatus.created);

      // Step 3: Action -> Complete order (Admin action mocked)
      await orderProvider.completeOrder(trackingOrder.orderId, 1);
      
      // Verify order moved to history
      expect(orderProvider.activeOrders.where((o) => o.orderId == trackingOrder.orderId).isEmpty, isTrue);
    });

    test('5. Admin product workflow: Dashboard -> Add product -> UI Updates', () async {
      // Setup
      final adminProductService = AdminProductService(firestore: FakeFirebaseFirestore());
      final adminAuthService = AdminAuthService();
      
      // Step 1: Admin Dashboard -> Authenticate
      final isValid = adminAuthService.validateCredentials('admin@anngon.local', 'admin123');
      expect(isValid, isTrue);

      // Step 2: Action -> Add new product
      final newProduct = await adminProductService.addProduct(
        name: 'New Admin Combo',
        description: 'Test combo',
        price: 50000,
        category: Category.combo,
        imagePreset: AdminImagePreset.combo,
      );

      // Step 3: UI Updates -> Product appears in admin list
      expect(newProduct.id, lessThan(0));
      
      final allAdminProducts = adminProductService.getAllAdminProducts();
      final addedProduct = allAdminProducts.firstWhere((p) => p.id == newProduct.id);
      
      expect(addedProduct.name, 'New Admin Combo');
      expect(addedProduct.isActive, isTrue);
    });

    test('6. Admin order workflow: Dashboard -> Orders -> List shown -> Status Update', () async {
      // Setup - Use shared FakeFirebaseFirestore to prove cross-service sync
      final sharedFirestore = FakeFirebaseFirestore();
      final adminOrderReadService = AdminOrderReadService(firestore: sharedFirestore);
      final orderService = OrderService(firestore: sharedFirestore);
      addTearDown(() => orderService.cancelAllDeliverySimulations());
      
      // Pre-condition: Create an order to ensure there is one
      await orderService.createOrder(
        userId: 2,
        items: [],
        paymentMethod: PaymentMethod.bankTransfer,
        address: 'Hanoi',
        note: '',
      );
      
      // Since createOrder generates a random ID, we need to sync and get it
      await adminOrderReadService.syncOrdersFromFirestore();

      // Step 1: Admin Dashboard -> View Orders tab
      final allOrders = adminOrderReadService.getAllOrders();
      expect(allOrders.isNotEmpty, isTrue);

      // Step 2: List shown
      final targetOrder = allOrders.firstWhere((o) => o.deliveryAddress == 'Hanoi');
      expect(targetOrder.deliveryAddress, 'Hanoi');
      expect(targetOrder.status, OrderStatus.created);

      // Step 3: Action -> Update status (e.g. to delivering)
      await orderService.updateOrderStatus(targetOrder.orderId, OrderStatus.delivering);

      // Verify update
      await adminOrderReadService.syncOrdersFromFirestore();
      final updatedOrders = adminOrderReadService.getAllOrders();
      final updatedTarget = updatedOrders.firstWhere((o) => o.orderId == targetOrder.orderId);
      expect(updatedTarget.status, OrderStatus.delivering);
    });
  });
}
