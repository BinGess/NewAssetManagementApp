import 'package:flutter_test/flutter_test.dart';
import 'package:new_asset_management_app/data/services/backend_asset_api.dart';
import 'package:new_asset_management_app/providers/dashboard_provider.dart';

void main() {
  group('buildBackendDashboardSummary', () {
    test('calculates net worth, type totals, and monthly expenses', () {
      final summary = buildBackendDashboardSummary(
        assets: [
          BackendAsset(
            id: 'asset-1',
            name: '活期',
            typeId: 'cash',
            amount: '1000.00',
            currency: 'CNY',
            valuationDate: DateTime.utc(2026, 6, 23),
            version: 1,
          ),
          BackendAsset(
            id: 'asset-2',
            name: '基金',
            typeId: 'fund',
            amount: '2500.50',
            currency: 'CNY',
            valuationDate: DateTime.utc(2026, 6, 23),
            version: 1,
          ),
        ],
        liabilities: [
          const BackendLiability(
            id: 'liability-1',
            name: '信用卡',
            typeId: 'credit',
            amount: '700.25',
            currency: 'CNY',
            version: 1,
          ),
        ],
        assetTypes: const [
          BackendType(
            id: 'cash',
            code: 'cash',
            label: '现金',
            enabled: true,
            sortOrder: 0,
            version: 1,
          ),
          BackendType(
            id: 'fund',
            code: 'fund',
            label: '基金',
            enabled: true,
            sortOrder: 1,
            version: 1,
          ),
        ],
        liabilityTypes: const [
          BackendType(
            id: 'credit',
            code: 'credit',
            label: '信用卡',
            enabled: true,
            sortOrder: 0,
            version: 1,
          ),
        ],
        expenses: [
          BackendExpense(
            id: 'expense-1',
            name: '房租',
            amount: '3000',
            cycle: 'MONTHLY',
            personId: 'person-1',
            date: DateTime.utc(2026, 6, 23),
            version: 1,
          ),
          BackendExpense(
            id: 'expense-2',
            name: '保险',
            amount: '12000',
            cycle: 'YEARLY',
            personId: 'person-1',
            date: DateTime.utc(2026, 6, 23),
            version: 1,
          ),
        ],
      );

      expect(summary.totalAssets, 3500.5);
      expect(summary.totalLiabilities, 700.25);
      expect(summary.netWorth, 2800.25);
      expect(summary.monthlyExpenses, 4000);
      expect(summary.assetsByType.map((t) => (t.typeId, t.label, t.total)), [
        ('cash', '现金', 1000.0),
        ('fund', '基金', 2500.5),
      ]);
      expect(summary.liabilitiesByType.single.label, '信用卡');
    });
  });
}
