// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/app_widgets.dart';
import '../order/order_history_screen.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'widgets/help_center_dialog.dart';
import 'widgets/notification_settings_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hồ sơ cá nhân')),
        body: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: EmptyState(
            key: const Key('profile-guest-state'),
            icon: Icons.person_outline,
            title: 'Đăng nhập để xem hồ sơ',
            message:
                'Quản lý thông tin cá nhân, lịch sử đơn hàng và cài đặt giao diện tại đây.',
            actionLabel: 'Đăng nhập ngay',
            onActionPressed: () => Navigator.pushNamed(context, '/login'),
          ),
        ),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Hồ sơ cá nhân'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.md,
          AppSizes.md,
          AppSizes.md,
          AppSizes.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProfileHeader(user: user),
            const SizedBox(height: AppSizes.lg),
            _ProfileMenuSection(auth: auth),
            const SizedBox(height: AppSizes.lg),
            _buildLogoutButton(context, auth),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Dữ liệu tài khoản được lưu cục bộ trên thiết bị cho phạm vi demo.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider auth) {
    return SecondaryButton(
      label: 'Đăng xuất',
      icon: Icons.logout,
      onPressed: () async {
        await auth.logout();
        if (!context.mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      key: const Key('profile-authenticated-header'),
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: colorScheme.surface,
            backgroundImage: user.avatarPath == null
                ? null
                : AssetImage(user.avatarPath!),
            child: user.avatarPath == null
                ? Icon(
                    Icons.person,
                    size: AppSizes.iconLg,
                    color: colorScheme.primary,
                  )
                : null,
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  user.phone,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer.withOpacity(0.78),
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimaryContainer.withOpacity(0.72),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuSection extends StatelessWidget {
  const _ProfileMenuSection({required this.auth});

  final AuthProvider auth;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      key: const Key('profile-menu-section'),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          _ProfileMenuItem(
            icon: Icons.person_outline,
            title: 'Thông tin cá nhân',
            subtitle: 'Cập nhật tên và email',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditProfileScreen(),
              ),
            ),
          ),
          const Divider(height: 1),
          _ProfileMenuItem(
            icon: Icons.history,
            title: 'Lịch sử đơn hàng',
            subtitle: 'Xem lại các đơn đã hoàn tất',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
            ),
          ),
          const Divider(height: 1),
          _ProfileMenuItem(
            icon: Icons.lock_outline,
            title: 'Đổi mật khẩu',
            subtitle: 'Bảo vệ tài khoản cục bộ',
            onTap: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
              if (result == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đổi mật khẩu thành công!')),
                );
              }
            },
          ),
          const Divider(height: 1),
          _ProfileMenuItem(
            icon: Icons.notifications_none,
            title: 'Thông báo',
            subtitle: 'Cài đặt thông báo đơn hàng và ưu đãi',
            onTap: () => showDialog(
              context: context,
              builder: (_) => const NotificationSettingsDialog(),
            ),
          ),
          const Divider(height: 1),
          _ProfileMenuItem(
            icon: Icons.help_outline,
            title: 'Trung tâm trợ giúp',
            subtitle: 'Hotline, email và câu hỏi thường gặp',
            onTap: () => showDialog(
              context: context,
              builder: (_) => const HelpCenterDialog(),
            ),
          ),
          const Divider(height: 1),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                key: const Key('profile-theme-switch'),
                secondary: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: AppColors.primary,
                ),
                title: const Text(
                  'Chế độ tối',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Áp dụng giao diện tối cho toàn ứng dụng'),
                value: themeProvider.isDarkMode,
                onChanged: (_) => themeProvider.toggleTheme(),
              );
            },
          ),
        ],
      ),
    );
  }


}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.xs,
      ),
      leading: CircleAvatar(
        backgroundColor: colorScheme.primaryContainer,
        child: Icon(icon, color: colorScheme.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: Icon(
        Icons.chevron_right,
        size: AppSizes.iconSm,
        color: colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}
