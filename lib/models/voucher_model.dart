import 'package:hive/hive.dart';

part 'voucher_model.g.dart';

@HiveType(typeId: 10)
class VoucherModel {
  @HiveField(0)
  final String code;
  
  @HiveField(1)
  final int discountAmount; // Fixed amount in VNĐ
  
  @HiveField(2)
  final double discountPercent; // Percent (e.g. 0.1 for 10%)
  
  @HiveField(3)
  final int minOrderAmount;
  
  @HiveField(4)
  final DateTime expiresAt;

  VoucherModel({
    required this.code,
    required this.discountAmount,
    required this.discountPercent,
    required this.minOrderAmount,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  int calculateDiscount(int orderTotal) {
    if (orderTotal < minOrderAmount || isExpired) return 0;
    
    int discount = discountAmount;
    if (discountPercent > 0) {
      discount += (orderTotal * discountPercent).round();
    }
    return discount;
  }
}
