import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_sizes.dart';
import '../../services/admin_auth_service.dart';
import '../../widgets/app_widgets.dart';
import '../auth/widgets/auth_layout.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _status;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleAdminLogin() {
    FocusScope.of(context).unfocus();
    setState(() => _status = null);

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final adminAuth = context.read<AdminAuthService>();
    final success = adminAuth.validateCredentials(
      _emailController.text,
      _passwordController.text,
    );

    if (!success) {
      setState(() => _status = 'Thông tin quản trị không hợp lệ.');
      return;
    }

    Navigator.pushReplacementNamed(context, '/admin');
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Cổng quản trị',
      subtitle: 'Đăng nhập tài khoản quản trị nội bộ.',
      footer: TextButton(
        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        child: const Text('Quay lại đăng nhập người dùng'),
      ),
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                key: const Key('admin-email-field'),
                controller: _emailController,
                labelText: 'Email quản trị',
                prefixIcon: Icons.admin_panel_settings_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty) return 'Vui lòng nhập email quản trị';
                  if (!email.contains('@')) return 'Email không hợp lệ';
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.md),
              AppTextField(
                key: const Key('admin-password-field'),
                controller: _passwordController,
                labelText: 'Mật khẩu',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  return null;
                },
                onSubmitted: (_) => _handleAdminLogin(),
                suffixIcon: IconButton(
                  tooltip: _obscurePassword ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
              AuthStatusMessage(message: _status),
              const SizedBox(height: AppSizes.md),
              PrimaryButton(
                key: const Key('admin-login-button'),
                label: 'Vào quản trị',
                onPressed: _handleAdminLogin,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
