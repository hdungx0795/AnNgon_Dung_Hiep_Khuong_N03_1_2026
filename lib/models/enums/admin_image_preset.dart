import 'package:hive/hive.dart';

part 'admin_image_preset.g.dart';

@HiveType(typeId: 13)
enum AdminImagePreset {
  @HiveField(0)
  burger,
  @HiveField(1)
  pizza,
  @HiveField(2)
  drink,
  @HiveField(3)
  chicken,
  @HiveField(4)
  dessert,
  @HiveField(5)
  combo,
}

extension AdminImagePresetExt on AdminImagePreset {
  String get label {
    switch (this) {
      case AdminImagePreset.burger:
        return 'Burger';
      case AdminImagePreset.pizza:
        return 'Pizza';
      case AdminImagePreset.drink:
        return 'Đồ uống';
      case AdminImagePreset.chicken:
        return 'Gà rán';
      case AdminImagePreset.dessert:
        return 'Tráng miệng';
      case AdminImagePreset.combo:
        return 'Combo';
    }
  }

  String get assetPath {
    switch (this) {
      case AdminImagePreset.burger:
        return 'assets/images/products/hamburger.jpg';
      case AdminImagePreset.pizza:
        return 'assets/images/products/pizzaXucXich.jpg';
      case AdminImagePreset.drink:
        return 'assets/images/products/CocaCola.jpg';
      case AdminImagePreset.chicken:
        return 'assets/images/products/gaRan.jpg';
      case AdminImagePreset.dessert:
        return 'assets/images/products/MatchaLatte.jpg';
      case AdminImagePreset.combo:
        return 'assets/images/products/comboBurgerCoca.jpg';
    }
  }
}
