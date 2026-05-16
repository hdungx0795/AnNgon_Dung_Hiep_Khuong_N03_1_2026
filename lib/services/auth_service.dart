import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../core/utils/hash_utils.dart';
import 'database_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;
  AuthService._();

  Box<UserModel> get _userBox =>
      Hive.box<UserModel>(DatabaseService.usersBoxName);
  Box get _sessionBox => Hive.box(DatabaseService.sessionBoxName);

  Future<UserModel?> login(String phone, String password) async {
    try {
      final user = _userBox.values.firstWhere(
        (u) =>
            u.phone == phone &&
            HashUtils.verifyPassword(password, u.passwordHash),
      );

      await _sessionBox.put('current_user_phone', phone);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<bool> register({
    required String name,
    required String phone,
    required String email,
    required String dob,
    required String password,
  }) async {
    if (_userBox.values.any((u) => u.phone == phone)) {
      return false;
    }

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      phone: phone,
      email: email,
      dob: dob,
      passwordHash: HashUtils.hashPassword(password),
      createdAt: DateTime.now(),
    );

    await _userBox.put(newUser.phone, newUser);
    return true;
  }

  Future<UserModel?> getCurrentUser() async {
    final phone = _sessionBox.get('current_user_phone');
    if (phone == null) return null;

    try {
      return _userBox.values.firstWhere((u) => u.phone == phone);
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await _sessionBox.delete('current_user_phone');
  }

  Future<bool> updateUser(UserModel updatedUser) async {
    try {
      final key = _findUserKey(updatedUser.id, updatedUser.phone);
      await _userBox.put(key ?? updatedUser.phone, updatedUser);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePassword(
    int userId,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final key = _findUserKey(userId);
      if (key == null) return false;

      final user = _userBox.get(key);
      if (user == null) return false;

      if (!HashUtils.verifyPassword(oldPassword, user.passwordHash)) {
        return false;
      }

      final updatedUser = user.copyWith(
        passwordHash: HashUtils.hashPassword(newPassword),
      );
      await _userBox.put(key, updatedUser);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetPassword(String phone, String newPassword) async {
    try {
      final userIndex = _userBox.values.toList().indexWhere(
        (u) => u.phone == phone,
      );
      if (userIndex == -1) return false;

      final user = _userBox.getAt(userIndex)!;
      final updatedUser = user.copyWith(
        passwordHash: HashUtils.hashPassword(newPassword),
      );
      await _userBox.putAt(userIndex, updatedUser);
      return true;
    } catch (e) {
      return false;
    }
  }

  dynamic _findUserKey(int userId, [String? phone]) {
    final directUser = _userBox.get(userId);
    if (directUser != null) return userId;

    for (final key in _userBox.keys) {
      final user = _userBox.get(key);
      if (user == null) continue;
      if (user.id == userId || (phone != null && user.phone == phone)) {
        return key;
      }
    }

    return null;
  }
}
