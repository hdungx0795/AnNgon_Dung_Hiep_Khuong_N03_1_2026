import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../models/voucher_model.dart';
import '../core/utils/hash_utils.dart';
import 'database_service.dart';

class SeedingService {
  static Future<void> seedAll({FirebaseFirestore? firestore}) async {
    final productsBox = Hive.box<ProductModel>(DatabaseService.productsBoxName);
    final usersBox = Hive.box<UserModel>(DatabaseService.usersBoxName);
    final vouchersBox = Hive.box<VoucherModel>(DatabaseService.vouchersBoxName);

    FirebaseFirestore? fs;
    try {
      fs = firestore ?? FirebaseFirestore.instance;
    } catch (e) {
      // Ignore if no firebase app in tests
    }

    try {
      final String jsonString = await rootBundle.loadString('assets/seeddata.json');
      final Map<String, dynamic> data = json.decode(jsonString);

      // 1. Seed Users
      if (usersBox.isEmpty) {
        final List<dynamic> usersJson = data['users'];
        for (var userJson in usersJson) {
          final user = UserModel(
            id: userJson['id'],
            name: userJson['name'],
            phone: userJson['phone'],
            email: userJson['email'],
            dob: userJson['dob'],
            passwordHash: HashUtils.hashPassword(userJson['password']),
            avatarPath: userJson['avatarPath'],
            createdAt: DateTime.now(),
          );
          await usersBox.put(user.id, user);
        }
      }

      // 2. Seed Products
      final List<dynamic> productsJson = data['products'];
      
      // Seed Hive
      if (productsBox.isEmpty) {
        for (var productJson in productsJson) {
          final product = ProductModel.fromJson(productJson);
          await productsBox.put(product.id, product);
        }
      }

      // Seed Firestore
      if (fs != null) {
        final productsCol = fs.collection('products');
        final snapshot = await productsCol.limit(1).get();
        if (snapshot.docs.isEmpty) {
          for (var productJson in productsJson) {
            final product = ProductModel.fromJson(productJson);
            await productsCol.doc(product.id.toString()).set(product.toJson());
          }
        }
      }

      // 3. Seed Vouchers
      if (vouchersBox.isEmpty) {
        final List<dynamic> vouchersJson = data['vouchers'];
        for (var vJson in vouchersJson) {
          final voucher = VoucherModel(
            code: vJson['code'],
            discountAmount: vJson['discountAmount'],
            discountPercent: vJson['discountPercent'],
            minOrderAmount: vJson['minOrderAmount'],
            expiresAt: DateTime.parse(vJson['expiresAt']),
          );
          await vouchersBox.put(voucher.code, voucher);
        }
      }

    } catch (e) {
      debugPrint('Error seeding data: $e');
    }
  }
}
