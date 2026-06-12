import 'package:flutter/foundation.dart';
import '../services/prefs_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final PrefsService _prefsService = PrefsService();
  
  Set<int> _favoriteIds = {};

  Set<int> get favoriteIds => _favoriteIds;

  bool isFavorite(int productId) => _favoriteIds.contains(productId);

  Future<void> loadFavorites(String phone) async {
    _favoriteIds = (await _prefsService.getFavorites(phone)).toSet();
    notifyListeners();
  }

  Future<void> toggleFavorite(String phone, int productId) async {
    await _prefsService.toggleFavorite(phone, productId);
    await loadFavorites(phone);
  }
}
