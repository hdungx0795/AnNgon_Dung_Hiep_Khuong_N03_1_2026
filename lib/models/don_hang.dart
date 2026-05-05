class DonHang {
  final String orderId;
  final int userId;
  final double totalAmount;
  final String deliveryAddress;
  final String paymentMethod;
  final int statusIndex;
  final String? note;
  final DateTime createdAt;

  const DonHang({
    required this.orderId,
    required this.userId,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.statusIndex,
    this.note,
    required this.createdAt,
  });

  String getFormattedTotalAmount() {
    return '${totalAmount.toStringAsFixed(0)} VND';
  }

  String getStatusLabel() {
    switch (statusIndex) {
      case 0:
        return 'Cho xac nhan';
      case 1:
        return 'Dang giao';
      case 2:
        return 'Da giao';
      case 3:
        return 'Da huy';
      default:
        return 'Khong xac dinh';
    }
  }

  factory DonHang.fromJson(Map<String, dynamic> json) {
    return DonHang(
      orderId: json['orderId'] as String? ?? '',
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      deliveryAddress: json['deliveryAddress'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String? ?? '',
      statusIndex: (json['statusIndex'] as num?)?.toInt() ?? 0,
      note: json['note'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'totalAmount': totalAmount,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'statusIndex': statusIndex,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  DonHang copyWith({
    String? orderId,
    int? userId,
    double? totalAmount,
    String? deliveryAddress,
    String? paymentMethod,
    int? statusIndex,
    String? note,
    DateTime? createdAt,
  }) {
    return DonHang(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      statusIndex: statusIndex ?? this.statusIndex,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'DonHang(orderId: $orderId, userId: $userId, totalAmount: $totalAmount, statusIndex: $statusIndex, createdAt: $createdAt)';
  }
}
