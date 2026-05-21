import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:pka_food/models/product_model.dart';
import 'package:pka_food/models/user_model.dart';
import 'package:pka_food/models/voucher_model.dart';
import 'package:pka_food/services/database_service.dart';
import 'package:pka_food/services/seeding_service.dart';

import '../test_hive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory hiveDirectory;
  late FakeFirebaseFirestore fakeFirestore;
  late Box<ProductModel> productBox;
  late Box<UserModel> userBox;
  late Box<VoucherModel> voucherBox;

  setUp(() async {
    hiveDirectory = await setUpTestHive();
    productBox = Hive.box<ProductModel>(DatabaseService.productsBoxName);
    userBox = Hive.box<UserModel>(DatabaseService.usersBoxName);
    voucherBox = Hive.box<VoucherModel>(DatabaseService.vouchersBoxName);
    fakeFirestore = FakeFirebaseFirestore();
  });

  tearDown(() async {
    await tearDownTestHive(hiveDirectory);
  });

  test('seedAll populates local Hive boxes and Firestore products when empty', () async {
    expect(productBox.isEmpty, isTrue);
    expect(userBox.isEmpty, isTrue);
    expect(voucherBox.isEmpty, isTrue);

    await SeedingService.seedAll(firestore: fakeFirestore);

    // Verify Hive is seeded
    expect(productBox.isNotEmpty, isTrue);
    expect(userBox.isNotEmpty, isTrue);
    expect(voucherBox.isNotEmpty, isTrue);

    // Verify Firestore is seeded
    final snapshot = await fakeFirestore.collection('products').get();
    expect(snapshot.docs.isNotEmpty, isTrue);
    expect(snapshot.docs.length, productBox.length);
  });

  test('seedAll does not overwrite Firestore if it already has products', () async {
    // Add a dummy product to Firestore to simulate an existing database
    await fakeFirestore.collection('products').doc('999').set({
      'id': 999,
      'name': 'Existing Firestore Product',
      'price': 100,
      'category': 'drink',
      'imagePath': '',
      'description': '',
    });

    await SeedingService.seedAll(firestore: fakeFirestore);

    // Verify Hive is seeded
    expect(productBox.isNotEmpty, isTrue);

    // Verify Firestore was NOT overwritten (the count should be exactly 1)
    final snapshot = await fakeFirestore.collection('products').get();
    expect(snapshot.docs.length, 1);
    expect(snapshot.docs.first.id, '999');
  });

  test('seedAll seeds Firestore even if local Hive boxes are full', () async {
    // Pre-populate boxes to bypass Hive seeding
    await productBox.put(1, testProduct(id: 1));
    await userBox.put(1, UserModel(id: 1, phone: '1', name: 'A', email: 'e', dob: 'd', passwordHash: 'p', avatarPath: '', createdAt: DateTime.now()));
    await voucherBox.put('V1', VoucherModel(code: 'V1', discountAmount: 0, discountPercent: 0, minOrderAmount: 0, expiresAt: DateTime.now()));

    // Firestore is empty
    expect((await fakeFirestore.collection('products').get()).docs.isEmpty, isTrue);

    await SeedingService.seedAll(firestore: fakeFirestore);

    // Verify Firestore WAS touched and seeded because it was empty
    final snapshot = await fakeFirestore.collection('products').get();
    expect(snapshot.docs.isNotEmpty, isTrue);
    expect(snapshot.docs.length, greaterThan(1));
    
    // Verify Hive count did not increase from asset loading (was 1, still 1)
    expect(productBox.length, 1);
  });
}
