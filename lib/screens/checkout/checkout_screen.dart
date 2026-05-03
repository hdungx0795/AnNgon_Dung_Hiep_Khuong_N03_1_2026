// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/format_utils.dart';
import '../../models/enums/payment_method.dart';
import '../../models/voucher_model.dart';
import '../../services/voucher_service.dart';
import '../tracking/tracking_order_screen.dart';

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

    final voucher = VoucherService().validateVoucher(code, total);
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
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final user = context.watch<AuthProvider>().currentUser;
    final total = cartProvider.totalAmount;
    final discount = _appliedVoucher?.calculateDiscount(total) ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Địa chỉ giao hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                hintText: 'Nhập địa chỉ giao hàng...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            const Text('Voucher giảm giá', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _voucherController,
                    decoration: InputDecoration(
                      hintText: 'Nhập mã voucher',
                      errorText: _voucherError,
                      border: const OutlineInputBorder(),
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
                child: Text(
                  'Đã áp dụng: ${_appliedVoucher!.code} (-${FormatUtils.formatCurrency(discount)})',
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 25),
            const Text('Ghi chú', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: 'VD: Không hành, ít cay...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            const Text('Phương thức thanh toán', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            RadioListTile<PaymentMethod>(
              title: const Text('Thanh toán khi nhận hàng (COD)'),
              value: PaymentMethod.cod,
              groupValue: _paymentMethod,
              onChanged: (val) => setState(() => _paymentMethod = val!),
            ),
            RadioListTile<PaymentMethod>(
              title: const Text('Ví điện tử'),
              value: PaymentMethod.ewallet,
              groupValue: _paymentMethod,
              onChanged: (val) => setState(() => _paymentMethod = val!),
            ),
            const SizedBox(height: 25),
            const Text('Tóm tắt đơn hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            ...cartProvider.items.where((i) => i.isSelected).map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${item.quantity}x ${item.product.name}'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tổng cộng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Text(FormatUtils.formatCurrency(total - discount), 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isPlacingOrder ? null : () => _placeOrder(user!.id, cartProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isPlacingOrder 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('XÁC NHẬN ĐẶT HÀNG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _placeOrder(int userId, CartProvider cartProvider) async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập địa chỉ')));
      return;
    }

    setState(() => _isPlacingOrder = true);
    try {
      final order = await context.read<OrderProvider>().placeOrder(
        userId: userId,
        items: cartProvider.items.where((i) => i.isSelected).toList(),
        paymentMethod: _paymentMethod,
        address: _addressController.text,
        note: _noteController.text,
        voucher: _appliedVoucher,
      );
      
      // Clear selected items in cart
      final user = context.read<AuthProvider>().currentUser;
      await cartProvider.clearSelected(user!.phone);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đặt hàng thành công!')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TrackingOrderScreen(orderId: order.orderId),
          ),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }
}
