import 'package:hive/hive.dart';

part 'review_model.g.dart';

@HiveType(typeId: 3)
class ReviewModel {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final int userId;
  
  @HiveField(2)
  final int productId;
  
  @HiveField(3)
  final String orderId;
  
  @HiveField(4)
  final int stars; // 1-5
  
  @HiveField(5)
  final String comment;
  
  @HiveField(6)
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.orderId,
    required this.stars,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'orderId': orderId,
      'stars': stars,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      productId: json['productId'] as int,
      orderId: json['orderId'] as String,
      stars: json['stars'] as int,
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
