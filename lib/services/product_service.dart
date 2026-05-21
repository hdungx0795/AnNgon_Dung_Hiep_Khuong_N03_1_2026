import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product_model.dart';
import '../models/enums/category.dart';
import '../models/admin_product_model.dart';
import 'admin_product_service.dart';
import 'database_service.dart';

class ProductService {
  final FirebaseFirestore? _firestoreOverride;
  static ProductService? _instance;

  factory ProductService({FirebaseFirestore? firestore}) {
    if (firestore != null) {
      return ProductService._(firestore);
    }
    _instance ??= ProductService._(null);
    return _instance!;
  }

  ProductService._(this._firestoreOverride);

  FirebaseFirestore get _firestore => _firestoreOverride ?? FirebaseFirestore.instance;
  CollectionReference get _productsCol => _firestore.collection('products');

  Box<ProductModel> get _productBox =>
      Hive.box<ProductModel>(DatabaseService.productsBoxName);

  Box<AdminProductModel> get _adminProductBox =>
      Hive.box<AdminProductModel>(DatabaseService.adminProductsBoxName);

  Future<List<ProductModel>> getAllProducts() async {
    List<ProductModel> products = [];
    
    // 1. Fetch from Firestore
    try {
      final snapshot = await _productsCol.get();
      if (snapshot.docs.isNotEmpty) {
        products = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ProductModel.fromJson(data);
        }).toList();
      }
    } catch (e) {
      // Fallback if firestore fails
    }

    // 2. Fallback to Hive if Firestore is empty or failed
    if (products.isEmpty) {
      products = _productBox.values.toList();
    }

    // 3. Sync and merge active admin products
    try {
      await AdminProductService(firestore: _firestoreOverride).syncAdminProductsFromFirestore();
    } catch (e) {
      debugPrint('Failed to sync admin products: $e');
    }

    final adminProducts = _adminProductBox.values
        .where((product) => product.isActive)
        .map((product) => product.toProductModel())
        .toList();

    return [...products, ...adminProducts];
  }

  List<ProductModel> getSeedProducts() {
    return _productBox.values.toList();
  }

  List<ProductModel> _getLocalActiveAdminProducts() {
    return _adminProductBox.values
        .where((product) => product.isActive)
        .map((product) => product.toProductModel())
        .toList();
  }

  List<ProductModel> getProductsByCategory(Category category) {
    if (category == Category.all) {
      return [..._productBox.values, ..._getLocalActiveAdminProducts()];
    }
    return _productBox.values.where((p) => p.category == category).toList();
  }

  List<ProductModel> searchProducts(String query) {
    final lowerQuery = query.toLowerCase();
    return _productBox.values
        .where((p) => p.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  Future<ProductModel?> getProductById(int id) async {
    // 1. Check if it's an admin product first
    final adminProduct = _adminProductBox.get(id.toString());
    if (adminProduct != null) {
      if (!adminProduct.isActive) return null;
      return adminProduct.toProductModel();
    }

    // 2. Fetch from Firestore
    try {
      final docSnap = await _productsCol.doc(id.toString()).get();
      if (docSnap.exists && docSnap.data() != null) {
        return ProductModel.fromJson(docSnap.data() as Map<String, dynamic>);
      }
    } catch (e) {
      // Fallback
    }

    // 3. Fallback to Hive
    final seedProduct = _productBox.get(id);
    return seedProduct;
  }
}
