import '../models/danh_gia.dart';
import 'in_memory_repository.dart';

class DanhGiaRepository extends InMemoryRepository<DanhGia, int> {
  DanhGiaRepository(super.initialItems);

  /// Lấy danh sách đánh giá cho một món ăn cụ thể
  List<DanhGia> getByProductId(int productId) {
    return getAll().where((danhGia) => danhGia.productId == productId).toList();
  }

  /// Tính điểm đánh giá sao trung bình của món ăn
  double getAverageStarsForProduct(int productId) {
    final reviews = getByProductId(productId);
    if (reviews.isEmpty) return 0.0;
    final totalStars = reviews.fold<int>(0, (sum, review) => sum + review.stars);
    return totalStars / reviews.length;
  }
}
