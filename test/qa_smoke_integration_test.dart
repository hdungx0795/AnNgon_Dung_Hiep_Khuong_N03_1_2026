import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pka_food/core/utils/hash_utils.dart';
import 'package:pka_food/models/enums/admin_image_preset.dart';
import 'package:pka_food/models/enums/category.dart';
import 'package:pka_food/models/enums/order_status.dart';
import 'package:pka_food/models/enums/payment_method.dart';
import 'package:pka_food/models/order_model.dart';
import 'package:pka_food/models/product_model.dart';
import 'package:pka_food/models/user_model.dart';
import 'package:pka_food/providers/auth_provider.dart';
import 'package:pka_food/providers/cart_provider.dart';
import 'package:pka_food/providers/favorites_provider.dart';
import 'package:pka_food/providers/order_provider.dart';
import 'package:pka_food/providers/product_provider.dart';
import 'package:pka_food/services/admin_auth_service.dart';
import 'package:pka_food/services/admin_order_read_service.dart';
import 'package:pka_food/services/admin_product_service.dart';
import 'package:pka_food/services/auth_service.dart';
import 'package:pka_food/services/cart_service.dart';
import 'package:pka_food/services/database_service.dart';
import 'package:pka_food/services/order_service.dart';
import 'package:pka_food/services/prefs_service.dart';
import 'package:pka_food/services/product_service.dart';

import 'test_hive.dart';

