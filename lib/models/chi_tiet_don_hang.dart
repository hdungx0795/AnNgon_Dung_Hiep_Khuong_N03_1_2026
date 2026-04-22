class ChiTietDonHang {
  final int orderId;
  final int productId;
  final int quantity;
  final double unitPrice;

  const ChiTietDonHang({
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
  });

  double getLineTotal() {
    return quantity * unitPrice;
  }

  String getFormattedLineTotal() {
    return '${getLineTotal().toStringAsFixed(0)} VND';
  }

  factory ChiTietDonHang.fromJson(Map<String, dynamic> json) {
    return ChiTietDonHang(
      orderId: (json['orderId'] as num?)?.toInt() ?? 0,
      productId: (json['productId'] as num?)?.toInt() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'productId': productId,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  ChiTietDonHang copyWith({
    int? orderId,
    int? productId,
    int? quantity,
    double? unitPrice,
  }) {
    return ChiTietDonHang(
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  @override
  String toString() {
    return 'ChiTietDonHang(orderId: $orderId, productId: $productId, quantity: $quantity, unitPrice: $unitPrice)';
  }
}
