import 'package:flutter/material.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _NavBar(),
            const _HeroSection(),
            const SizedBox(height: 60),
            const _TwoLargeCardsSection(),
            const SizedBox(height: 60),
            const _HorizontalListSection(),
            const SizedBox(height: 60),
            const _GridSection(),
            const SizedBox(height: 60),
            const Divider(color: Colors.black12, height: 1, thickness: 1),
            const _FooterSection(),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 1. NAVIGATION BAR
// ==========================================
class _NavBar extends StatelessWidget {
  const _NavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: const [
              Icon(Icons.delivery_dining, size: 40, color: Colors.black87),
              SizedBox(width: 10),
              Text(
                'Ăn Ngon',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          
          // Menu Links
          MediaQuery.of(context).size.width > 800 ? Row(
            children: [
              _navItem('Trang chủ'),
              _navItem('Thực đơn'),
              _navItem('Khuyến mãi'),
              _navItem('Nhà hàng'),
              _navItem('Blog Ẩm Thực'),
            ],
          ) : const SizedBox.shrink(),

          // Auth Buttons
          Row(
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black38),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: const Text('Đăng nhập'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D2D2D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: const Text('Đăng ký'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _navItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }
}

// ==========================================
// 2. HERO SECTION
// ==========================================
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF7F7F7),
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 20),
      child: Column(
        children: const [
          Text(
            'Thèm Là Có - Giao Tận Ngõ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
          SizedBox(height: 15),
          Text(
            'Khám phá hàng ngàn món ăn hấp dẫn từ các nhà hàng nổi tiếng ngay trên thiết bị của bạn.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. TWO LARGE CARDS SECTION
// ==========================================
class _TwoLargeCardsSection extends StatelessWidget {
  const _TwoLargeCardsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          _buildLargeCard(context, 'Siêu Sale Giờ Vàng', Icons.local_fire_department),
          _buildLargeCard(context, 'Freeship Đơn 0Đ', Icons.motorcycle),
        ],
      ),
    );
  }

  Widget _buildLargeCard(BuildContext context, String title, IconData icon) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth > 800 ? (screenWidth - 100) / 2 : screenWidth - 80;

    return Container(
      width: cardWidth,
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.black54),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
          )
        ],
      ),
    );
  }
}

// ==========================================
// 4. HORIZONTAL LIST SECTION
// ==========================================
class _HorizontalListSection extends StatelessWidget {
  const _HorizontalListSection();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'title': 'Cơm Tấm Sườn Bì Chả Sài Gòn',
        'desc': 'Sườn nướng mật ong than hoa thơm lừng, bì chả nhà làm chuẩn vị truyền thống. Tặng kèm canh chua thanh mát cho đơn từ 2 suất.',
        'icon': Icons.rice_bowl,
      },
      {
        'title': 'Phở Thìn Bờ Hồ - Chi Nhánh Mới',
        'desc': 'Nước dùng ninh xương 24h ngọt thanh, thịt bò mềm tan trong miệng. Lựa chọn hoàn hảo cho bữa sáng đầy năng lượng.',
        'icon': Icons.ramen_dining,
      },
      {
        'title': 'Trà Sữa Tocotoco & Ăn Vặt',
        'desc': 'Best seller Hồng Trà Sữa Trân Châu Hoàng Kim ròn rụm. Combo giải nhiệt mùa hè giảm giá tới 30% khi đặt theo nhóm.',
        'icon': Icons.local_drink,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nhà Hàng Nổi Bật',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Top các quán ăn được khách hàng đánh giá 5 sao tuần qua',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const SizedBox(height: 30),
          
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              return _buildHorizontalCard(
                items[index]['title'],
                items[index]['desc'],
                items[index]['icon'],
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildHorizontalCard(String title, String desc, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Box
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, size: 60, color: Colors.black54),
          ),
          const SizedBox(width: 20),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                ),
                const SizedBox(height: 15),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: const BorderSide(color: Colors.black38),
                  ),
                  child: const Text('Đặt món ngay'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// 5. GRID SECTION
// ==========================================
class _GridSection extends StatelessWidget {
  const _GridSection();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Pizza Hải Sản', 'desc': 'Đế mỏng giòn, phô mai ngập tràn.', 'icon': Icons.local_pizza},
      {'title': 'Hamburger Bò', 'desc': 'Bò nướng tảng mềm mọng, xốt BBQ.', 'icon': Icons.lunch_dining},
      {'title': 'Bún Chả Hà Nội', 'desc': 'Chả nướng than hoa, nước mắm chua ngọt.', 'icon': Icons.restaurant},
      {'title': 'Sushi Cá Hồi', 'desc': 'Cá hồi tươi rói, chuẩn hương vị Nhật Bản.', 'icon': Icons.set_meal},
      {'title': 'Bánh Mì Pate', 'desc': 'Vỏ giòn rụm, nhân ngập ngụa topping.', 'icon': Icons.bakery_dining},
      {'title': 'Salad Trái Cây', 'desc': 'Thanh mát, healthy cho ngày hè nóng nực.', 'icon': Icons.eco},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gợi Ý Hôm Nay',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hàng ngàn món ngon đang chờ bạn khám phá',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const SizedBox(height: 30),
          
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: menuItems.map((item) => _buildVerticalCard(context, item['title'], item['desc'], item['icon'])).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildVerticalCard(BuildContext context, String title, String desc, IconData icon) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth > 900 
        ? (screenWidth - 120) / 3 
        : screenWidth > 600 ? (screenWidth - 100) / 2 : screenWidth - 80;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, size: 70, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.4),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 6. FOOTER SECTION
// ==========================================
class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 40,
        runSpacing: 40,
        children: [
          // Logo & Socials
          SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.delivery_dining, size: 30, color: Colors.black87),
                    SizedBox(width: 8),
                    Text(
                      'Ăn Ngon',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Ứng dụng giao đồ ăn số 1 Việt Nam. Đặt món dễ dàng, giao hàng siêu tốc.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),
                Row(
                  children: const [
                    Icon(Icons.facebook, size: 24, color: Colors.black87),
                    SizedBox(width: 15),
                    Icon(Icons.camera_alt, size: 24, color: Colors.black87), 
                    SizedBox(width: 15),
                    Icon(Icons.play_circle_fill, size: 24, color: Colors.black87), 
                  ],
                )
              ],
            ),
          ),
          
          _buildFooterColumn('Về Ăn Ngon', [
            'Giới thiệu', 'Tuyển dụng', 'Quy chế hoạt động', 'Chính sách bảo mật thông tin'
          ]),
          _buildFooterColumn('Hợp Tác', [
            'Đăng ký quán ăn', 'Đăng ký tài xế giao hàng', 'Đối tác doanh nghiệp'
          ]),
          _buildFooterColumn('Hỗ Trợ Khách Hàng', [
            'Trung tâm trợ giúp', 'Câu hỏi thường gặp', 'Hướng dẫn đặt món', 'Tổng đài: 1900 xxxx'
          ]),
        ],
      ),
    );
  }

  Widget _buildFooterColumn(String title, List<String> links) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...links.map((link) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  link,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              )),
        ],
      ),
    );
  }
}