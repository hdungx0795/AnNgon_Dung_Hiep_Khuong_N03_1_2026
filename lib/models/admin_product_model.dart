import 'package:hive/hive.dart';

import 'enums/admin_image_preset.dart';
import 'enums/category.dart';
import 'product_model.dart';

part 'admin_product_model.g.dart';

@HiveType(typeId: 12)
class AdminProductModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int price;

  @HiveField(4)
  final Category category;

  @HiveField(5)
  final AdminImagePreset imagePreset;

  @HiveField(6)
  final bool isActive;

  AdminProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imagePreset,
    this.isActive = true,
  });

  ProductModel toProductModel() {
    return ProductModel(
      id: id,
      name: name,
      category: category,
      price: price,
      rating: 4.6,
      imagePath: imagePreset.assetPath,
      description: description,
    );
  }

  AdminProductModel copyWith({
    String? name,
    String? description,
    int? price,
    Category? category,
    AdminImagePreset? imagePreset,
    bool? isActive,
  }) {
    return AdminProductModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imagePreset: imagePreset ?? this.imagePreset,
      isActive: isActive ?? this.isActive,
    );
  }
}
