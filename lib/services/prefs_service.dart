import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_prefs_model.dart';
import 'database_service.dart';

class PrefsService {
  static final PrefsService _instance = PrefsService._();
  factory PrefsService() => _instance;
  PrefsService._();

  Box<UserPrefsModel> get _prefsBox => Hive.box<UserPrefsModel>(DatabaseService.userPrefsBoxName);

  UserPrefsModel _getPrefs(String phone) {
    return _prefsBox.get(phone) ?? UserPrefsModel();
  }

  Future<void> _savePrefs(String phone, UserPrefsModel prefs) async {
    await _prefsBox.put(phone, prefs);
  }

  Future<List<int>> getFavorites(String phone) async {
    return _getPrefs(phone).favoriteIds;
  }

  Future<void> toggleFavorite(String phone, int productId) async {
    final prefs = _getPrefs(phone);
    final favorites = Set<int>.from(prefs.favoriteIds);
    if (favorites.contains(productId)) {
      favorites.remove(productId);
    } else {
      favorites.add(productId);
    }
    await _savePrefs(phone, prefs.copyWith(favoriteIds: favorites.toList()));
  }

  Future<bool> isFavorite(String phone, int productId) async {
    return _getPrefs(phone).favoriteIds.contains(productId);
  }

  Future<bool> isDarkMode() async {
    // Global dark mode or per user? Plan says phone as key for userPrefs.
    // We'll use a special key 'global' or the current user's phone.
    final prefs = _prefsBox.get('global') ?? UserPrefsModel();
    return prefs.isDarkMode;
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = _prefsBox.get('global') ?? UserPrefsModel();
    await _prefsBox.put('global', prefs.copyWith(isDarkMode: value));
  }

  Future<bool> isOnboardingDone() async {
    final prefs = _prefsBox.get('global') ?? UserPrefsModel();
    return prefs.onboardingDone;
  }

  Future<void> setOnboardingDone() async {
    final prefs = _prefsBox.get('global') ?? UserPrefsModel();
    await _prefsBox.put('global', prefs.copyWith(onboardingDone: true));
  }
}
