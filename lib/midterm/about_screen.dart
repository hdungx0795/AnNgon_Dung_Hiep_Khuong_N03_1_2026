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
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 700;
        final double titleSize = isMobile ? 34 : 56;
        final double subTitleSize = isMobile ? 18 : 24;
        final double verticalGap = isMobile ? 48 : 80;
        final double footerGap = isMobile ? 56 : 100;

        return Scaffold(
          backgroundColor: _nenTrang,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _taoPhanDau(isMobile: isMobile),
                  SizedBox(height: verticalGap),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 24),
                    child: Column(
                      children: [
                        Text(
                          'Về Ứng Dụng AnNgon',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.bold,
                            color: _mauChu,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Thiết kế và phát triển bởi Hiệp.\nKhám phá các món ăn ngon mỗi ngày hoặc gửi phản hồi cho chúng tôi.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: subTitleSize,
                            color: _mauPhu,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: isMobile ? 28 : 40),
                        _taoFormLienHe(isMobile: isMobile),
                      ],
                    ),
                  ),
                  SizedBox(height: footerGap),
                  _taoChanTrang(isMobile: isMobile),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Thanh dieu huong (Navbar)
  Widget _taoPhanDau({required bool isMobile}) {
    final List<String> danhSachLienKet = [
      'Trang Chủ',
      'Thực Đơn',
      'Khuyến Mãi',
      'Cửa Hàng',
      'Liên Hệ',
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: isMobile ? 16 : 18,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _mauVien)),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _taoLogo(),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      danhSachLienKet.map((ten) => _taoLienKet(ten)).toList(),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _taoNutDangNhap(isMobile: true),
                    _taoNutDangKy(isMobile: true),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _taoLogo(),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      danhSachLienKet.map((ten) => _taoLienKet(ten)).toList(),
                ),
                Row(
                  children: [
                    _taoNutDangNhap(),
                    const SizedBox(width: 12),
                    _taoNutDangKy(),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _taoLogo() {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
    );
  }

  Widget _taoNutDangNhap({bool isMobile = false}) {
    return SizedBox(
      width: isMobile ? double.infinity : null,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _mauNenNhat,
          foregroundColor: _mauChu,
          elevation: 0,
          side: const BorderSide(color: _mauVien),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Đăng nhập'),
      ),
    );
  }

  Widget _taoNutDangKy({bool isMobile = false}) {
    return SizedBox(
      width: isMobile ? double.infinity : null,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _mauChu,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Đăng ký'),
      ),
    );
  }

  Widget _taoLienKet(String tenLienKet) {
    return InkWell(
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
    );
  }

  // The Form chua cac o nhap lieu
  Widget _taoFormLienHe({required bool isMobile}) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 450,
        minWidth: isMobile ? 0 : 450,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 20 : 32),
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
  Widget _taoChanTrang({required bool isMobile}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 36 : 60,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _mauVien)),
      ),
      child: Wrap(
        spacing: isMobile ? 24 : 56,
        runSpacing: isMobile ? 32 : 40,
        alignment: WrapAlignment.spaceBetween,
        children: [
          SizedBox(
            width: isMobile ? double.infinity : 200,
            child: Column(
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
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: const [
                    _FooterIconButton(icon: Icons.close),
                    _FooterIconButton(icon: Icons.camera_alt_outlined),
                    _FooterIconButton(icon: Icons.play_circle_outline),
                    _FooterIconButton(icon: Icons.work_outline),
                  ],
                ),
              ],
            ),
          ),
          _taoCotThongTin(
            tieuDe: 'Dịch Vụ',
            danhSachMuc: [
              'Đặt món trực tuyến',
              'Giao tận nơi',
              'Khuyến mãi HOT',
              'Chính sách hội viên',
            ],
            isMobile: isMobile,
          ),
          _taoCotThongTin(
            tieuDe: 'Khám Phá',
            danhSachMuc: [
              'Quán ngon quanh đây',
              'Món mới ra mắt',
              'Đánh giá cửa hàng',
              'Blog Ẩm Thực',
            ],
            isMobile: isMobile,
          ),
          _taoCotThongTin(
            tieuDe: 'Hỗ Trợ',
            danhSachMuc: [
              'Trung tâm trợ giúp',
              'Hướng dẫn thanh toán',
              'Bảo mật thông tin',
              'Liên hệ đối tác',
            ],
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }

  Widget _taoCotThongTin({
    required String tieuDe,
    required List<String> danhSachMuc,
    required bool isMobile,
  }) {
    return SizedBox(
      width: isMobile ? double.infinity : 180,
      child: Column(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  child: Text(
                    muc,
                    style: const TextStyle(color: _mauChu, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
