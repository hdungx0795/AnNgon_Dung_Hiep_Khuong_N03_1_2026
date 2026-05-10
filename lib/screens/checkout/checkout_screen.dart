import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/format_utils.dart';
import '../../models/cart_item_model.dart';
import '../../models/enums/payment_method.dart';
import '../../models/user_model.dart';
import '../../models/voucher_model.dart';
import '../../services/voucher_service.dart';
import '../tracking/tracking_order_screen.dart';
import 'qr_payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  final _voucherController = TextEditingController();
  
  PaymentMethod _paymentMethod = PaymentMethod.cod;
  VoucherModel? _appliedVoucher;
  bool _isPlacingOrder = false;
  String? _voucherError;

  void _applyVoucher(int total) {
    final code = _voucherController.text.trim();
    if (code.isEmpty) return;

    final voucher = context.read<VoucherService>().validateVoucher(code, total);
    setState(() {
      if (voucher != null) {
        _appliedVoucher = voucher;
        _voucherError = null;
      } else {
        _appliedVoucher = null;
        _voucherError = 'Mã không hợp lệ hoặc không đủ điều kiện';
      }
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _noteController.dispose();
    _voucherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final user = context.watch<AuthProvider>().currentUser;
    final selectedItems = cartProvider.items.where((item) => item.isSelected).toList();
    final total = cartProvider.totalAmount;
    final discount = _appliedVoucher?.calculateDiscount(total) ?? 0;
    final finalAmount = total - discount;

    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Địa chỉ giao hàng
            _buildSectionCard(
              icon: Icons.location_on_outlined,
              title: 'Địa chỉ giao hàng',
              child: TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  hintText: 'Nhập địa chỉ giao hàng...',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Voucher
            _buildSectionCard(
              icon: Icons.discount_outlined,
              title: 'Voucher giảm giá',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _voucherController,
                          decoration: InputDecoration(
                            hintText: 'Nhập mã voucher',
                            errorText: _voucherError,
                            prefixIcon: const Icon(Icons.confirmation_number_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _applyVoucher(total),
                        child: const Text('Áp dụng'),
                      ),
                    ],
                  ),
                  if (_appliedVoucher != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            '${_appliedVoucher!.code} (-${FormatUtils.formatCurrency(discount)})',
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Ghi chú
            _buildSectionCard(
              icon: Icons.note_alt_outlined,
              title: 'Ghi chú',
              child: TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  hintText: 'VD: Không hành, ít cay...',
                  prefixIcon: Icon(Icons.edit_outlined),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Phương thức thanh toán
            _buildSectionCard(
              icon: Icons.payment_outlined,
              title: 'Phương thức thanh toán',
              child: Column(
                children: [
                  _buildPaymentOption(
                    method: PaymentMethod.cod,
                    icon: Icons.money,
                    iconColor: Colors.green,
                    title: 'Thanh toán khi nhận hàng',
                    subtitle: 'Trả tiền mặt cho shipper',
                  ),
                  _buildPaymentOption(
                    method: PaymentMethod.bankTransfer,
                    icon: Icons.qr_code_2,
                    iconColor: Colors.blue,
                    title: 'Chuyển khoản ngân hàng',
                    subtitle: 'Quét QR để chuyển khoản',
                  ),
                  _buildPaymentOption(
                    method: PaymentMethod.ewallet,
                    icon: Icons.account_balance_wallet,
                    iconColor: Colors.orange,
                    title: 'Ví điện tử',
                    subtitle: 'MoMo, ZaloPay, VNPay',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Tóm tắt đơn hàng
            _buildSectionCard(
              icon: Icons.receipt_long_outlined,
              title: 'Tóm tắt đơn hàng',
              child: Column(
                children: [
                  ...selectedItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.quantity}x ${item.product.name}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(FormatUtils.formatCurrency(item.totalPrice)),
                      ],
                    ),
                  )),
                  const Divider(),
                  if (discount > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Giảm giá', style: TextStyle(color: Colors.grey)),
                          Text('-${FormatUtils.formatCurrency(discount)}', style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tổng cộng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Text(
                          FormatUtils.formatCurrency(finalAmount),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (selectedItems.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'Vui lòng chọn ít nhất 1 món trong giỏ hàng để thanh toán.',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            if (user == null)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'Phiên đăng nhập không hợp lệ. Vui lòng đăng nhập lại.',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isPlacingOrder
                    ? null
                    : () => _handleCheckout(
                          user: user,
                          selectedItems: selectedItems,
                          cartProvider: cartProvider,
                          finalAmount: finalAmount,
                        ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isPlacingOrder
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'XÁC NHẬN ĐẶT HÀNG',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required PaymentMethod method,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _paymentMethod == method;
    return InkWell(
      onTap: () => setState(() => _paymentMethod = method),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? AppColors.primary.withAlpha(13) : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withAlpha(26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                ],
              ),
            ),
            Radio<PaymentMethod>(
              value: method,
              groupValue: _paymentMethod,
              activeColor: AppColors.primary,
              onChanged: (v) {
                if (v != null) setState(() => _paymentMethod = v);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleCheckout({
    required UserModel? user,
    required List<CartItemModel> selectedItems,
    required CartProvider cartProvider,
    required int finalAmount,
  }) {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ít nhất 1 món để thanh toán')),
      );
      return;
    }

    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập địa chỉ')),
      );
      return;
    }

    if (_paymentMethod == PaymentMethod.bankTransfer) {
      // Navigate to QR Payment Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QrPaymentScreen(
            amount: finalAmount,
            onPaymentConfirmed: () {
              // Pop QR screen first
              Navigator.pop(context);
              // Then place order
              _placeOrder(
                user: user,
                selectedItems: selectedItems,
                cartProvider: cartProvider,
              );
            },
          ),
        ),
      );
    } else {
      _placeOrder(
        user: user,
        selectedItems: selectedItems,
        cartProvider: cartProvider,
      );
    }
  }

  Future<void> _placeOrder({
    required UserModel user,
    required List<CartItemModel> selectedItems,
    required CartProvider cartProvider,
  }) async {
    final orderProvider = context.read<OrderProvider>();
    setState(() => _isPlacingOrder = true);
    try {
      final order = await orderProvider.placeOrder(
        userId: user.id,
        items: selectedItems,
        paymentMethod: _paymentMethod,
        address: _addressController.text,
        note: _noteController.text,
        voucher: _appliedVoucher,
      );
      
      await cartProvider.clearSelected(user.phone);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đặt hàng thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TrackingOrderScreen(orderId: order.orderId),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }
}
