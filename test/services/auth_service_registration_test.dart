import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:pka_food/core/utils/hash_utils.dart';
import 'package:pka_food/models/user_model.dart';
import 'package:pka_food/services/auth_service.dart';
import 'package:pka_food/services/database_service.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;
  late Box<UserModel> usersBox;
  late AuthService authService;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() async {
    hiveDirectory = await setUpTestHive();
    usersBox = Hive.box<UserModel>(DatabaseService.usersBoxName);
    fakeFirestore = FakeFirebaseFirestore();
    authService = AuthService(firestore: fakeFirestore);
  });

  tearDown(() async {
    await tearDownTestHive(hiveDirectory);
  });

  test('register stores new users in Firestore with a safe phone key', () async {
    final success = await authService.register(
      name: 'New User',
      phone: '0912345678',
      email: 'new@example.com',
      dob: '2000-01-01',
      password: 'password123',
    );

    expect(success, isTrue);
    final doc = await fakeFirestore.collection('users').doc('0912345678').get();
    expect(doc.exists, isTrue);
    expect(doc.data()?['phone'], '0912345678');
    expect(usersBox.get('0912345678'), isNull); // Should not write to Hive
  });

  test('register blocks duplicate phone in Firestore', () async {
    await authService.register(
      name: 'User 1',
      phone: '0900000001',
      email: 'u1@example.com',
      dob: '2000-01-01',
      password: 'pass',
    );
    final success = await authService.register(
      name: 'User 2',
      phone: '0900000001',
      email: 'u2@example.com',
      dob: '2000-01-01',
      password: 'pass',
    );
    expect(success, isFalse);
  });

  test('register blocks duplicate phone in Hive seed', () async {
    final seededUser = UserModel(
      id: 1,
      name: 'Seed User',
      phone: '0999999999',
      email: 'seed@example.com',
      dob: '1999-01-01',
      passwordHash: HashUtils.hashPassword('seedpass'),
      createdAt: DateTime(2026, 5, 15),
    );
    await usersBox.put(seededUser.id, seededUser);

    final success = await authService.register(
      name: 'User 2',
      phone: '0999999999',
      email: 'u2@example.com',
      dob: '2000-01-01',
      password: 'pass',
    );
    expect(success, isFalse);
  });

  test(
    'registered user login session update and password change work (Firestore)',
    () async {
      await authService.register(
        name: 'New User',
        phone: '0912345678',
        email: 'new@example.com',
        dob: '2000-01-01',
        password: 'password123',
      );

      final loggedInUser = await authService.login('0912345678', 'password123');
      expect(loggedInUser, isNotNull);

      final restoredUser = await authService.getCurrentUser();
      expect(restoredUser?.phone, '0912345678');

      final updatedUser = restoredUser!.copyWith(name: 'Updated User');
      expect(await authService.updateUser(updatedUser), isTrue);
      
      final doc = await fakeFirestore.collection('users').doc('0912345678').get();
      expect(doc.data()?['name'], 'Updated User');

      expect(
        await authService.changePassword(
          updatedUser.id,
          'password123',
          'newPassword123',
        ),
        isTrue,
      );
      expect(await authService.login('0912345678', 'password123'), isNull);
      expect(
        await authService.login('0912345678', 'newPassword123'),
        isNotNull,
      );
    },
  );

  test(
    'seeded integer-key user login update and password change migrate to Firestore',
    () async {
      final seededUser = UserModel(
        id: 1,
        name: 'Seed User',
        phone: '0900000002',
        email: 'seed2@example.com',
        dob: '1999-01-01',
        passwordHash: HashUtils.hashPassword('seedpass'),
        createdAt: DateTime(2026, 5, 15),
      );
      await usersBox.put(seededUser.id, seededUser);

      // Fallback login works
      expect(await authService.login('0900000002', 'seedpass'), isNotNull);

      // Update user hot migrates to Firestore
      expect(
        await authService.updateUser(seededUser.copyWith(name: 'Seed Updated')),
        isTrue,
      );
      
      final doc = await fakeFirestore.collection('users').doc('0900000002').get();
      expect(doc.exists, isTrue);
      expect(doc.data()?['name'], 'Seed Updated');
      
      // Fallback change password works and migrates if it wasn't migrated
      expect(
        await authService.changePassword(1, 'seedpass', 'seedpass2'),
        isTrue,
      );
      expect(await authService.login('0900000002', 'seedpass2'), isNotNull);
    },
  );
  
  test('login does not fallback to Hive if Firestore phone exists but wrong pass', () async {
    // 1. Put user in Hive with 'oldpass'
    final hiveUser = UserModel(
      id: 1,
      name: 'User',
      phone: '0999888777',
      email: 'a@example.com',
      dob: '2000-01-01',
      passwordHash: HashUtils.hashPassword('oldpass'),
      createdAt: DateTime.now(),
    );
    await usersBox.put(hiveUser.id, hiveUser);
    
    // 2. Put user in Firestore with 'newpass'
    final firestoreUser = hiveUser.copyWith(passwordHash: HashUtils.hashPassword('newpass'));
    await fakeFirestore.collection('users').doc('0999888777').set(firestoreUser.toJson());
    
    // 3. Login with 'oldpass' should fail because Firestore has 'newpass'
    final loggedInUser = await authService.login('0999888777', 'oldpass');
    expect(loggedInUser, isNull);
  });
}
