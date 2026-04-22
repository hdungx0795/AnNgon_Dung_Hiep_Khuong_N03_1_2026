import '../models/chi_tiet_don_hang.dart';
import '../models/danh_gia.dart';
import '../models/don_hang.dart';
import '../models/mon_an.dart';
import '../models/nguoi_dung.dart';

final List<NguoiDung> mockNguoiDungs = [
  const NguoiDung(
    id: '23010438',
    name: 'Nguyen Van Dung',
    phone: '0900000001',
    email: 'dung23010438@example.com',
    passwordHash: 'hash_23010438',
    avatarPath: 'assets/avatars/dung.png',
  ),
  const NguoiDung(
    id: '23010437',
    name: 'Luu Duc Hiep',
    phone: '0900000002',
    email: 'hiep23010437@example.com',
    passwordHash: 'hash_23010437',
    avatarPath: 'assets/avatars/hiep.png',
  ),
  const NguoiDung(
    id: '23010428',
    name: 'Nguyen Kim Khuong',
    phone: '0900000003',
    email: 'khuong23010428@example.com',
    passwordHash: 'hash_23010428',
    avatarPath: 'assets/avatars/khuong.png',
  ),
];

final List<MonAn> mockMonAns = [
  const MonAn(
    id: 1,
    name: 'Com ga xoi mo',
    category: 'Com',
    price: 45000,
    description: 'Com ga gion an kem dua chua va nuoc mam toi ot.',
    imagePath: 'assets/images/com_ga_xoi_mo.png',
    rating: 4.6,
  ),
  const MonAn(
    id: 2,
    name: 'Bun bo Hue',
    category: 'Bun',
    price: 50000,
    description: 'Nuoc dung dam vi, thit bo mem, cha cua.',
    imagePath: 'assets/images/bun_bo_hue.png',
    rating: 4.7,
  ),
  const MonAn(
    id: 3,
    name: 'Tra sua tran chau',
    category: 'Do uong',
    price: 30000,
    description: 'Tra sua beo, tran chau den dai gion.',
    imagePath: 'assets/images/tra_sua_tran_chau.png',
    rating: 4.5,
  ),
  const MonAn(
    id: 4,
    name: 'Pizza hai san',
    category: 'Fast food',
    price: 120000,
    description: 'De banh mong, topping hai san va pho mai.',
    imagePath: 'assets/images/pizza_hai_san.png',
    rating: 4.8,
  ),
];

final List<DonHang> mockDonHangs = [
  DonHang(
    orderId: '1001',
    userId: 23010438,
    totalAmount: 95000,
    deliveryAddress: 'Ha Noi',
    paymentMethod: 'COD',
    statusIndex: 2,
    note: 'Giao truoc 11h',
    createdAt: DateTime(2026, 4, 20, 10, 30),
  ),
  DonHang(
    orderId: '1002',
    userId: 23010437,
    totalAmount: 150000,
    deliveryAddress: 'Ha Noi',
    paymentMethod: 'Banking',
    statusIndex: 1,
    note: null,
    createdAt: DateTime(2026, 4, 21, 18, 15),
  ),
  DonHang(
    orderId: '1003',
    userId: 23010428,
    totalAmount: 30000,
    deliveryAddress: 'Ha Noi',
    paymentMethod: 'COD',
    statusIndex: 0,
    note: 'Khong hanh',
    createdAt: DateTime(2026, 4, 22, 9, 5),
  ),
];

final List<ChiTietDonHang> mockChiTietDonHangs = [
  const ChiTietDonHang(
    orderId: 1001,
    productId: 1,
    quantity: 1,
    unitPrice: 45000,
  ),
  const ChiTietDonHang(
    orderId: 1001,
    productId: 3,
    quantity: 1,
    unitPrice: 30000,
  ),
  const ChiTietDonHang(
    orderId: 1002,
    productId: 2,
    quantity: 1,
    unitPrice: 50000,
  ),
  const ChiTietDonHang(
    orderId: 1002,
    productId: 4,
    quantity: 1,
    unitPrice: 120000,
  ),
  const ChiTietDonHang(
    orderId: 1003,
    productId: 3,
    quantity: 1,
    unitPrice: 30000,
  ),
];

final List<DanhGia> mockDanhGias = [
  DanhGia(
    id: 1,
    userId: 23010438,
    productId: 1,
    orderId: '1001',
    stars: 5,
    comment: 'Mon ngon, dong goi sach se.',
    createdAt: DateTime(2026, 4, 20, 12, 0),
  ),
  DanhGia(
    id: 2,
    userId: 23010437,
    productId: 2,
    orderId: '1002',
    stars: 4,
    comment: 'Nuoc dung dam vi, se dat lai.',
    createdAt: DateTime(2026, 4, 21, 20, 10),
  ),
  DanhGia(
    id: 3,
    userId: 23010428,
    productId: 3,
    orderId: '1003',
    stars: 3,
    comment: 'Tam duoc, can giam do ngot.',
    createdAt: DateTime(2026, 4, 22, 10, 0),
  ),
];
