import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/models/admin_product_model.dart';
import 'package:pka_food/models/enums/admin_image_preset.dart';
import 'package:pka_food/models/enums/category.dart';

void main() {
  group('AdminProductModel Serialization', () {
    test('toJson and fromJson round-trip matches original values', () {
      final adminProduct = AdminProductModel(
        id: 5,
        name: 'Com Suon',
        description: 'Com suon ram man',
        price: 30000,
        category: Category.food,
        imagePreset: AdminImagePreset.combo,
        isActive: true,
      );

      final jsonMap = adminProduct.toJson();
      final roundTripAdminProduct = AdminProductModel.fromJson(jsonMap);

      expect(roundTripAdminProduct.id, adminProduct.id);
      expect(roundTripAdminProduct.name, adminProduct.name);
      expect(roundTripAdminProduct.description, adminProduct.description);
      expect(roundTripAdminProduct.price, adminProduct.price);
      expect(roundTripAdminProduct.category, adminProduct.category);
      expect(roundTripAdminProduct.imagePreset, adminProduct.imagePreset);
      expect(roundTripAdminProduct.isActive, adminProduct.isActive);
    });
  });
}
