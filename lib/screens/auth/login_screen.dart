import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/app_widgets.dart';
import 'widgets/auth_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _authStatus;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    setState(() => _authStatus = null);

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final authProvider = context.read<AuthProvider>();
    final cartProvider = context.read<CartProvider>();
    final favoritesProvider = context.read<FavoritesProvider>();
    final orderProvider = context.read<OrderProvider>();

    final success = await authProvider.login(phone, password);
    if (!mounted) return;

    if (!success) {
      setState(() {
        _authStatus = authProvider.error ?? 'Đăng nhập thất bại';
      });
      return;
    }

    final user = authProvider.currentUser;
    if (user == null) {
      setState(() {
        _authStatus = 'Không thể tải phiên đăng nhập. Vui lòng thử lại.';
      });
      return;
    }

    await cartProvider.loadCart(user.phone);
    await favoritesProvider.loadFavorites(user.phone);
    await orderProvider.loadOrders(user.id);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return AuthLayout(
      title: 'Chào mừng trở lại',
      subtitle: 'Đăng nhập bằng số điện thoại để tiếp tục đặt món.',
      footer: TextButton(
        onPressed: isLoading
            ? null
            : () => Navigator.pushNamed(context, '/register'),
        child: const Text('Chưa có tài khoản? Đăng ký ngay'),
      ),
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
                controller: _passwordController,
                labelText: 'Mật khẩu',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                validator: (value) =>
                    Validators.validatePassword(value?.trim()),
                onSubmitted: (_) {
                  if (!isLoading) _handleLogin();
                },
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.pushNamed(context, '/forgot-password'),
                  child: const Text('Quên mật khẩu?'),
                ),
              ),
              AuthStatusMessage(message: _authStatus),
              const SizedBox(height: AppSizes.md),
              PrimaryButton(
                label: 'Đăng nhập',
                onPressed: isLoading ? null : _handleLogin,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
