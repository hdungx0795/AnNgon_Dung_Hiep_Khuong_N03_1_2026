import '../models/nguoi_dung.dart';
import 'in_memory_repository.dart';

class NguoiDungRepository extends InMemoryRepository<NguoiDung, String> {
  NguoiDungRepository(super.initialItems);

  /// Xác thực người dùng (đăng nhập)
  NguoiDung? authenticate(String email, String passwordHash) {
    try {
      return getAll().firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase() && user.passwordHash == passwordHash,
      );
    } catch (_) {
      return null;
    }
  }

  /// Lấy người dùng theo Email
  NguoiDung? getByEmail(String email) {
    try {
      return getAll().firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
