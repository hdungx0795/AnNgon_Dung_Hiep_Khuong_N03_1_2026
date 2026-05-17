import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

  setUp(() async {
    hiveDirectory = await setUpTestHive();
    productBox = Hive.box<ProductModel>(DatabaseService.productsBoxName);
    await productBox.put(1, testProduct(id: 1));
  });

  tearDown(() async {
    await tearDownTestHive(hiveDirectory);
  });

  test(
    'admin products are stored separately and merged as active catalog items',
    () async {
      final adminService = AdminProductService();
      final productService = ProductService();

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
        productService.getAllProducts().map((p) => p.name),
        containsAll(['Test Burger', 'Admin Pizza']),
      );
    },
  );

  test(
    'hiding admin products removes them from visible catalog without delete',
    () async {
      final adminService = AdminProductService();
      final productService = ProductService();

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
        productService.getAllProducts().map((p) => p.name),
        isNot(contains('Admin Drink')),
      );
    },
  );

  test('admin product image preset can be changed during update', () async {
    final adminService = AdminProductService();

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
}
