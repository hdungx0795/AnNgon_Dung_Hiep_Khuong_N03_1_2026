import 'package:hive/hive.dart';

part 'payment_method.g.dart';

@HiveType(typeId: 5)
enum PaymentMethod {
  @HiveField(0)
  cod,      // Thanh toán khi nhận hàng
  @HiveField(1)
  ewallet,  // Ví điện tử
}

extension PaymentMethodExt on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.cod: return 'Thanh toán tiền mặt (COD)';
      case PaymentMethod.ewallet: return 'Ví điện tử';
    }
  }
}
