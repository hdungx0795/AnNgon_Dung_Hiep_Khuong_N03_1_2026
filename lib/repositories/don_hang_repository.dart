import '../models/don_hang.dart';
import 'in_memory_repository.dart';

class DonHangRepository extends InMemoryRepository<DonHang, String> {
  DonHangRepository(super.initialItems);

  /// Lấy danh sách đơn hàng của một người dùng cụ thể, sắp xếp từ mới nhất
  List<DonHang> getByUserId(int userId) {
    final results = getAll().where((donHang) => donHang.userId == userId).toList();
    results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return results;
  }
}
