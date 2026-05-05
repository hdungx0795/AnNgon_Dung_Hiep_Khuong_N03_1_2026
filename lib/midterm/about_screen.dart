import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const Color _nenTrang = Color(0xFFF7F7F7);
  static const Color _mauChu = Color(0xFF2D2D2D);
  static const Color _mauPhu = Color(0xFF666666);
  static const Color _mauVien = Color(0xFFD9D9D9);
  static const Color _mauNenNhat = Color(0xFFF0F0F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _nenTrang,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _taoPhanDau(),
            const SizedBox(height: 80),

            // Tieu de chinh
            const Text(
              'Về Ứng Dụng AnNgon',
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: _mauChu,
              ),
            ),
            const SizedBox(height: 16),

            // Tieu de phu
            const Text(
              'Thiết kế và phát triển bởi Hiệp.\nKhám phá các món ăn ngon mỗi ngày hoặc gửi phản hồi cho chúng tôi.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, color: _mauPhu),
            ),
            const SizedBox(height: 40),

            _taoFormLienHe(),
            const SizedBox(height: 100),
            _taoChanTrang(),
          ],
        ),
      ),
    );
  }

  // Thanh dieu huong (Navbar)
  Widget _taoPhanDau() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _mauVien)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: const [
                  Icon(Icons.restaurant_menu, size: 32, color: _mauChu),
                  SizedBox(width: 8),
                  Text(
                    'AnNgon',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _mauChu,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Cac lien ket dieu huong
          Row(
            children: [
              _taoLienKet('Trang Chủ'),
              _taoLienKet('Thực Đơn'),
              _taoLienKet('Khuyến Mãi'),
              _taoLienKet('Cửa Hàng'),
              _taoLienKet('Liên Hệ'),
            ],
          ),

          // Nut dang nhap va dang ky
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _mauNenNhat,
                  foregroundColor: _mauChu,
                  elevation: 0,
                  side: const BorderSide(color: _mauVien),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Đăng nhập'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _mauChu,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Đăng ký'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _taoLienKet(String tenLienKet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            tenLienKet,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: _mauChu,
            ),
          ),
        ),
      ),
    );
  }

  // The Form chua cac o nhap lieu
  Widget _taoFormLienHe() {
    return Container(
      width: 450, // Do rong co dinh cua form
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: _mauVien, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _taoTruongNhapLieu(tieuDe: 'Họ đệm (Surname)'),
          const SizedBox(height: 20),
          _taoTruongNhapLieu(tieuDe: 'Tên (Name)'),
          const SizedBox(height: 20),
          _taoTruongNhapLieu(tieuDe: 'Email'),
          const SizedBox(height: 20),
          _taoTruongNhapLieu(tieuDe: 'Lời nhắn (Message)', soDong: 4),
          const SizedBox(height: 32),

          // Nut Submit
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _mauChu,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Gửi Phản Hồi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Component tai su dung cho cac o nhap Text
  Widget _taoTruongNhapLieu({required String tieuDe, int soDong = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tieuDe,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: _mauChu,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: soDong,
          decoration: InputDecoration(
            hintText: 'Value',
            hintStyle: const TextStyle(color: Color(0xFFB3B3B3)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _mauVien),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _mauVien),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _mauChu),
            ),
          ),
        ),
      ],
    );
  }

  // Chan trang (Footer)
  Widget _taoChanTrang() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _mauVien)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Cot chua Logo va Mang xa hoi
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.all_inclusive, size: 36, color: _mauChu),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: const [
                  _FooterIconButton(icon: Icons.close),
                  SizedBox(width: 12),
                  _FooterIconButton(icon: Icons.camera_alt_outlined),
                  SizedBox(width: 12),
                  _FooterIconButton(icon: Icons.play_circle_outline),
                  SizedBox(width: 12),
                  _FooterIconButton(icon: Icons.work_outline),
                ],
              ),
            ],
          ),

          // Cac cot thong tin
          _taoCotThongTin(
            tieuDe: 'Dịch Vụ',
            danhSachMuc: [
              'Đặt món trực tuyến',
              'Giao tận nơi',
              'Khuyến mãi HOT',
              'Chính sách hội viên',
            ],
          ),
          _taoCotThongTin(
            tieuDe: 'Khám Phá',
            danhSachMuc: [
              'Quán ngon quanh đây',
              'Món mới ra mắt',
              'Đánh giá cửa hàng',
              'Blog Ẩm Thực',
            ],
          ),
          _taoCotThongTin(
            tieuDe: 'Hỗ Trợ',
            danhSachMuc: [
              'Trung tâm trợ giúp',
              'Hướng dẫn thanh toán',
              'Bảo mật thông tin',
              'Liên hệ đối tác',
            ],
          ),
        ],
      ),
    );
  }

  Widget _taoCotThongTin({
    required String tieuDe,
    required List<String> danhSachMuc,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tieuDe,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: _mauChu,
          ),
        ),
        const SizedBox(height: 24),
        ...danhSachMuc.map(
          (muc) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Text(
                  muc,
                  style: const TextStyle(color: _mauChu, fontSize: 14),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterIconButton extends StatelessWidget {
  const _FooterIconButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 24, color: AboutScreen._mauChu),
      ),
    );
  }
}
