import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pka_food/core/utils/hash_utils.dart';
import 'package:pka_food/models/user_model.dart';
import 'package:pka_food/services/auth_service.dart';
import 'package:pka_food/services/database_service.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;
  late Box<UserModel> usersBox;
  late AuthService authService;

  setUp(() async {
    hiveDirectory = await setUpTestHive();
    usersBox = Hive.box<UserModel>(DatabaseService.usersBoxName);
    authService = AuthService();
  });

  tearDown(() async {
    await tearDownTestHive(hiveDirectory);
  });

  test('register stores new users with a safe phone key', () async {
    final success = await authService.register(
      name: 'New User',
      phone: '0912345678',
      email: 'new@example.com',
      dob: '2000-01-01',
      password: 'password123',
    );

    expect(success, isTrue);
    expect(usersBox.get('0912345678'), isNotNull);
    expect(usersBox.get('0912345678')?.phone, '0912345678');
  });

  test(
    'registered user login session update and password change work',
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
      expect(usersBox.get('0912345678')?.name, 'Updated User');

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
    'seeded integer-key user login update and password change still work',
    () async {
      final seededUser = UserModel(
        id: 1,
        name: 'Seed User',
        phone: '0900000001',
        email: 'seed@example.com',
        dob: '1999-01-01',
        passwordHash: HashUtils.hashPassword('seedpass'),
        createdAt: DateTime(2026, 5, 15),
      );
      await usersBox.put(seededUser.id, seededUser);

      expect(await authService.login('0900000001', 'seedpass'), isNotNull);

      expect(
        await authService.updateUser(seededUser.copyWith(name: 'Seed Updated')),
        isTrue,
      );
      expect(usersBox.get(1)?.name, 'Seed Updated');
      expect(usersBox.get('0900000001'), isNull);

      expect(
        await authService.changePassword(1, 'seedpass', 'seedpass2'),
        isTrue,
      );
      expect(await authService.login('0900000001', 'seedpass2'), isNotNull);
    },
  );
}
