import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pka_food/core/theme/app_theme.dart';
import 'package:pka_food/models/user_model.dart';
import 'package:pka_food/models/user_prefs_model.dart';
import 'package:pka_food/providers/auth_provider.dart';
import 'package:pka_food/providers/theme_provider.dart';
import 'package:pka_food/screens/profile/change_password_screen.dart';
import 'package:pka_food/screens/profile/edit_profile_screen.dart';
import 'package:pka_food/screens/profile/profile_screen.dart';
import 'package:pka_food/services/auth_service.dart';
import 'package:pka_food/services/database_service.dart';
import 'package:pka_food/services/prefs_service.dart';
import 'package:provider/provider.dart';

import '../test_hive.dart';

void main() {
  late Directory hiveDirectory;
  late _TestAuthProvider authProvider;
  late _TestThemeProvider themeProvider;

  setUpAll(() async {
    hiveDirectory = await setUpTestHive();
  });

  setUp(() async {
    await Hive.box<UserModel>(DatabaseService.usersBoxName).clear();
    await Hive.box(DatabaseService.sessionBoxName).clear();
    await Hive.box<UserPrefsModel>(DatabaseService.userPrefsBoxName).clear();
    authProvider = _TestAuthProvider();
    themeProvider = _TestThemeProvider();
  });

  tearDown(() {
    authProvider.dispose();
    themeProvider.dispose();
  });

  tearDownAll(() async {
    await tearDownTestHive(hiveDirectory);
  });

  testWidgets('guest profile renders login call to action', (tester) async {
    await _pumpProfileApp(
      tester,
      const ProfileScreen(),
      authProvider,
      themeProvider,
    );

    expect(find.byKey(const Key('profile-guest-state')), findsOneWidget);
    expect(find.text('Đăng nhập để xem hồ sơ'), findsOneWidget);
    expect(find.text('Đăng nhập ngay'), findsOneWidget);
  });

  testWidgets('authenticated profile renders account summary and menu', (
    tester,
  ) async {
    authProvider.setUser(_testUser());

    await _pumpProfileApp(
      tester,
      const ProfileScreen(),
      authProvider,
      themeProvider,
    );

    expect(
      find.byKey(const Key('profile-authenticated-header')),
      findsOneWidget,
    );
    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('0900000001'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.byKey(const Key('profile-menu-section')), findsOneWidget);
    expect(find.text('Thông tin cá nhân'), findsOneWidget);
    expect(find.text('Đổi mật khẩu'), findsOneWidget);
    expect(find.byKey(const Key('profile-theme-switch')), findsOneWidget);
  });

  testWidgets('profile screen renders in dark theme', (tester) async {
    authProvider.setUser(_testUser());
    themeProvider.setDarkMode(true);

    await _pumpProfileApp(
      tester,
      const ProfileScreen(),
      authProvider,
      themeProvider,
    );

    expect(
      find.byKey(const Key('profile-authenticated-header')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('profile-theme-switch')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('logout waits for async completion before navigating', (
    tester,
  ) async {
    authProvider
      ..setUser(_testUser())
      ..holdLogout();

    await _pumpProfileApp(
      tester,
      const ProfileScreen(),
      authProvider,
      themeProvider,
    );

    await tester.ensureVisible(find.text('Đăng xuất'));
    await tester.tap(find.text('Đăng xuất'));
    await tester.pump();

    expect(authProvider.logoutCallCount, 1);
    expect(find.text('Login route'), findsNothing);

    authProvider.completeHeldLogout();
    await tester.pumpAndSettle();

    expect(find.text('Login route'), findsOneWidget);
    expect(authProvider.currentUser, isNull);
  });

  testWidgets('edit profile validates required name and email format', (
    tester,
  ) async {
    authProvider.setUser(_testUser());
    await _pumpProfileApp(
      tester,
      const EditProfileScreen(),
      authProvider,
      themeProvider,
    );

    await tester.enterText(find.widgetWithText(TextFormField, 'Họ và tên'), '');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'invalid-email',
    );
    await tester.tap(find.byKey(const Key('edit-profile-save-button')));
    await tester.pump();

    expect(find.text('Vui lòng nhập tên'), findsOneWidget);
    expect(find.text('Email không hợp lệ'), findsOneWidget);
  });

  testWidgets('edit profile saves through existing auth provider path', (
    tester,
  ) async {
    authProvider.setUser(_testUser());
    await _pumpProfileApp(
      tester,
      const EditProfileScreen(),
      authProvider,
      themeProvider,
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Họ và tên'),
      'Updated User',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'updated@example.com',
    );
    await tester.tap(find.byKey(const Key('edit-profile-save-button')));
    await tester.pumpAndSettle();

    expect(authProvider.currentUser?.name, 'Updated User');
    expect(authProvider.currentUser?.email, 'updated@example.com');
    expect(authProvider.updateProfileCallCount, 1);
  });

  testWidgets('change password success shows SnackBar on parent profile', (tester) async {
    authProvider.setUser(_testUser());
    await _pumpProfileApp(
      tester,
      const ProfileScreen(),
      authProvider,
      themeProvider,
    );

    await tester.tap(find.text('Đổi mật khẩu'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mật khẩu cũ'),
      'secret1',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mật khẩu mới'),
      'secret2',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Xác nhận mật khẩu mới'),
      'secret2',
    );
    await tester.tap(find.byKey(const Key('change-password-submit-button')));
    await tester.pumpAndSettle();

    expect(find.text('Đổi mật khẩu thành công!'), findsOneWidget);
    expect(authProvider.changePasswordCallCount, 1);
  });

  testWidgets('notification dialog opens and toggles state', (tester) async {
    authProvider.setUser(_testUser());
    await _pumpProfileApp(
      tester,
      const ProfileScreen(),
      authProvider,
      themeProvider,
    );

    await tester.tap(find.text('Thông báo'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('notification-settings-dialog')), findsOneWidget);
    expect(find.text('Bật thông báo để nhận cập nhật đơn hàng và ưu đãi hấp dẫn.'), findsOneWidget);
    
    await tester.tap(find.byKey(const Key('notification-enable-button')));
    await tester.pumpAndSettle();

    expect(find.text('Thông báo đơn hàng'), findsOneWidget);
    expect(find.text('Deal / Khuyến mãi hot'), findsOneWidget);
    
    await tester.tap(find.byKey(const Key('notification-disable-button')));
    await tester.pumpAndSettle();
    
    expect(find.text('Bật thông báo để nhận cập nhật đơn hàng và ưu đãi hấp dẫn.'), findsOneWidget);
  });

  testWidgets('help center dialog opens with static content', (tester) async {
    authProvider.setUser(_testUser());
    await _pumpProfileApp(
      tester,
      const ProfileScreen(),
      authProvider,
      themeProvider,
    );

    await tester.tap(find.text('Trung tâm trợ giúp'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('help-center-dialog')), findsOneWidget);
    expect(find.text('1900-6868'), findsOneWidget);
    expect(find.text('support@pkafood.vn'), findsOneWidget);
  });

  testWidgets('change password validates confirm password mismatch', (
    tester,
  ) async {
    authProvider.setUser(_testUser());
    await _pumpProfileApp(
      tester,
      const ChangePasswordScreen(),
      authProvider,
      themeProvider,
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mật khẩu cũ'),
      'secret1',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mật khẩu mới'),
      'secret2',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Xác nhận mật khẩu mới'),
      'secret3',
    );
    await tester.tap(find.byKey(const Key('change-password-submit-button')));
    await tester.pump();

    expect(find.text('Mật khẩu xác nhận không khớp'), findsOneWidget);
  });

  testWidgets('change password failure shows existing provider error', (
    tester,
  ) async {
    authProvider
      ..setUser(_testUser())
      ..changePasswordResult = false
      ..changePasswordError = 'Mật khẩu cũ không chính xác';
    await _pumpProfileApp(
      tester,
      const ChangePasswordScreen(),
      authProvider,
      themeProvider,
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mật khẩu cũ'),
      'wrong-password',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mật khẩu mới'),
      'secret2',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Xác nhận mật khẩu mới'),
      'secret2',
    );
    await tester.tap(find.byKey(const Key('change-password-submit-button')));
    await tester.pumpAndSettle();

    expect(find.text('Mật khẩu cũ không chính xác'), findsOneWidget);
  });
}

Future<void> _pumpProfileApp(
  WidgetTester tester,
  Widget child,
  AuthProvider authProvider,
  ThemeProvider themeProvider,
) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: theme.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routes: {
              '/login': (_) => const Scaffold(body: Text('Login route')),
            },
            home: child,
          );
        },
      ),
    ),
  );
}

