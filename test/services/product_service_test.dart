import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:pka_food/models/enums/admin_image_preset.dart';
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
    adminProductService = AdminProductService();
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
}
