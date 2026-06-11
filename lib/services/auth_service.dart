import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../core/utils/hash_utils.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseFirestore? _firestoreOverride;

  // Singleton instance for the normal app
  static AuthService? _instance;

  factory AuthService({FirebaseFirestore? firestore}) {
    if (firestore != null) {
      // For testing, always create a new instance to avoid state leakage
      return AuthService._(firestore);
    }
    _instance ??= AuthService._(null);
    return _instance!;
  }

  AuthService._(this._firestoreOverride);

  FirebaseFirestore get _firestore => _firestoreOverride ?? FirebaseFirestore.instance;

  Box<UserModel> get _userBox =>
      Hive.box<UserModel>(DatabaseService.usersBoxName);
  Box get _sessionBox => Hive.box(DatabaseService.sessionBoxName);

  CollectionReference<Map<String, dynamic>> get _usersCol =>
      _firestore.collection('users');

  Future<UserModel?> login(String phone, String password) async {
    try {
      // 1. Check Firestore first
      final docSnap = await _usersCol.doc(phone).get();
      if (docSnap.exists && docSnap.data() != null) {
        final user = UserModel.fromJson(docSnap.data()!);
        if (HashUtils.verifyPassword(password, user.passwordHash)) {
          await _sessionBox.put('current_user_phone', phone);
          return user;
        } else {
          return null; // Don't fallback if phone exists but pass is wrong
        }
      }

      // 2. Fallback to Hive
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
    try {
      // Check if phone exists in Firestore
      final docSnap = await _usersCol.doc(phone).get();
      if (docSnap.exists) {
        return false;
      }

      // Check if phone exists in Hive (seed users)
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

      // Save to Firestore ONLY
      await _usersCol.doc(phone).set(newUser.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    final phone = _sessionBox.get('current_user_phone');
    if (phone == null) return null;

    try {
      // 1. Check Firestore
      final docSnap = await _usersCol.doc(phone).get();
      if (docSnap.exists && docSnap.data() != null) {
        return UserModel.fromJson(docSnap.data()!);
      }

      // 2. Fallback to Hive
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
      // 1. Check Firestore
      final docSnap = await _usersCol.doc(updatedUser.phone).get();
      if (docSnap.exists) {
        await _usersCol.doc(updatedUser.phone).set(updatedUser.toJson());
        return true;
      }

      // 2. If not in Firestore, check Hive for migration
      final key = _findUserKey(updatedUser.id, updatedUser.phone);
      if (key != null) {
        // Hot migrate to Firestore
        await _usersCol.doc(updatedUser.phone).set(updatedUser.toJson());
        return true;
      }

      return false;
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
      // 1. Check Firestore by query
      final querySnap = await _usersCol.where('id', isEqualTo: userId).limit(1).get();
      if (querySnap.docs.isNotEmpty) {
        final doc = querySnap.docs.first;
        final user = UserModel.fromJson(doc.data());
        if (!HashUtils.verifyPassword(oldPassword, user.passwordHash)) {
          return false; // Found in Firestore but pass wrong, don't fallback
        }
        
        final updatedUser = user.copyWith(
          passwordHash: HashUtils.hashPassword(newPassword),
        );
        await doc.reference.set(updatedUser.toJson());
        return true;
      }

      // 2. Fallback to Hive
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
      
      // Hot migrate to Firestore
      await _usersCol.doc(updatedUser.phone).set(updatedUser.toJson());
      
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetPassword(String phone, String newPassword) async {
    try {
      // 1. Check Firestore
      final docSnap = await _usersCol.doc(phone).get();
      if (docSnap.exists && docSnap.data() != null) {
        final user = UserModel.fromJson(docSnap.data()!);
        final updatedUser = user.copyWith(
          passwordHash: HashUtils.hashPassword(newPassword),
        );
        await _usersCol.doc(phone).set(updatedUser.toJson());
        return true;
      }

      // 2. Fallback to Hive
      final userIndex = _userBox.values.toList().indexWhere(
        (u) => u.phone == phone,
      );
      if (userIndex != -1) {
        final user = _userBox.getAt(userIndex)!;
        final updatedUser = user.copyWith(
          passwordHash: HashUtils.hashPassword(newPassword),
        );
        // Hot migrate to Firestore
        await _usersCol.doc(phone).set(updatedUser.toJson());
        return true;
      }

      return false;
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