UserModel _testUser() {
  return UserModel(
    id: 1,
    name: 'Test User',
    phone: '0900000001',
    email: 'test@example.com',
    dob: '01/01/2000',
    passwordHash: 'hash',
    createdAt: DateTime(2026, 5, 14),
  );
}

class _TestAuthProvider extends AuthProvider {
  _TestAuthProvider() : super(AuthService());

  UserModel? _user;
  String? _error;
  bool updateProfileResult = true;
  bool changePasswordResult = true;
  String? changePasswordError;
  int updateProfileCallCount = 0;
  int changePasswordCallCount = 0;
  int logoutCallCount = 0;
  Completer<void>? _logoutCompleter;

  void setUser(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  void holdLogout() {
    _logoutCompleter = Completer<void>();
  }

  void completeHeldLogout() {
    _logoutCompleter?.complete();
  }

  @override
  UserModel? get currentUser => _user;

  @override
  String? get error => _error;

  @override
  bool get isAuthenticated => _user != null;

  @override
  Future<void> logout() async {
    logoutCallCount++;
    await _logoutCompleter?.future;
    _user = null;
    notifyListeners();
  }

  @override
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? avatarPath,
  }) async {
    updateProfileCallCount++;
    if (_user == null || !updateProfileResult) return false;
    _user = _user!.copyWith(name: name, email: email, avatarPath: avatarPath);
    notifyListeners();
    return true;
  }

  @override
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    changePasswordCallCount++;
    _error = changePasswordResult ? null : changePasswordError;
    notifyListeners();
    return changePasswordResult;
  }
}

class _TestThemeProvider extends ThemeProvider {
  _TestThemeProvider() : super(PrefsService());

  bool _isDarkMode = false;
  int toggleThemeCallCount = 0;

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  @override
  bool get isDarkMode => _isDarkMode;

  @override
  Future<void> toggleTheme() async {
    toggleThemeCallCount++;
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
