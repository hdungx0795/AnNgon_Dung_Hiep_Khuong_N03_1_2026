import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._authService);

  final AuthService _authService;
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<void> checkAuth() async {
    _isLoading = true;
    notifyListeners();
    
    _currentUser = await _authService.getCurrentUser();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String phone, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final user = await _authService.login(phone, password);
    
    if (user != null) {
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Số điện thoại hoặc mật khẩu không đúng';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String phone,
    required String email,
    required String dob,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final success = await _authService.register(
      name: name,
      phone: phone,
      email: email,
      dob: dob,
      password: password,
    );

    if (success) {
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Số điện thoại đã được đăng ký';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> updateProfile({String? name, String? email, String? avatarPath}) async {
    if (_currentUser == null) return false;

    final updatedUser = _currentUser!.copyWith(
      name: name ?? _currentUser!.name,
      email: email ?? _currentUser!.email,
      avatarPath: avatarPath ?? _currentUser!.avatarPath,
    );

    final success = await _authService.updateUser(updatedUser);
    if (success) {
      _currentUser = updatedUser;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (_currentUser == null) return false;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    final success = await _authService.changePassword(_currentUser!.id, oldPassword, newPassword);
    
    _isLoading = false;
    if (success) {
      // Refresh _currentUser from Hive so in-memory state stays consistent
      _currentUser = await _authService.getCurrentUser();
    } else {
      _error = 'Mật khẩu cũ không chính xác';
    }
    notifyListeners();
    return success;
  }

  Future<bool> resetPassword(String phone, String newPassword) async {
    return await _authService.resetPassword(phone, newPassword);
  }
}
