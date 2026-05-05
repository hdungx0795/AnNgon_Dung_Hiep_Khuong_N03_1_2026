class CartItem {
  final int productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  const CartItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  double getLineTotal() {
    return quantity * unitPrice;
  }

  String getFormattedLineTotal() {
    return '${getLineTotal().toStringAsFixed(0)} VND';
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: (json['productId'] as num?)?.toInt() ?? 0,
      productName: json['productName'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  CartItem copyWith({
    int? productId,
    String? productName,
    int? quantity,
    double? unitPrice,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  @override
  String toString() {
    return 'CartItem(productId: $productId, productName: $productName, quantity: $quantity, unitPrice: $unitPrice)';
  }
}
