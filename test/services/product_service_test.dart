import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:pka_food/models/enums/admin_image_preset.dart';
import 'package:pka_food/models/admin_product_model.dart';
import 'package:pka_food/models/enums/category.dart';
import 'package:pka_food/models/product_model.dart';
import 'package:pka_food/services/admin_product_service.dart';
import 'package:pka_food/services/database_service.dart';
import 'package:pka_food/services/product_service.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;
  late Box<ProductModel> productBox;
  late FakeFirebaseFirestore fakeFirestore;
  late ProductService productService;
  late AdminProductService adminProductService;

  setUp(() async {
    hiveDirectory = await setUpTestHive();
    productBox = Hive.box<ProductModel>(DatabaseService.productsBoxName);
    
    // Setup fallback seed product in Hive
    await productBox.put(1, testProduct(id: 1, name: 'Fallback Burger'));
    
    fakeFirestore = FakeFirebaseFirestore();
    productService = ProductService(firestore: fakeFirestore);
    adminProductService = AdminProductService(firestore: fakeFirestore);
  });

  tearDown(() async {
    await tearDownTestHive(hiveDirectory);
  });

  test('getAllProducts reads from Firestore if available', () async {
    // Put product in Firestore
    final firestoreProduct = testProduct(id: 10, name: 'Firestore Drink', category: Category.drink);
    await fakeFirestore.collection('products').doc('10').set(firestoreProduct.toJson());

    final products = await productService.getAllProducts();
    
    expect(products.length, 1);
    expect(products.first.name, 'Firestore Drink');
    expect(products.first.id, 10);
  });

  test('getAllProducts falls back to Hive if Firestore is empty', () async {
    // Firestore is empty initially
    final products = await productService.getAllProducts();
    
    expect(products.length, 1);
    expect(products.first.name, 'Fallback Burger');
  });

  test('getAllProducts merges local active admin products', () async {
    // Put product in Firestore
    final firestoreProduct = testProduct(id: 10, name: 'Firestore Drink');
    await fakeFirestore.collection('products').doc('10').set(firestoreProduct.toJson());

    // Create an active admin product
    await adminProductService.addProduct(
      name: 'Admin Combo',
      description: 'Test Combo',
      price: 100000,
      category: Category.combo,
      imagePreset: AdminImagePreset.combo,
    );

    // Create an inactive admin product
    final inactiveAdminProduct = await adminProductService.addProduct(
      name: 'Inactive Pizza',
      description: 'Test Pizza',
      price: 50000,
      category: Category.food,
      imagePreset: AdminImagePreset.pizza,
    );
    await adminProductService.setActive(inactiveAdminProduct.id, false);

    final products = await productService.getAllProducts();
    
    // Should contain 1 Firestore product + 1 Active admin product
    expect(products.length, 2);
    final names = products.map((e) => e.name).toList();
    expect(names, contains('Firestore Drink'));
    expect(names, contains('Admin Combo'));
    expect(names, isNot(contains('Inactive Pizza')));
    expect(names, isNot(contains('Fallback Burger'))); // Because Firestore was NOT empty, fallback is skipped
  });

  test('getProductsByCategory(Category.all) includes active admin products and excludes inactive ones', () async {
    // Put seed product in Hive
    await productBox.put(1, testProduct(id: 1, name: 'Seed Product'));

    // Create an active admin product
    await adminProductService.addProduct(
      name: 'Admin Combo',
      description: 'Test Combo',
      price: 100000,
      category: Category.combo,
      imagePreset: AdminImagePreset.combo,
    );

    // Create an inactive admin product
    final inactiveAdminProduct = await adminProductService.addProduct(
      name: 'Inactive Pizza',
      description: 'Test Pizza',
      price: 50000,
      category: Category.food,
      imagePreset: AdminImagePreset.pizza,
    );
    await adminProductService.setActive(inactiveAdminProduct.id, false);

    final products = productService.getProductsByCategory(Category.all);
    
    // Should contain 1 Seed product + 1 Active admin product
    expect(products.length, 2);
    final names = products.map((e) => e.name).toList();
    expect(names, contains('Seed Product'));
    expect(names, contains('Admin Combo'));
    expect(names, isNot(contains('Inactive Pizza')));
  });

  test('getAllProducts syncs admin products from Firestore', () async {
    // Put cloud admin product
    final cloudProduct = AdminProductModel(
      id: -10,
      name: 'Cloud Burger',
      description: 'Test',
      price: 15000,
      category: Category.food,
      imagePreset: AdminImagePreset.burger,
      isActive: true,
    );
    await fakeFirestore.collection('admin_products').doc('-10').set(cloudProduct.toJson());

    final products = await productService.getAllProducts();
    
    // Should sync and include it
    final names = products.map((e) => e.name).toList();
    expect(names, contains('Cloud Burger'));
  });

  test('getAllProducts does not include inactive cloud admin products', () async {
    // Put inactive cloud admin product
    final cloudProduct = AdminProductModel(
      id: -11,
      name: 'Hidden Cloud Pizza',
      description: 'Test',
      price: 25000,
      category: Category.food,
      imagePreset: AdminImagePreset.pizza,
      isActive: false,
    );
    await fakeFirestore.collection('admin_products').doc('-11').set(cloudProduct.toJson());

    final products = await productService.getAllProducts();
    
    // Should NOT include it
    final names = products.map((e) => e.name).toList();
    expect(names, isNot(contains('Hidden Cloud Pizza')));
    
    // Verify it was cached in Hive as inactive
    final cached = adminProductService.getAllAdminProducts().firstWhere((p) => p.id == -11);
    expect(cached.isActive, isFalse);
  });
}
