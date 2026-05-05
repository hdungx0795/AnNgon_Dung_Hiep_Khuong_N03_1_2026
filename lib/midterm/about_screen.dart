import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
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
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Tieu de phu
            const Text(
              'Khám phá các món ăn ngon mỗi ngày hoặc gửi phản hồi cho chúng tôi.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, color: Colors.black54),
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
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: const [
              Icon(Icons.restaurant_menu, size: 32, color: Colors.deepOrange),
              SizedBox(width: 8),
              Text(
                'AnNgon',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ],
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
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text('Đăng nhập'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.deepOrange, // Dong bo voi chu de AnNgon
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
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
      child: Text(
        tenLienKet,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
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
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.black12, width: 0.5),
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
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
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
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: soDong,
          decoration: InputDecoration(
            hintText: 'Value',
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black54),
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
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Cot chua Logo va Mang xa hoi
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.all_inclusive, size: 36),
              const SizedBox(height: 24),
              Row(
                children: const [
                  Icon(Icons.close, size: 24),
                  SizedBox(width: 16),
                  Icon(Icons.camera_alt_outlined, size: 24),
                  SizedBox(width: 16),
                  Icon(Icons.play_circle_outline, size: 24),
                  SizedBox(width: 16),
                  Icon(Icons.work_outline, size: 24),
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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 24),
        ...danhSachMuc.map(
          (muc) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              muc,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
