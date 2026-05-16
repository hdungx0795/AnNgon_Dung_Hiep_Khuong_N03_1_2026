import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/services/admin_auth_service.dart';

void main() {
  test('validates the single hardcoded admin credential only', () {
    final service = AdminAuthService();

    expect(
      service.validateCredentials('admin@anngon.local', 'admin123'),
      isTrue,
    );
    expect(
      service.validateCredentials('ADMIN@ANNGON.LOCAL', 'admin123'),
      isTrue,
    );
    expect(service.validateCredentials('admin@anngon.local', 'wrong'), isFalse);
    expect(
      service.validateCredentials('user@example.com', 'admin123'),
      isFalse,
    );
  });
}
