import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final success = await context.read<AuthProvider>().changePassword(
      _oldPasswordController.text,
      _newPasswordController.text,
    );
    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context, true);
      } else {
        final error = context.read<AuthProvider>().error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error ?? 'Đổi mật khẩu thất bại')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Đổi mật khẩu')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lock_reset, color: colorScheme.primary),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Text(
                        'Mật khẩu mới chỉ cập nhật cho tài khoản cục bộ trên thiết bị này.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              AppTextField(
                controller: _oldPasswordController,
                labelText: 'Mật khẩu cũ',
                prefixIcon: Icons.lock_outline,
                obscureText: !_showOldPassword,
                textInputAction: TextInputAction.next,
                suffixIcon: _PasswordVisibilityButton(
                  isVisible: _showOldPassword,
                  onPressed: () =>
                      setState(() => _showOldPassword = !_showOldPassword),
                ),
                validator: (val) => Validators.validatePassword(val ?? ''),
              ),
              const SizedBox(height: AppSizes.md),
              AppTextField(
                controller: _newPasswordController,
                labelText: 'Mật khẩu mới',
                prefixIcon: Icons.lock_outline,
                obscureText: !_showNewPassword,
                textInputAction: TextInputAction.next,
                suffixIcon: _PasswordVisibilityButton(
                  isVisible: _showNewPassword,
                  onPressed: () =>
                      setState(() => _showNewPassword = !_showNewPassword),
                ),
                validator: (val) => Validators.validatePassword(val ?? ''),
              ),
              const SizedBox(height: AppSizes.md),
              AppTextField(
                controller: _confirmPasswordController,
                labelText: 'Xác nhận mật khẩu mới',
                prefixIcon: Icons.lock_outline,
                obscureText: !_showConfirmPassword,
                textInputAction: TextInputAction.done,
                suffixIcon: _PasswordVisibilityButton(
                  isVisible: _showConfirmPassword,
                  onPressed: () => setState(
                    () => _showConfirmPassword = !_showConfirmPassword,
                  ),
                ),
                validator: (val) {
                  if (val != _newPasswordController.text) {
                    return 'Mật khẩu xác nhận không khớp';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.xl),
              PrimaryButton(
                key: const Key('change-password-submit-button'),
                label: 'Đổi mật khẩu',
                icon: Icons.check,
                isLoading: _isLoading,
                onPressed: _changePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordVisibilityButton extends StatelessWidget {
  const _PasswordVisibilityButton({
    required this.isVisible,
    required this.onPressed,
  });

  final bool isVisible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: isVisible ? 'Ẩn mật khẩu' : 'Hiện mật khẩu',
      icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
      onPressed: onPressed,
    );
  }
}
