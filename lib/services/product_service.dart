import 'package:hive_flutter/hive_flutter.dart';
import '../models/product_model.dart';
import '../models/enums/category.dart';
import '../models/admin_product_model.dart';
import 'database_service.dart';

class ProductService {
  static final ProductService _instance = ProductService._();
  factory ProductService() => _instance;
  ProductService._();

  Box<ProductModel> get _productBox =>
      Hive.box<ProductModel>(DatabaseService.productsBoxName);

  Box<AdminProductModel> get _adminProductBox =>
      Hive.box<AdminProductModel>(DatabaseService.adminProductsBoxName);

  List<ProductModel> getAllProducts() {
    return [
      ..._productBox.values,
      ..._adminProductBox.values
          .where((product) => product.isActive)
          .map((product) => product.toProductModel()),
    ];
  }

  List<ProductModel> getSeedProducts() {
    return _productBox.values.toList();
  }

  List<ProductModel> getProductsByCategory(Category category) {
    if (category == Category.all) return getAllProducts();
    return _productBox.values.where((p) => p.category == category).toList();
  }

  List<ProductModel> searchProducts(String query) {
    final lowerQuery = query.toLowerCase();
    return _productBox.values
        .where((p) => p.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  Future<ProductModel?> getProductById(int id) async {
    final seedProduct = _productBox.get(id);
    if (seedProduct != null) return seedProduct;

    final adminProduct = _adminProductBox.get(id.toString());
    if (adminProduct == null || !adminProduct.isActive) return null;
    return adminProduct.toProductModel();
  }
}
