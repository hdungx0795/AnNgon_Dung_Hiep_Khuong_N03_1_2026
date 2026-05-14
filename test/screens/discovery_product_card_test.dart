import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/models/enums/category.dart';
import 'package:pka_food/models/product_model.dart';
import 'package:pka_food/screens/home/widgets/discovery_product_card.dart';

void main() {
  testWidgets('DiscoveryProductCard renders product info and image fallback', (
    tester,
  ) async {
    final product = ProductModel(
      id: 99,
      name: 'Missing Image Product',
      category: Category.food,
      price: 42000,
      rating: 4.8,
      imagePath: 'assets/images/products/missing-image.png',
      description: 'Test',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 220,
            height: 300,
            child: DiscoveryProductCard(product: product, onTap: () {}),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Missing Image Product'), findsOneWidget);
    expect(find.text('Đồ ăn'), findsOneWidget);
    expect(find.byKey(const Key('app-image-placeholder')), findsOneWidget);
  });
}
