import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/models/cart_item_model.dart';

import '../test_hive.dart';

void main() {
  test('CartItemModel totalPrice multiplies product price by quantity', () {
    final item = CartItemModel(product: testProduct(price: 25000), quantity: 3);

    expect(item.totalPrice, 75000);
  });
}
