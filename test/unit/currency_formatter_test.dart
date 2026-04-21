import 'package:flutter_test/flutter_test.dart';
import 'package:new_asset_management_app/core/utils/currency_formatter.dart';

void main() {
  group('formatCNY', () {
    test('formats amounts less than 10000 as plain currency', () {
      expect(formatCNY(999.5), '¥999.50');
      expect(formatCNY(0), '¥0.00');
      expect(formatCNY(9999.99), '¥9999.99');
    });

    test('formats amounts >= 10000 in 万 units', () {
      expect(formatCNY(10000), '¥1.00万');
      expect(formatCNY(12340), '¥1.23万');
      expect(formatCNY(50000), '¥5.00万');
      expect(formatCNY(9999000), '¥999.90万');
    });

    test('formats amounts >= 100000000 in 亿 units', () {
      expect(formatCNY(100000000), '¥1.00亿');
      expect(formatCNY(250000000), '¥2.50亿');
    });

    test('handles negative amounts', () {
      expect(formatCNY(-12340), '-¥1.23万');
      expect(formatCNY(-999), '-¥999.00');
    });
  });

  group('formatRate', () {
    test('formats decimal rate as percentage', () {
      expect(formatRate(0.03), '3.00%');
      expect(formatRate(0.045), '4.50%');
      expect(formatRate(0.0), '0.00%');
    });
  });
}
