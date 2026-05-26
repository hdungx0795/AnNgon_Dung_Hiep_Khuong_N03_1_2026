import '../models/mon_an.dart';
import 'in_memory_repository.dart';

class MonAnRepository extends InMemoryRepository<MonAn, int> {
  MonAnRepository(super.initialItems);

  /// Lọc danh sách món ăn theo danh mục (category)
  List<MonAn> getByCategory(String category) {
    return getAll().where((monAn) => monAn.category.toLowerCase() == category.toLowerCase()).toList();
  }

  /// Tìm kiếm món ăn theo tên hoặc mô tả
  List<MonAn> search(String query) {
    if (query.trim().isEmpty) return getAll();
    final lowerQuery = query.toLowerCase();
    return getAll().where((monAn) {
      return monAn.name.toLowerCase().contains(lowerQuery) ||
             monAn.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
