import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_widgets.dart';
import 'widgets/auth_layout.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _authStatus;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();
    setState(() => _authStatus = null);

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final success = await context.read<AuthProvider>().register(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      dob: _dobController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _authStatus = context.read<AuthProvider>().error ?? 'Đăng ký thất bại';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return AuthLayout(
      title: 'Tạo tài khoản',
      subtitle: 'Dùng số điện thoại và mật khẩu để lưu giỏ hàng, đơn hàng.',
      footer: TextButton(
        onPressed: isLoading ? null : () => Navigator.pop(context),
        child: const Text('Đã có tài khoản? Đăng nhập'),
      ),
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _nameController,
                labelText: 'Họ và tên',
                prefixIcon: Icons.person_outline,
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    Validators.validateRequired(value?.trim(), 'họ và tên'),
              ),
              const SizedBox(height: AppSizes.md),
              AppTextField(
                controller: _phoneController,
                labelText: 'Số điện thoại',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: (value) => Validators.validatePhone(value?.trim()),
              ),
              const SizedBox(height: AppSizes.md),
              AppTextField(
                controller: _emailController,
                labelText: 'Email',
                prefixIcon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) => Validators.validateEmail(value?.trim()),
              ),
              const SizedBox(height: AppSizes.md),
              AppTextField(
                controller: _dobController,
                labelText: 'Ngày sinh (DD/MM/YYYY)',
                prefixIcon: Icons.calendar_today_outlined,
                keyboardType: TextInputType.datetime,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSizes.md),
              AppTextField(
                controller: _passwordController,
                labelText: 'Mật khẩu',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    Validators.validatePassword(value?.trim()),
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
              const SizedBox(height: AppSizes.md),
              AppTextField(
                controller: _confirmPasswordController,
                labelText: 'Nhập lại mật khẩu',
                prefixIcon: Icons.lock_reset_outlined,
                obscureText: _obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                validator: _validateConfirmPassword,
                onSubmitted: (_) {
                  if (!isLoading) _handleRegister();
                },
                suffixIcon: IconButton(
                  tooltip: _obscureConfirmPassword
                      ? 'Hiện mật khẩu'
                      : 'Ẩn mật khẩu',
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.md),
              AuthStatusMessage(message: _authStatus),
              const SizedBox(height: AppSizes.md),
              PrimaryButton(
                label: 'Đăng ký',
                onPressed: isLoading ? null : _handleRegister,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String? _validateConfirmPassword(String? value) {
    final passwordError = Validators.validatePassword(value?.trim());
    if (passwordError != null) return passwordError;
    if (value?.trim() != _passwordController.text.trim()) {
      return 'Mật khẩu nhập lại không khớp';
    }
    return null;
  }
}
