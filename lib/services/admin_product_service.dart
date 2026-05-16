import 'package:hive_flutter/hive_flutter.dart';

import '../models/admin_product_model.dart';
import '../models/enums/admin_image_preset.dart';
import '../models/enums/category.dart';
import 'database_service.dart';

class AdminProductService {
  static final AdminProductService _instance = AdminProductService._();
  factory AdminProductService() => _instance;
  AdminProductService._();

  Box<AdminProductModel> get _box =>
      Hive.box<AdminProductModel>(DatabaseService.adminProductsBoxName);

  List<AdminProductModel> getAllAdminProducts() {
    return _box.values.toList()..sort((a, b) => a.id.compareTo(b.id));
  }

  List<AdminProductModel> getActiveAdminProducts() {
    return getAllAdminProducts().where((product) => product.isActive).toList();
  }

  Future<AdminProductModel> addProduct({
    required String name,
    required String description,
    required int price,
    required Category category,
    required AdminImagePreset imagePreset,
  }) async {
    final product = AdminProductModel(
      id: _nextAdminProductId(),
      name: name,
      description: description,
      price: price,
      category: category,
      imagePreset: imagePreset,
    );
    await _box.put(product.id.toString(), product);
    return product;
  }

  Future<void> updateProduct(AdminProductModel product) async {
    await _box.put(product.id.toString(), product);
  }

  Future<void> setActive(int productId, bool isActive) async {
    final key = productId.toString();
    final product = _box.get(key);
    if (product == null) return;
    await _box.put(key, product.copyWith(isActive: isActive));
  }

  int _nextAdminProductId() {
    final candidate = -DateTime.now().microsecondsSinceEpoch;
    if (!_box.containsKey(candidate.toString())) {
      return candidate;
    }
    return candidate - _box.length - 1;
  }
}
