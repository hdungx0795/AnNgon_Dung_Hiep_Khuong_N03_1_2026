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
}
