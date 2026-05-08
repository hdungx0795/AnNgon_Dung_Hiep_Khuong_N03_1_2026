import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/providers/cart_provider.dart';
import 'package:pka_food/services/cart_service.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;

  setUp(() async {
    hiveDirectory = await setUpTestHive();
  });

  tearDown(() async {
    await tearDownTestHive(hiveDirectory);
  });

  test('CartProvider supports load, add, update quantity, and clear cart', () async {
    final provider = CartProvider(CartService());
    const phone = '0900000000';
    final product = testProduct(price: 30000);

    await provider.loadCart(phone);
    expect(provider.itemCount, 0);

    await provider.addItem(phone, product, 2);
    expect(provider.itemCount, 1);
    expect(provider.totalAmount, 60000);

    await provider.updateQuantity(phone, product.id, 3);
    expect(provider.itemCount, 1);
    expect(provider.totalAmount, 90000);

    await provider.clearCart(phone);
    expect(provider.itemCount, 0);
    expect(provider.totalAmount, 0);
  });
}
