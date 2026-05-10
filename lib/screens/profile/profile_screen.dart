// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../core/constants/app_colors.dart';
import '../order/order_history_screen.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'notification_settings_screen.dart';
import 'help_center_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hồ sơ')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_outline, size: 100, color: Colors.grey),
              const SizedBox(height: 20),
              const Text('Vui lòng đăng nhập để xem hồ sơ'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('Đăng nhập ngay'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(user),
            const SizedBox(height: 20),
            _buildMenuSection(context, auth),
            const SizedBox(height: 30),
            _buildLogoutButton(context, auth),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: user.avatarPath != null 
                    ? AssetImage(user.avatarPath!) 
                    : null,
                child: user.avatarPath == null 
                    ? const Icon(Icons.person, size: 60, color: AppColors.primary) 
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.camera_alt, size: 18, color: AppColors.primary),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tính năng đổi ảnh đại diện đang phát triển'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            user.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            user.phone,
            style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, AuthProvider auth) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            Icons.person_outline, 
            'Thông tin cá nhân', 
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()))
          ),
          const Divider(height: 1),
          _buildMenuItem(
            Icons.history, 
            'Lịch sử đơn hàng', 
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistoryScreen()))
          ),
          const Divider(height: 1),
          _buildMenuItem(
            Icons.lock_outline, 
            'Đổi mật khẩu', 
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen()))
          ),
          const Divider(height: 1),
          _buildMenuItem(
            Icons.notifications_none, 
            'Thông báo', 
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()))
          ),
          const Divider(height: 1),
          _buildMenuItem(
            Icons.help_outline, 
            'Trung tâm trợ giúp', 
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpCenterScreen()))
          ),
          const Divider(height: 1),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                secondary: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: AppColors.primary,
                ),
                title: const Text('Chế độ tối', style: TextStyle(fontWeight: FontWeight.w500)),
                value: themeProvider.isDarkMode,
                onChanged: (val) => themeProvider.toggleTheme(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider auth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: OutlinedButton(
        onPressed: () {
          auth.logout();
          Navigator.pushReplacementNamed(context, '/login');
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text('ĐĂNG XUẤT', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
