class MonAn {
  final int id;
  final String name;
  final String category;
  final double price;
  final String description;
  final String imagePath;
  final double rating;

  const MonAn({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imagePath,
    required this.rating,
  });

  String getDisplayName() {
    return name.trim().isEmpty ? 'Mon an' : name;
  }

  String getFormattedPrice() {
    return '${price.toStringAsFixed(0)} VND';
  }

  factory MonAn.fromJson(Map<String, dynamic> json) {
    return MonAn(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: json['description'] as String? ?? '',
      imagePath: json['imagePath'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'imagePath': imagePath,
      'rating': rating,
    };
  }

  MonAn copyWith({
    int? id,
    String? name,
    String? category,
    double? price,
    String? description,
    String? imagePath,
    double? rating,
  }) {
    return MonAn(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      rating: rating ?? this.rating,
    );
  }

  @override
  String toString() {
    return 'MonAn(id: $id, name: $name, category: $category, price: $price, rating: $rating)';
  }
}
