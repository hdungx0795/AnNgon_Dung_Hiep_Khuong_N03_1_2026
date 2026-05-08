import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/enums/category.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider(this._productService);

  final ProductService _productService;

  List<ProductModel> _products = [];
  Category _selectedCategory = Category.all;
  String _searchQuery = '';
  bool _isLoading = false;

  List<ProductModel> get products {
    var filtered = _products;
    if (_selectedCategory != Category.all) {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return filtered;
  }

  Category get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    _products = _productService.getAllProducts();

    _isLoading = false;
    notifyListeners();
  }

  void setCategory(Category category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
