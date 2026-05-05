import '../data/mock_data.dart';
import '../models/cart_item.dart';
import '../models/chi_tiet_don_hang.dart';
import '../models/don_hang.dart';
import '../models/mon_an.dart';

class AppRepository {
  final List<MonAn> _monAns = List<MonAn>.from(mockMonAns);
  final List<DonHang> _donHangs = List<DonHang>.from(mockDonHangs);
  final List<ChiTietDonHang> _chiTietDonHangs =
      List<ChiTietDonHang>.from(mockChiTietDonHangs);
  final List<CartItem> _initialCartItems = List<CartItem>.from(mockCartItems);

  List<MonAn> getMonAns() => List<MonAn>.unmodifiable(_monAns);

  List<CartItem> getInitialCartItems() =>
      List<CartItem>.unmodifiable(_initialCartItems);

  List<DonHang> getDonHangsByUser(int userId) {
    final results = _donHangs.where((item) => item.userId == userId).toList();
    results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return results;
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
    final latestOrderId = _donHangs
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

    _donHangs.add(donHangMoi);
    _chiTietDonHangs.addAll(chiTietMoi);

    return donHangMoi;
  }
}

