import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/providers/auth_provider.dart';
import 'package:pka_food/providers/cart_provider.dart';
import 'package:pka_food/providers/favorites_provider.dart';
import 'package:pka_food/providers/order_provider.dart';
import 'package:pka_food/screens/auth/forgot_password_screen.dart';
import 'package:pka_food/screens/auth/login_screen.dart';
import 'package:pka_food/screens/auth/register_screen.dart';
import 'package:pka_food/services/auth_service.dart';
import 'package:pka_food/services/cart_service.dart';
import 'package:pka_food/services/order_service.dart';
import 'package:pka_food/services/prefs_service.dart';
import 'package:provider/provider.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;

  setUp(() async {
    hiveDirectory = await setUpTestHive();
  });

  tearDown(() async {
    await tearDownTestHive(hiveDirectory);
  });

  testWidgets('login uses inline field validation', (tester) async {
    await tester.pumpWidget(_authTestApp(const LoginScreen()));

    await tester.tap(find.text('Đăng nhập'));
    await tester.pump();

    expect(find.text('Vui lòng nhập số điện thoại'), findsOneWidget);
    expect(find.text('Vui lòng nhập mật khẩu'), findsOneWidget);
  });

  testWidgets('register validates confirm password match', (tester) async {
    await tester.pumpWidget(_authTestApp(const RegisterScreen()));

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Họ và tên'),
      'An',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Số điện thoại'),
      '0123456789',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'an@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mật khẩu'),
      'secret1',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nhập lại mật khẩu'),
      'secret2',
    );
    final registerButton = find.widgetWithText(FilledButton, 'Đăng ký');
    await tester.scrollUntilVisible(
      registerButton,
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(registerButton);
    await tester.pump();

    expect(find.text('Mật khẩu nhập lại không khớp'), findsOneWidget);
  });

  testWidgets('forgot password validates confirm password match', (
    tester,
  ) async {
    await tester.pumpWidget(_authTestApp(const ForgotPasswordScreen()));

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Số điện thoại'),
      '0123456789',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mật khẩu mới'),
      'secret1',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nhập lại mật khẩu mới'),
      'secret2',
    );
    final resetButton = find.widgetWithText(FilledButton, 'Đặt lại mật khẩu');
    await tester.scrollUntilVisible(
      resetButton,
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(resetButton);
    await tester.pump();

    expect(find.text('Mật khẩu nhập lại không khớp'), findsOneWidget);
  });
}

Widget _authTestApp(Widget child) {
  return MultiProvider(
    providers: [
      Provider(create: (_) => AuthService()),
      Provider(create: (_) => CartService()),
      Provider(create: (_) => OrderService()),
      Provider(create: (_) => PrefsService()),
      ChangeNotifierProvider(
        create: (context) => AuthProvider(context.read<AuthService>()),
      ),
      ChangeNotifierProvider(
        create: (context) => CartProvider(context.read<CartService>()),
      ),
      ChangeNotifierProvider(
        create: (context) => FavoritesProvider(context.read<PrefsService>()),
      ),
      ChangeNotifierProvider(
        create: (context) => OrderProvider(context.read<OrderService>()),
      ),
    ],
    child: MaterialApp(
      routes: {
        '/register': (_) => const RegisterScreen(),
        '/forgot-password': (_) => const ForgotPasswordScreen(),
        '/home': (_) => const Scaffold(body: Text('Home')),
      },
      home: child,
    ),
  );
}
