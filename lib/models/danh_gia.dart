class DanhGia {
  final int id;
  final int userId;
  final int productId;
  final String orderId;
  final int stars;
  final String? comment;
  final DateTime createdAt;

  const DanhGia({
    required this.id,
    required this.userId,
    required this.productId,
    required this.orderId,
    required this.stars,
    this.comment,
    required this.createdAt,
  });

  String getDisplayComment() {
    final value = comment?.trim() ?? '';
    return value.isEmpty ? 'Khong co binh luan' : value;
  }

  bool isPositiveReview() {
    return stars >= 4;
  }

  factory DanhGia.fromJson(Map<String, dynamic> json) {
    return DanhGia(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      productId: (json['productId'] as num?)?.toInt() ?? 0,
      orderId: json['orderId'] as String? ?? '',
      stars: (json['stars'] as num?)?.toInt() ?? 0,
      comment: json['comment'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

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

  DanhGia copyWith({
    int? id,
    int? userId,
    int? productId,
    String? orderId,
    int? stars,
    String? comment,
    DateTime? createdAt,
  }) {
    return DanhGia(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      orderId: orderId ?? this.orderId,
      stars: stars ?? this.stars,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'DanhGia(id: $id, userId: $userId, productId: $productId, orderId: $orderId, stars: $stars, createdAt: $createdAt)';
  }
}
