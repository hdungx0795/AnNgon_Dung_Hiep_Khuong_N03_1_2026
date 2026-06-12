import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 4)
enum Category {
  @HiveField(0)
  all,
  @HiveField(1)
  food,
  @HiveField(2)
  drink,
  @HiveField(3)
  combo,
}

extension CategoryExt on Category {
  String get label {
    switch (this) {
      case Category.all: return 'Tất cả';
      case Category.food: return 'Đồ ăn';
      case Category.drink: return 'Đồ uống';
      case Category.combo: return 'Combo';
    }
  }
}
