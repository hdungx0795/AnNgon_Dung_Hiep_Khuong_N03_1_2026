import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:hive_flutter/hive_flutter.dart';

import '../models/admin_product_model.dart';
import '../models/enums/admin_image_preset.dart';
import '../models/enums/category.dart';
import 'database_service.dart';

class AdminProductService {
  static AdminProductService? _instance;
  factory AdminProductService({FirebaseFirestore? firestore}) {
    if (firestore != null) {
      return AdminProductService._(firestore);
    }
    _instance ??= AdminProductService._(null);
    return _instance!;
  }
  AdminProductService._(this._firestoreOverride);

  final FirebaseFirestore? _firestoreOverride;
  FirebaseFirestore get _fs => _firestoreOverride ?? FirebaseFirestore.instance;

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
    try {
      await _fs.collection('admin_products').doc(product.id.toString()).set(product.toJson());
    } catch (e) {
      debugPrint('Failed to save admin product to Firestore: $e');
    }
    return product;
  }

  Future<void> updateProduct(AdminProductModel product) async {
    await _box.put(product.id.toString(), product);
    try {
      await _fs.collection('admin_products').doc(product.id.toString()).set(product.toJson());
    } catch (e) {
      debugPrint('Failed to update admin product on Firestore: $e');
    }
  }

  Future<void> setActive(int productId, bool isActive) async {
    final key = productId.toString();
    final product = _box.get(key);
    if (product == null) return;
    
    final updatedProduct = product.copyWith(isActive: isActive);
    await _box.put(key, updatedProduct);
    
    try {
      await _fs.collection('admin_products').doc(key).set(updatedProduct.toJson());
    } catch (e) {
      debugPrint('Failed to set active status on Firestore: $e');
    }
  }

  int _nextAdminProductId() {
    final candidate = -DateTime.now().microsecondsSinceEpoch;
    if (!_box.containsKey(candidate.toString())) {
      return candidate;
    }
    return candidate - _box.length - 1;
  }

  Future<void> syncAdminProductsFromFirestore() async {
    try {
      final snapshot = await _fs.collection('admin_products').get();
      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          try {
            final adminProduct = AdminProductModel.fromJson(doc.data());
            await _cacheAdminProductIfChanged(adminProduct);
          } catch (e) {
            debugPrint('Failed to parse admin product ${doc.id}: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Firestore fetch failed: $e');
    }
  }

  Future<void> _cacheAdminProductIfChanged(AdminProductModel product) async {
    final existing = _box.get(product.id.toString());
    if (existing == null || !_isSameAdminProduct(existing, product)) {
      await _box.put(product.id.toString(), product);
    }
  }

  bool _isSameAdminProduct(AdminProductModel a, AdminProductModel b) {
    return a.id == b.id &&
        a.name == b.name &&
        a.description == b.description &&
        a.price == b.price &&
        a.category == b.category &&
        a.imagePreset == b.imagePreset &&
        a.isActive == b.isActive;
  }
}
