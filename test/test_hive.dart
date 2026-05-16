import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:pka_food/models/admin_product_model.dart';
import 'package:pka_food/models/cart_item_model.dart';
import 'package:pka_food/models/chat_message_model.dart';
import 'package:pka_food/models/enums/admin_image_preset.dart';
import 'package:pka_food/models/enums/category.dart';
import 'package:pka_food/models/enums/order_status.dart';
import 'package:pka_food/models/enums/payment_method.dart';
import 'package:pka_food/models/order_item_model.dart';
import 'package:pka_food/models/order_model.dart';
import 'package:pka_food/models/product_model.dart';
import 'package:pka_food/models/review_model.dart';
import 'package:pka_food/models/user_model.dart';
import 'package:pka_food/models/user_prefs_model.dart';
import 'package:pka_food/models/voucher_model.dart';
import 'package:pka_food/services/database_service.dart';

Future<Directory> setUpTestHive() async {
  final directory = await Directory.systemTemp.createTemp('pka_food_test_');
  Hive.init(directory.path);
  _registerAdapters();
  await _openBoxes();
  return directory;
}

Future<void> tearDownTestHive(Directory directory) async {
  await Hive.close();
  if (directory.existsSync()) {
    await directory.delete(recursive: true);
  }
}

void _registerAdapters() {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(UserModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ProductModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(OrderModelAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(ReviewModelAdapter());
  }
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(CategoryAdapter());
  }
  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(PaymentMethodAdapter());
  }
  if (!Hive.isAdapterRegistered(6)) {
    Hive.registerAdapter(OrderItemModelAdapter());
  }
  if (!Hive.isAdapterRegistered(7)) {
    Hive.registerAdapter(OrderStatusAdapter());
  }
  if (!Hive.isAdapterRegistered(8)) {
    Hive.registerAdapter(CartItemModelAdapter());
  }
  if (!Hive.isAdapterRegistered(9)) {
    Hive.registerAdapter(UserPrefsModelAdapter());
  }
  if (!Hive.isAdapterRegistered(10)) {
    Hive.registerAdapter(VoucherModelAdapter());
  }
  if (!Hive.isAdapterRegistered(11)) {
    Hive.registerAdapter(ChatMessageModelAdapter());
  }
  if (!Hive.isAdapterRegistered(12)) {
    Hive.registerAdapter(AdminProductModelAdapter());
  }
  if (!Hive.isAdapterRegistered(13)) {
    Hive.registerAdapter(AdminImagePresetAdapter());
  }
}

Future<void> _openBoxes() async {
  await Hive.openBox<UserModel>(DatabaseService.usersBoxName);
  await Hive.openBox<ProductModel>(DatabaseService.productsBoxName);
  await Hive.openBox<AdminProductModel>(DatabaseService.adminProductsBoxName);
  await Hive.openBox<OrderModel>(DatabaseService.ordersBoxName);
  await Hive.openBox(DatabaseService.cartBoxName);
  await Hive.openBox<ReviewModel>(DatabaseService.reviewsBoxName);
  await Hive.openBox<VoucherModel>(DatabaseService.vouchersBoxName);
  await Hive.openBox<UserPrefsModel>(DatabaseService.userPrefsBoxName);
  await Hive.openBox(DatabaseService.sessionBoxName);
}

ProductModel testProduct({
  int id = 1,
  String name = 'Test Burger',
  int price = 25000,
  Category category = Category.food,
}) {
  return ProductModel(
    id: id,
    name: name,
    category: category,
    price: price,
    rating: 4.5,
    imagePath: 'assets/images/products/PKA.png',
    description: 'Test product',
  );
}