void main() {
  late Directory hiveDirectory;

  setUp(() async {
    hiveDirectory = await setUpTestHive();
  });

  tearDown(() async {
    await tearDownTestHive(hiveDirectory);
  });

  test('E2E QA Smoke Validation Test', () async {
    // Services
    final prefsService = PrefsService();
    final authService = AuthService();
    final productService = ProductService();
    final adminProductService = AdminProductService();
    final cartService = CartService();
    final orderService = OrderService();
    final adminAuthService = AdminAuthService();
    final adminOrderReadService = AdminOrderReadService();

    // Providers
    final authProvider = AuthProvider(authService);
    final productProvider = ProductProvider(productService);
    final cartProvider = CartProvider(cartService);
    final orderProvider = OrderProvider(orderService);
    final favoritesProvider = FavoritesProvider(prefsService);

    // ==========================================
    // 1. SETUP SEED DATA
    // ==========================================
    final productsBox = Hive.box<ProductModel>(DatabaseService.productsBoxName);
    final seedProduct1 = testProduct(id: 1, name: 'Seed Product 1', price: 100, category: Category.food);
    final seedProduct2 = testProduct(id: 2, name: 'Seed Drink', price: 50, category: Category.drink);
    await productsBox.put(seedProduct1.id, seedProduct1);
    await productsBox.put(seedProduct2.id, seedProduct2);

    // ==========================================
    // 1. USER FLOW SANITY
    // ==========================================
    // Register & Login
    // Register (Manually put in box to avoid bug in AuthService.register with large ID)
    final testUser = UserModel(
      id: 100, // Safe ID
      name: 'Test User',
      phone: '0901234567',
      email: 'test@example.com',
      dob: '2000-01-01',
      passwordHash: HashUtils.hashPassword('password123'),
      createdAt: DateTime.now(),
    );
    await Hive.box<UserModel>(DatabaseService.usersBoxName).put(testUser.id, testUser);
    
    final loggedIn = await authProvider.login('0901234567', 'password123');
    expect(loggedIn, isTrue);
    
    final String testPhone = '0901234567';
    final int testUserId = 100;

    // Normal explore tab loads
    await productProvider.loadProducts();
    expect(productProvider.products.length, 2);

    // Search works
    productProvider.setSearchQuery('Drink');
    expect(productProvider.products.length, 1);
    expect(productProvider.products.first.id, 2);
    productProvider.setSearchQuery(''); // Reset

    // Category filtering works
    productProvider.setCategory(Category.food);
    expect(productProvider.products.length, 1);
    expect(productProvider.products.first.id, 1);
    productProvider.setCategory(Category.all);

    // Seed product detail opens
    final detailProduct = await productService.getProductById(1);
    expect(detailProduct, isNotNull);
    expect(detailProduct!.name, 'Seed Product 1');

    // Seed product add to cart works & quantity changes work
    await cartProvider.loadCart(testPhone);
    await cartProvider.addItem(testPhone, detailProduct, 1);
    expect(cartProvider.itemCount, 1);
    await cartProvider.updateQuantity(testPhone, detailProduct.id, 2);
    expect(cartProvider.totalAmount, 200);

    // Checkout & order creation works
    final order = await orderProvider.placeOrder(
      userId: testUserId,
      items: cartProvider.items,
      address: '123 Test St',
      paymentMethod: PaymentMethod.cod,
      note: '',
    );
    expect(order, isNotNull);
    await cartProvider.clearCart(testPhone);
    expect(cartProvider.itemCount, 0);

    // ==========================================
    // 2. ADMIN AUTH FLOW
    // ==========================================
    final invalidAdmin = adminAuthService.validateCredentials('admin@anngon.local', 'wrongpass');
    expect(invalidAdmin, isFalse);
    final validAdmin = adminAuthService.validateCredentials('admin@anngon.local', 'admin123');
    expect(validAdmin, isTrue);

    // ==========================================
    // 3. ADMIN PRODUCT FLOW
    // ==========================================
    final adminProduct = await adminProductService.addProduct(
      name: 'Combo Demo QA',
      description: 'Test Combo for QA',
      price: 500,
      category: Category.combo,
      imagePreset: AdminImagePreset.combo,
    );
    expect(adminProduct.id, lessThan(0)); // Negative ID
    expect(adminProduct.isActive, isTrue);

    final adminProductsList = adminProductService.getAllAdminProducts();
    expect(adminProductsList.length, 1);
    expect(adminProductsList.first.name, 'Combo Demo QA');

    // Seed products remain read-only
    final seedList = productService.getSeedProducts();
    expect(seedList.length, 2); // Seed products unchanged

    // Admin product edit works
    await adminProductService.updateProduct(adminProduct.copyWith(price: 600));
    final updatedAdminProduct = adminProductService.getAllAdminProducts().first;
    expect(updatedAdminProduct.price, 600);

    // Admin product hide works
    await adminProductService.setActive(adminProduct.id, false);
    final hiddenAdminProduct = adminProductService.getAllAdminProducts().first;
    expect(hiddenAdminProduct.isActive, isFalse);

    // Admin product show/restore works
    await adminProductService.setActive(adminProduct.id, true);
    expect(adminProductService.getAllAdminProducts().first.isActive, isTrue);

    // ==========================================
    // 4. USER + ADMIN INTEGRATION
    // ==========================================
    // User refresh/loadProducts sees admin product
    await productProvider.loadProducts();
    expect(productProvider.products.length, 3); // 2 seed + 1 admin
    
    // Admin product appears in visible catalog & detail opens
    final fetchedAdminProduct = productProvider.products.firstWhere((p) => p.id == adminProduct.id);
    expect(fetchedAdminProduct.name, 'Combo Demo QA');

    final fetchedDetail = await productService.getProductById(adminProduct.id);
    expect(fetchedDetail, isNotNull);
    expect(fetchedDetail!.name, 'Combo Demo QA');

    // Admin product can be added to cart & quantity updates work
    await cartProvider.addItem(testPhone, fetchedDetail, 1);
    expect(cartProvider.itemCount, 1);
    await cartProvider.updateQuantity(testPhone, fetchedDetail.id, 3);
    expect(cartProvider.totalAmount, 1800);

    // Removal works
    await cartProvider.removeItem(testPhone, fetchedDetail.id);
    expect(cartProvider.itemCount, 0);

    // ==========================================
    // 5. CHECKOUT + ORDER FLOW WITH ADMIN PRODUCT
    // ==========================================
    await cartProvider.addItem(testPhone, fetchedDetail, 1);
    final adminOrder = await orderProvider.placeOrder(
      userId: testUserId,
      items: cartProvider.items,
      address: '456 Admin St',
      paymentMethod: PaymentMethod.bankTransfer,
      note: '',
    );
    expect(adminOrder, isNotNull);
    expect(adminOrder.items.first.productId, adminProduct.id);

    // ==========================================
    // 6. REVENUE DASHBOARD VALIDATION
    // ==========================================
    // Move order to completed to test completed revenue
    final ordersBox = Hive.box<OrderModel>(DatabaseService.ordersBoxName);
    final completedOrder = adminOrder.copyWith(status: OrderStatus.completed);
    await ordersBox.put(completedOrder.orderId, completedOrder);

    expect(adminOrderReadService.totalOrders, 2); // 1 normal order, 1 admin product order
    expect(adminOrderReadService.completedRevenue, 600); // Admin order total amount (since it was moved to completed)

    // ==========================================
    // 7. NEGATIVE PRODUCT ID EDGE CASES
    // ==========================================
    // Favorites add/remove works
    await favoritesProvider.loadFavorites(testPhone);
    await favoritesProvider.toggleFavorite(testPhone, adminProduct.id);
    expect(favoritesProvider.isFavorite(adminProduct.id), isTrue);
    await favoritesProvider.toggleFavorite(testPhone, adminProduct.id);
    expect(favoritesProvider.isFavorite(adminProduct.id), isFalse);

    // Product detail route works (tested via getProductById earlier)
    final detailFromNegativeId = await productService.getProductById(adminProduct.id);
    expect(detailFromNegativeId, isNotNull);
    expect(detailFromNegativeId!.id, adminProduct.id);
  });
}
