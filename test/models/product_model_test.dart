import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/models/enums/category.dart';
import 'package:pka_food/models/product_model.dart';

void main() {
  group('ProductModel Serialization', () {
    test('toJson and fromJson round-trip matches original values', () {
      final product = ProductModel(
        id: 10,
        name: 'Tra Sua Tran Chau',
        category: Category.drink,
        price: 35000,
        rating: 4.8,
        imagePath: 'assets/images/products/bubble_tea.png',
        description: 'Tra sua thom ngon beo ngay',
      );

      final jsonMap = product.toJson();
      final roundTripProduct = ProductModel.fromJson(jsonMap);

      expect(roundTripProduct.id, product.id);
      expect(roundTripProduct.name, product.name);
      expect(roundTripProduct.category, product.category);
      expect(roundTripProduct.price, product.price);
      expect(roundTripProduct.rating, product.rating);
      expect(roundTripProduct.imagePath, product.imagePath);
      expect(roundTripProduct.description, product.description);
    });
  });
}
