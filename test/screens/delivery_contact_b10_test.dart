import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/core/theme/app_theme.dart';
import 'package:pka_food/screens/chat/delivery_call_screen.dart';
import 'package:pka_food/screens/chat/delivery_chat_screen.dart';

void main() {
  testWidgets('chat screen renders shipper name and initial mock message', (
    tester,
  ) async {
    await _pumpContactApp(
      tester,
      const DeliveryChatScreen(shipperName: 'Test Shipper'),
    );

    expect(find.byKey(const Key('delivery-chat-shipper-name')), findsOneWidget);
    expect(find.text('Test Shipper'), findsOneWidget);
    expect(find.text('Chào bạn, tôi đang lấy hàng.'), findsOneWidget);
  });

  testWidgets('chat screen sends non-empty message and clears input', (
    tester,
  ) async {
    await _pumpContactApp(
      tester,
      const DeliveryChatScreen(shipperName: 'Test Shipper'),
    );

    await tester.enterText(
      find.byKey(const Key('delivery-chat-input')),
      'Tôi chờ ở cổng chính',
    );
    await tester.tap(find.byKey(const Key('delivery-chat-send-button')));
    await tester.pump();

    expect(find.text('Tôi chờ ở cổng chính'), findsOneWidget);

    final textField = tester.widget<TextField>(
      find.byKey(const Key('delivery-chat-input')),
    );
    expect(textField.controller?.text, isEmpty);
  });

  testWidgets('chat screen rejects whitespace and empty messages', (
    tester,
  ) async {
    await _pumpContactApp(
      tester,
      const DeliveryChatScreen(shipperName: 'Test Shipper'),
    );

    expect(
      find.byKey(const Key('delivery-chat-message-shipper')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('delivery-chat-message-me')), findsNothing);

    await tester.tap(find.byKey(const Key('delivery-chat-send-button')));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('delivery-chat-input')), '   ');
    await tester.tap(find.byKey(const Key('delivery-chat-send-button')));
    await tester.pump();

    expect(
      find.byKey(const Key('delivery-chat-message-shipper')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('delivery-chat-message-me')), findsNothing);
  });

  testWidgets('chat screen disposes controller safely when removed', (
    tester,
  ) async {
    await _pumpContactApp(
      tester,
      const DeliveryChatScreen(shipperName: 'Test Shipper'),
    );

    await tester.enterText(
      find.byKey(const Key('delivery-chat-input')),
      'Tin nhắn tạm',
    );
    await tester.pumpWidget(const SizedBox.shrink());

    expect(tester.takeException(), isNull);
  });

  testWidgets('call screen renders shipper and controls', (tester) async {
    await _pumpContactApp(
      tester,
      const DeliveryCallScreen(shipperName: 'Test Shipper'),
    );

    expect(find.byKey(const Key('delivery-call-shipper-name')), findsOneWidget);
    expect(find.text('Test Shipper'), findsOneWidget);
    expect(find.byKey(const Key('delivery-call-status')), findsOneWidget);
    expect(find.text('Đang gọi...'), findsOneWidget);
    expect(find.text('Tắt tiếng'), findsOneWidget);
    expect(find.text('Loa ngoài'), findsOneWidget);
    expect(find.text('Video'), findsOneWidget);
    expect(find.byKey(const Key('delivery-call-end-button')), findsOneWidget);
  });

  testWidgets('call screen end button pops route', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const DeliveryCallScreen(shipperName: 'Test Shipper'),
                    ),
                  );
                },
                child: const Text('Open call'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open call'));
    await tester.pumpAndSettle();
    expect(find.byType(DeliveryCallScreen), findsOneWidget);

    await tester.tap(find.byKey(const Key('delivery-call-end-button')));
    await tester.pumpAndSettle();

    expect(find.byType(DeliveryCallScreen), findsNothing);
    expect(find.text('Open call'), findsOneWidget);
  });

  testWidgets('contact screens render in dark mode', (tester) async {
    await _pumpContactApp(
      tester,
      const DeliveryChatScreen(shipperName: 'Dark Shipper'),
      themeMode: ThemeMode.dark,
    );

    expect(find.text('Dark Shipper'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await _pumpContactApp(
      tester,
      const DeliveryCallScreen(shipperName: 'Dark Shipper'),
      themeMode: ThemeMode.dark,
    );

    expect(find.text('Dark Shipper'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpContactApp(
  WidgetTester tester,
  Widget child, {
  ThemeMode themeMode = ThemeMode.light,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: child,
    ),
  );
}
