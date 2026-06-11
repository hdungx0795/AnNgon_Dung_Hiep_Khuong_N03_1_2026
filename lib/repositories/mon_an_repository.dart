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

  /// Lấy danh sách món ăn nổi bật (đánh giá cao nhất)
  List<MonAn> getTopRated(int count) {
    final list = getAll().toList();
    list.sort((a, b) => b.rating.compareTo(a.rating));
    return list.take(count).toList();
  }

  /// Lọc món ăn theo khoảng giá
  List<MonAn> getMonAnTheoGia(double minPrice, double maxPrice) {
    return getAll().where((monAn) => monAn.price >= minPrice && monAn.price <= maxPrice).toList();
  }
}
