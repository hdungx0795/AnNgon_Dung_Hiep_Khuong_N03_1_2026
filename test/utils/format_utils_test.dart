import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/core/utils/format_utils.dart';

void main() {
  group('FormatUtils', () {
    test('formatCurrency uses Vietnamese thousands separators', () {
      expect(FormatUtils.formatCurrency(0), contains('0'));
      expect(FormatUtils.formatCurrency(1000), contains('1.000'));
      expect(FormatUtils.formatCurrency(125000), contains('125.000'));
    });

    test('formatDate and formatTime use app display formats', () {
      final value = DateTime(2026, 4, 22, 9, 5);

      expect(FormatUtils.formatDate(value), '22/04/2026');
      expect(FormatUtils.formatTime(value), '09:05');
    });
  });
}
