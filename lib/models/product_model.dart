import 'package:hive/hive.dart';
import 'enums/category.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
class ProductModel {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final Category category;
  
  @HiveField(3)
  final int price;
  
  @HiveField(4)
  final double rating;
  
  @HiveField(5)
  final String imagePath;
  
  @HiveField(6)
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      category: Category.values.firstWhere((c) => c.name == json['category']),
      price: json['price'],
      rating: (json['rating'] as num).toDouble(),
      imagePath: json['imagePath'],
      description: json['description'] ?? '',
    );
  }
}
