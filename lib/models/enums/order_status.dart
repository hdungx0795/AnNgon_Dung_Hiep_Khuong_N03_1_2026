import 'package:hive/hive.dart';

part 'order_status.g.dart';

@HiveType(typeId: 7)
enum OrderStatus {
  @HiveField(0)
  created,      // Đơn hàng đã được tạo
  @HiveField(1)
  confirmed,    // Quán đã xác nhận
  @HiveField(2)
  preparing,    // Đang chuẩn bị
  @HiveField(3)
  delivering,   // Shipper đang giao
  @HiveField(4)
  delivered,    // Đã đến nơi
  @HiveField(5)
  completed,    // Đã nhận hàng
}

extension OrderStatusExt on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.created: return 'Đã đặt hàng';
      case OrderStatus.confirmed: return 'Đã xác nhận';
      case OrderStatus.preparing: return 'Đang chuẩn bị';
      case OrderStatus.delivering: return 'Đang giao hàng';
      case OrderStatus.delivered: return 'Đã giao tới';
      case OrderStatus.completed: return 'Hoàn thành';
    }
  }

  String get displayName => label;
}
