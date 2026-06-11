import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_widgets.dart';
import 'widgets/auth_layout.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isResetting = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _authStatus;
  bool _statusIsError = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    FocusScope.of(context).unfocus();
    setState(() => _authStatus = null);

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isResetting = true);
    final success = await context.read<AuthProvider>().resetPassword(
      _phoneController.text.trim(),
      _newPasswordController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isResetting = false;
      _statusIsError = !success;
      _authStatus = success
          ? 'Đặt lại mật khẩu thành công. Bạn có thể quay lại đăng nhập.'
          : 'Số điện thoại không tồn tại';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      eyebrow: 'Bảo mật tài khoản',
      title: 'Đặt lại mật khẩu',
      subtitle: 'Nhập số điện thoại đã đăng ký và mật khẩu mới.',
      highlights: const [
        AuthHighlight(
          icon: Icons.phone_iphone_outlined,
          label: 'Số đã đăng ký',
        ),
        AuthHighlight(icon: Icons.lock_reset_outlined, label: 'Mật khẩu mới'),
      ],
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                controller: _newPasswordController,
                labelText: 'Mật khẩu mới',
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
                labelText: 'Nhập lại mật khẩu mới',
                prefixIcon: Icons.lock_reset_outlined,
                obscureText: _obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                validator: _validateConfirmPassword,
                onSubmitted: (_) {
                  if (!_isResetting) _handleReset();
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
              AuthStatusMessage(message: _authStatus, isError: _statusIsError),
              const SizedBox(height: AppSizes.md),
              PrimaryButton(
                label: 'Đặt lại mật khẩu',
                onPressed: _isResetting ? null : _handleReset,
                isLoading: _isResetting,
              ),
              const SizedBox(height: AppSizes.sm),
              SecondaryButton(
                label: 'Quay lại đăng nhập',
                onPressed: _isResetting ? null : () => Navigator.pop(context),
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
    if (value?.trim() != _newPasswordController.text.trim()) {
      return 'Mật khẩu nhập lại không khớp';
    }
    return null;
  }
}
