import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pka_food/models/enums/admin_image_preset.dart';
import 'package:pka_food/models/enums/category.dart';
import 'package:pka_food/models/product_model.dart';
import 'package:pka_food/services/admin_product_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:pka_food/services/database_service.dart';
import 'package:pka_food/services/product_service.dart';
import 'package:pka_food/models/admin_product_model.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;
  late Box<ProductModel> productBox;

  late FakeFirebaseFirestore fakeFirestore;
  late AdminProductService adminService;
  late ProductService productService;

  setUp(() async {
    hiveDirectory = await setUpTestHive();
    productBox = Hive.box<ProductModel>(DatabaseService.productsBoxName);
    await productBox.put(1, testProduct(id: 1));
    fakeFirestore = FakeFirebaseFirestore();
    adminService = AdminProductService(firestore: fakeFirestore);
    productService = ProductService(firestore: fakeFirestore);
  });

  tearDown(() async {
    await tearDownTestHive(hiveDirectory);
  });

  test(
    'admin products are stored separately and merged as active catalog items',
    () async {

      final adminProduct = await adminService.addProduct(
        name: 'Admin Pizza',
        description: 'Demo admin product',
        price: 59000,
        category: Category.food,
        imagePreset: AdminImagePreset.pizza,
      );

      expect(productBox.length, 1);
      expect(adminProduct.id, isNegative);
      expect(productService.getSeedProducts().map((p) => p.name), [
        'Test Burger',
      ]);
      expect(
        (await productService.getAllProducts()).map((p) => p.name),
        containsAll(['Test Burger', 'Admin Pizza']),
      );
      
      // Verify firestore
      final doc = await fakeFirestore.collection('admin_products').doc(adminProduct.id.toString()).get();
      expect(doc.exists, isTrue);
      expect(doc.data()?['name'], 'Admin Pizza');
    },
  );

  test(
    'hiding admin products removes them from visible catalog without delete',
    () async {

      final adminProduct = await adminService.addProduct(
        name: 'Admin Drink',
        description: 'Demo admin product',
        price: 19000,
        category: Category.drink,
        imagePreset: AdminImagePreset.drink,
      );

      await adminService.setActive(adminProduct.id, false);

      expect(adminService.getAllAdminProducts(), hasLength(1));
      expect(adminService.getAllAdminProducts().single.isActive, isFalse);
      expect(
        (await productService.getAllProducts()).map((p) => p.name),
        isNot(contains('Admin Drink')),
      );

      // Verify firestore
      final doc = await fakeFirestore.collection('admin_products').doc(adminProduct.id.toString()).get();
      expect(doc.data()?['isActive'], isFalse);
    },
  );

  test('admin product image preset can be changed during update', () async {

    final adminProduct = await adminService.addProduct(
      name: 'Admin Burger',
      description: 'Demo admin product',
      price: 45000,
      category: Category.food,
      imagePreset: AdminImagePreset.burger,
    );

    await adminService.updateProduct(
      adminProduct.copyWith(imagePreset: AdminImagePreset.drink),
    );

    final updatedProduct = adminService.getAllAdminProducts().single;
    expect(updatedProduct.imagePreset, AdminImagePreset.drink);
    expect(
      updatedProduct.toProductModel().imagePath,
      AdminImagePreset.drink.assetPath,
    );
    
    // Verify firestore
    final doc = await fakeFirestore.collection('admin_products').doc(adminProduct.id.toString()).get();
    expect(doc.data()?['imagePreset'], AdminImagePreset.drink.name);
  });

  test('admin picker image choices use dedicated non-duplicated assets', () {
    final assetPaths = adminImagePresetChoices
        .map((preset) => preset.assetPath)
        .toList();

    expect(assetPaths.toSet(), hasLength(assetPaths.length));
    expect(
      assetPaths,
      everyElement(startsWith('assets/images/admin_add_products/')),
    );
  });

  test('syncAdminProductsFromFirestore caches cloud admin products to Hive', () async {
    final cloudProduct = AdminProductModel(
      id: -1,
      name: 'Cloud Pizza',
      description: 'Desc',
      price: 100,
      category: Category.food,
      imagePreset: AdminImagePreset.pizza,
    );
    await fakeFirestore.collection('admin_products').doc('-1').set(cloudProduct.toJson());
    
    await adminService.syncAdminProductsFromFirestore();
    
    final localProducts = adminService.getAllAdminProducts();
    expect(localProducts.length, 1);
    expect(localProducts.first.name, 'Cloud Pizza');
  });

  test('Firestore doc parse error does not fail entire sync', () async {
    final validProduct = AdminProductModel(
      id: -1,
      name: 'Cloud Pizza',
      description: 'Desc',
      price: 100,
      category: Category.food,
      imagePreset: AdminImagePreset.pizza,
    );
    await fakeFirestore.collection('admin_products').doc('-1').set(validProduct.toJson());
    await fakeFirestore.collection('admin_products').doc('-2').set({'invalid': 'data'});
    
    await adminService.syncAdminProductsFromFirestore();
    
    final localProducts = adminService.getAllAdminProducts();
    expect(localProducts.length, 1);
    expect(localProducts.first.name, 'Cloud Pizza');
  });
}
