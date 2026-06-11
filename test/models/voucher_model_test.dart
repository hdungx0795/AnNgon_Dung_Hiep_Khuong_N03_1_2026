import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/models/voucher_model.dart';

void main() {
  group('VoucherModel', () {
    test('applies fixed discount only when min order is reached', () {
      final voucher = VoucherModel(
        code: 'FIXED10',
        discountAmount: 10000,
        discountPercent: 0,
        minOrderAmount: 50000,
        expiresAt: DateTime(2030),
      );

      expect(voucher.calculateDiscount(40000), 0);
      expect(voucher.calculateDiscount(50000), 10000);
      expect(voucher.calculateDiscount(125000), 10000);
    });

    test('applies percent discount only when min order is reached', () {
      final voucher = VoucherModel(
        code: 'PERCENT20',
        discountAmount: 0,
        discountPercent: 0.2,
        minOrderAmount: 80000,
        expiresAt: DateTime(2030),
      );

      expect(voucher.calculateDiscount(79000), 0);
      expect(voucher.calculateDiscount(100000), 20000);
    });

    test('toJson and fromJson round-trip matches original values', () {
      final voucher = VoucherModel(
        code: 'VOUCHER50',
        discountAmount: 50000,
        discountPercent: 0.1,
        minOrderAmount: 200000,
        expiresAt: DateTime(2026, 12, 31, 23, 59, 59),
      );

      final jsonMap = voucher.toJson();
      final roundTripVoucher = VoucherModel.fromJson(jsonMap);

      expect(roundTripVoucher.code, voucher.code);
      expect(roundTripVoucher.discountAmount, voucher.discountAmount);
      expect(roundTripVoucher.discountPercent, voucher.discountPercent);
      expect(roundTripVoucher.minOrderAmount, voucher.minOrderAmount);
      expect(roundTripVoucher.expiresAt, voucher.expiresAt);
    });
  });
}
