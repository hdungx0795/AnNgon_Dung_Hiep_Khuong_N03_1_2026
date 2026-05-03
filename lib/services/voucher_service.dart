import 'package:hive_flutter/hive_flutter.dart';
import '../models/voucher_model.dart';
import 'database_service.dart';

class VoucherService {
  static final VoucherService _instance = VoucherService._();
  factory VoucherService() => _instance;
  VoucherService._();

  final Box<VoucherModel> _vouchersBox = Hive.box<VoucherModel>(DatabaseService.vouchersBoxName);

  List<VoucherModel> getAvailableVouchers() {
    return _vouchersBox.values.where((v) => !v.isExpired).toList();
  }

  VoucherModel? getVoucherByCode(String code) {
    try {
      return _vouchersBox.get(code);
    } catch (e) {
      return null;
    }
  }

  VoucherModel? validateVoucher(String code, int orderTotal) {
    final voucher = getVoucherByCode(code);
    if (voucher == null) return null;
    if (voucher.isExpired) return null;
    if (orderTotal < voucher.minOrderAmount) return null;
    return voucher;
  }
}
