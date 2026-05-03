import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/app.dart';

import 'test_hive.dart';

void main() {
  late Directory hiveDirectory;

  setUp(() async {
    hiveDirectory = await setUpTestHive();
  });

  tearDown(() async {
    await tearDownTestHive(hiveDirectory);
  });

  testWidgets('PkaFoodApp boots to a MaterialApp without crashing', (tester) async {
    await tester.pumpWidget(const PkaFoodApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
