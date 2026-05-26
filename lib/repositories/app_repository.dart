import '../data/mock_data.dart';
import '../models/cart_item.dart';
import '../models/chi_tiet_don_hang.dart';
import '../models/don_hang.dart';
import '../models/mon_an.dart';
import 'mon_an_repository.dart';
import 'nguoi_dung_repository.dart';
import 'don_hang_repository.dart';
import 'danh_gia_repository.dart';

class AppRepository {
  // Tích hợp các sub-repositories được tổng quát hóa (Facade Pattern)
  final MonAnRepository monAnRepo = MonAnRepository(mockMonAns);
  final NguoiDungRepository nguoiDungRepo = NguoiDungRepository(mockNguoiDungs);
  final DonHangRepository donHangRepo = DonHangRepository(mockDonHangs);
  final DanhGiaRepository danhGiaRepo = DanhGiaRepository(mockDanhGias);

  // Những phần chuyên biệt hóa không tổng quát hóa được (Dependent entities & Local states)
  final List<ChiTietDonHang> _chiTietDonHangs = List<ChiTietDonHang>.from(mockChiTietDonHangs);
  final List<CartItem> _initialCartItems = List<CartItem>.from(mockCartItems);

  // Uỷ nhiệm các phương thức thông qua các repository chuyên biệt tương ứng
  List<MonAn> getMonAns() => monAnRepo.getAll();

  List<CartItem> getInitialCartItems() => List<CartItem>.unmodifiable(_initialCartItems);

  List<DonHang> getDonHangsByUser(int userId) {
    return donHangRepo.getByUserId(userId);
  }

  List<ChiTietDonHang> getChiTietByOrderId(String orderId) {
    final orderIdAsInt = int.tryParse(orderId);
    return _chiTietDonHangs
        .where((item) => item.orderId == orderIdAsInt)
        .toList();
  }

  DonHang createOrderFromCart({
    required int userId,
    required List<CartItem> cartItems,
  }) {
    final latestOrderId = donHangRepo.getAll()
        .map((e) => int.tryParse(e.orderId) ?? 0)
        .fold(0, (a, b) => a > b ? a : b);
    final newOrderIdInt = latestOrderId + 1;
    final newOrderId = '$newOrderIdInt';

    final totalAmount =
        cartItems.fold<double>(0, (sum, item) => sum + item.getLineTotal());

    final donHangMoi = DonHang(
      orderId: newOrderId,
      userId: userId,
      totalAmount: totalAmount,
      deliveryAddress: 'Ha Noi',
      paymentMethod: 'COD',
      statusIndex: 0,
      note: 'Tao tu gio hang',
      createdAt: DateTime.now(),
    );

    final chiTietMoi = cartItems
        .map(
          (item) => ChiTietDonHang(
            orderId: newOrderIdInt,
            productId: item.productId,
            quantity: item.quantity,
            unitPrice: item.unitPrice,
          ),
        )
        .toList();

    donHangRepo.add(donHangMoi);
    _chiTietDonHangs.addAll(chiTietMoi);

    return donHangMoi;
  }
}
