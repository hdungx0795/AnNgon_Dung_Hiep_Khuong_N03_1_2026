import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _orderUpdates = true;
  bool _promotions = true;
  bool _newProducts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt thông báo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.delivery_dining, color: AppColors.primary),
                  title: const Text('Cập nhật đơn hàng', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: const Text('Thông báo trạng thái giao hàng'),
                  value: _orderUpdates,
                  activeColor: AppColors.primary,
                  onChanged: (val) => setState(() => _orderUpdates = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.local_offer, color: Colors.orange),
                  title: const Text('Khuyến mãi', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: const Text('Voucher và ưu đãi mới'),
                  value: _promotions,
                  activeColor: AppColors.primary,
                  onChanged: (val) => setState(() => _promotions = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.fastfood, color: Colors.green),
                  title: const Text('Món mới', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: const Text('Thông báo khi có món mới'),
                  value: _newProducts,
                  activeColor: AppColors.primary,
                  onChanged: (val) => setState(() => _newProducts = val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
