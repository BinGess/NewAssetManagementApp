import 'package:flutter_test/flutter_test.dart';
import 'package:new_asset_management_app/data/models/asset.dart';

void main() {
  final baseDate = DateTime(2024, 1, 1);
  final startDate = DateTime(2023, 1, 1); // 366 days before baseDate (2023 is not a leap year, use 365 days)

  group('Asset earnings calculations', () {
    test('returns null for assets without annual rate', () {
      final asset = Asset(
        id: 1,
        name: 'Test',
        typeId: 1,
        amount: 100000,
        currency: 'CNY',
        valuationDate: baseDate,
      );
      expect(asset.dailyEarnings, isNull);
      expect(asset.monthlyEarnings, isNull);
      expect(asset.yearlyEarnings, isNull);
      expect(asset.cumulativeEarnings, isNull);
    });

    test('calculates daily earnings correctly', () {
      final asset = Asset(
        id: 1,
        name: 'Money Fund',
        typeId: 3,
        amount: 100000,
        currency: 'CNY',
        valuationDate: baseDate,
        annualRate: 0.03, // 3%
      );
      // 100000 * 0.03 / 365 ≈ 8.22
      expect(asset.dailyEarnings, closeTo(8.22, 0.01));
    });

    test('calculates monthly earnings correctly', () {
      final asset = Asset(
        id: 1,
        name: 'Money Fund',
        typeId: 3,
        amount: 100000,
        currency: 'CNY',
        valuationDate: baseDate,
        annualRate: 0.03, // 3%
      );
      // 100000 * 0.03 / 12 = 250
      expect(asset.monthlyEarnings, closeTo(250.0, 0.01));
    });

    test('calculates yearly earnings correctly', () {
      final asset = Asset(
        id: 1,
        name: 'Money Fund',
        typeId: 3,
        amount: 100000,
        currency: 'CNY',
        valuationDate: baseDate,
        annualRate: 0.03, // 3%
      );
      // 100000 * 0.03 = 3000
      expect(asset.yearlyEarnings, closeTo(3000.0, 0.01));
    });
  });

  group('Asset copyWith', () {
    test('copies all fields when no overrides', () {
      final asset = Asset(
        id: 1,
        name: 'Test',
        typeId: 2,
        amount: 5000,
        currency: 'CNY',
        valuationDate: baseDate,
        notes: 'original note',
      );
      final copy = asset.copyWith();
      expect(copy.id, 1);
      expect(copy.name, 'Test');
      expect(copy.notes, 'original note');
    });

    test('can clear nullable fields with explicit null', () {
      final asset = Asset(
        id: 1,
        name: 'Test',
        typeId: 2,
        amount: 5000,
        currency: 'CNY',
        valuationDate: baseDate,
        notes: 'some note',
      );
      final cleared = asset.copyWith(notes: null);
      expect(cleared.notes, isNull);
    });
  });
}
