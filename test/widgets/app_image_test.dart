import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/widgets/app_image.dart';

void main() {
  testWidgets('AppImage shows product placeholder for missing asset source', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppImage.asset(
            '',
            width: 80,
            height: 80,
            fallbackKind: AppImageFallbackKind.product,
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('app-image-placeholder')), findsOneWidget);
    expect(find.byIcon(Icons.fastfood_outlined), findsOneWidget);
  });

  testWidgets('AppImage placeholder is dark-mode safe', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(useMaterial3: true),
        home: const Scaffold(
          body: AppImage.placeholder(
            width: 100,
            height: 60,
            fallbackKind: AppImageFallbackKind.banner,
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('app-image-placeholder')), findsOneWidget);
    expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
