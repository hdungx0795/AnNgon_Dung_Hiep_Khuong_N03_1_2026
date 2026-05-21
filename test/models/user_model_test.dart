import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/models/user_model.dart';

void main() {
  group('UserModel Serialization', () {
    test('toJson and fromJson round-trip matches original values', () {
      final user = UserModel(
        id: 123,
        name: 'Nguyen Van A',
        phone: '0987654321',
        email: 'vana@gmail.com',
        dob: '2000-01-01',
        passwordHash: 'somehashhere',
        avatarPath: 'assets/images/logo/logo.png',
        createdAt: DateTime(2026, 5, 21, 12, 0, 0),
      );

      final jsonMap = user.toJson();
      final roundTripUser = UserModel.fromJson(jsonMap);

      expect(roundTripUser.id, user.id);
      expect(roundTripUser.name, user.name);
      expect(roundTripUser.phone, user.phone);
      expect(roundTripUser.email, user.email);
      expect(roundTripUser.dob, user.dob);
      expect(roundTripUser.passwordHash, user.passwordHash);
      expect(roundTripUser.avatarPath, user.avatarPath);
      expect(roundTripUser.createdAt, user.createdAt);
    });

    test('fromJson handles null avatarPath correctly', () {
      final jsonMap = {
        'id': 456,
        'name': 'Tran Van B',
        'phone': '0123456789',
        'email': 'vanb@gmail.com',
        'dob': '1995-12-12',
        'passwordHash': 'anotherhash',
        'avatarPath': null,
        'createdAt': '2026-05-21T15:30:00.000',
      };

      final user = UserModel.fromJson(jsonMap);
      expect(user.avatarPath, isNull);
      expect(user.name, 'Tran Van B');
    });
  });
}
