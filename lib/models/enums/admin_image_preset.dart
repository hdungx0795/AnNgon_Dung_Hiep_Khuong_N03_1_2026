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
  @HiveField(6)
  superBurger,
  @HiveField(7)
  noodle,
  @HiveField(8)
  ramen,
  @HiveField(9)
  coffee,
  @HiveField(10)
  soju,
  @HiveField(11)
  cake,
  @HiveField(12)
  cupcake,
  @HiveField(13)
  superCombo,
  @HiveField(14)
  chubbyCombo,
  @HiveField(15)
  matchaCombo,
}

const adminImagePresetChoices = [
  AdminImagePreset.superBurger,
  AdminImagePreset.noodle,
  AdminImagePreset.ramen,
  AdminImagePreset.coffee,
  AdminImagePreset.soju,
  AdminImagePreset.cake,
  AdminImagePreset.cupcake,
  AdminImagePreset.superCombo,
  AdminImagePreset.chubbyCombo,
  AdminImagePreset.matchaCombo,
];

extension AdminImagePresetExt on AdminImagePreset {
  String get label {
    switch (this) {
      case AdminImagePreset.burger:
        return 'Burger';
      case AdminImagePreset.pizza:
        return 'Pizza đặc biệt';
      case AdminImagePreset.drink:
        return 'Đồ uống';
      case AdminImagePreset.chicken:
        return 'Món gà';
      case AdminImagePreset.dessert:
        return 'Tráng miệng';
      case AdminImagePreset.combo:
        return 'Combo';
      case AdminImagePreset.superBurger:
        return 'Super Burger';
      case AdminImagePreset.noodle:
        return 'Mì xào';
      case AdminImagePreset.ramen:
        return 'Ramen';
      case AdminImagePreset.coffee:
        return 'Cà phê';
      case AdminImagePreset.soju:
        return 'Soju';
      case AdminImagePreset.cake:
        return 'Bánh kem';
      case AdminImagePreset.cupcake:
        return 'Cupcake';
      case AdminImagePreset.superCombo:
        return 'Super Combo';
      case AdminImagePreset.chubbyCombo:
        return 'Chubby Combo';
      case AdminImagePreset.matchaCombo:
        return 'Combo Matcha';
    }
  }

  String get assetPath {
    switch (this) {
      case AdminImagePreset.burger:
        return 'assets/images/admin_add_products/superBurger.jpg';
      case AdminImagePreset.pizza:
        return 'assets/images/admin_add_products/superCombo.jpg';
      case AdminImagePreset.drink:
        return 'assets/images/admin_add_products/coffe.jpg';
      case AdminImagePreset.chicken:
        return 'assets/images/admin_add_products/noodle.jpg';
      case AdminImagePreset.dessert:
        return 'assets/images/admin_add_products/cake.jpg';
      case AdminImagePreset.combo:
        return 'assets/images/admin_add_products/chubbyCombo.jpg';
      case AdminImagePreset.superBurger:
        return 'assets/images/admin_add_products/superBurger.jpg';
      case AdminImagePreset.noodle:
        return 'assets/images/admin_add_products/noodle.jpg';
      case AdminImagePreset.ramen:
        return 'assets/images/admin_add_products/ramen.jpg';
      case AdminImagePreset.coffee:
        return 'assets/images/admin_add_products/coffe.jpg';
      case AdminImagePreset.soju:
        return 'assets/images/admin_add_products/soju.jpg';
      case AdminImagePreset.cake:
        return 'assets/images/admin_add_products/cake.jpg';
      case AdminImagePreset.cupcake:
        return 'assets/images/admin_add_products/cupcake.jpg';
      case AdminImagePreset.superCombo:
        return 'assets/images/admin_add_products/superCombo.jpg';
      case AdminImagePreset.chubbyCombo:
        return 'assets/images/admin_add_products/chubbyCombo.jpg';
      case AdminImagePreset.matchaCombo:
        return 'assets/images/admin_add_products/comboMatchaLattePlus.jpg';
    }
  }
}
