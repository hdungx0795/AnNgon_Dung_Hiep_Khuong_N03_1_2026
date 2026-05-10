import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trung tâm trợ giúp')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFFF2994A)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(Icons.support_agent, size: 48, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Bạn cần giúp đỡ?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  'Tìm câu trả lời trong các câu hỏi thường gặp bên dưới',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text('Câu hỏi thường gặp', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          _buildFaqItem(
            'Làm sao để đặt hàng?',
            'Chọn món ăn bạn thích → Thêm vào giỏ hàng → Chọn "Thanh toán" → Nhập địa chỉ và xác nhận đơn hàng.',
          ),
          _buildFaqItem(
            'Tôi có thể hủy đơn hàng không?',
            'Bạn có thể hủy đơn hàng khi đơn hàng chưa được xác nhận. Sau khi quán đã xác nhận thì không thể hủy.',
          ),
          _buildFaqItem(
            'Các phương thức thanh toán?',
            'PKA Food hỗ trợ thanh toán tiền mặt (COD), chuyển khoản ngân hàng qua QR code, và ví điện tử.',
          ),
          _buildFaqItem(
            'Làm sao để sử dụng voucher?',
            'Tại trang thanh toán, nhập mã voucher vào ô "Voucher giảm giá" và nhấn "Áp dụng". Mã hợp lệ sẽ được tự động trừ vào tổng đơn.',
          ),
          _buildFaqItem(
            'Thời gian giao hàng là bao lâu?',
            'Thời gian giao hàng trung bình từ 15-30 phút tùy khoảng cách. Bạn có thể theo dõi đơn hàng trong mục "Đơn hàng".',
          ),
          _buildFaqItem(
            'Liên hệ hỗ trợ?',
            'Hotline: 1900-xxxx\nEmail: support@pkafood.vn\nThời gian: 8:00 - 22:00 hàng ngày',
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: const Icon(Icons.help_outline, color: AppColors.primary, size: 22),
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        children: [
          Text(answer, style: const TextStyle(color: Colors.grey, height: 1.5)),
        ],
      ),
    );
  }
}
