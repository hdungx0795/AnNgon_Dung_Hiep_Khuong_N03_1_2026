import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pka_food/models/product_model.dart';
import 'package:pka_food/providers/product_provider.dart';
import 'package:pka_food/screens/home/tabs/explore_tab.dart';
import 'package:pka_food/services/database_service.dart';
import 'package:pka_food/services/product_service.dart';
import 'package:provider/provider.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;

  setUp(() async {
    hiveDirectory = await setUpTestHive();
    final productsBox = Hive.box<ProductModel>(DatabaseService.productsBoxName);
    await productsBox.put(1, testProduct(id: 1, name: 'Test Burger', price: 30000));
    await productsBox.put(2, testProduct(id: 2, name: 'Test Drink', price: 15000));
  });

  tearDown(() async {
    await tearDownTestHive(hiveDirectory);
  });

  testWidgets('ExploreTab renders search and seeded product grid', (tester) async {
    final provider = ProductProvider(ProductService());
    await provider.loadProducts();

    await tester.pumpWidget(
      ChangeNotifierProvider<ProductProvider>.value(
        value: provider,
        child: const MaterialApp(home: Scaffold(body: ExploreTab())),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Test Burger'), findsOneWidget);
    expect(find.text('Test Drink'), findsOneWidget);
  });
}
