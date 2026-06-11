import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/widgets/app_widgets.dart';

void main() {
  testWidgets('shared foundation widgets render basic content', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              const SectionHeader(title: 'Popular', subtitle: 'Today'),
              const PriceText(amount: 45000),
              AppTextField(labelText: 'Search', prefixIcon: Icons.search),
              PrimaryButton(label: 'Continue', onPressed: () {}),
              SecondaryButton(label: 'Cancel', onPressed: () {}),
              const EmptyState(title: 'Nothing here', message: 'Try again'),
              const LoadingState(message: 'Loading'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            widget.data != null &&
            widget.data!.contains('45.000') &&
            widget.data!.contains('đ'),
      ),
      findsOneWidget,
    );
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Nothing here'), findsOneWidget);
    expect(find.text('Loading'), findsOneWidget);
  });
}
