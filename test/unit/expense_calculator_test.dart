import 'package:flutter_test/flutter_test.dart';
import 'package:new_asset_management_app/data/models/enums.dart';
import 'package:new_asset_management_app/data/models/expense.dart';

Expense _makeExpense(double amount, ExpenseCycle cycle) => Expense(
      id: 1,
      name: 'Test Expense',
      amount: amount,
      cycle: cycle,
      personId: 1,
      date: DateTime(2024, 1, 1),
    );

void main() {
  group('Expense.monthlyAmount', () {
    test('monthly expense is unchanged', () {
      final expense = _makeExpense(3000, ExpenseCycle.monthly);
      expect(expense.monthlyAmount, 3000.0);
    });

    test('yearly expense is divided by 12', () {
      final expense = _makeExpense(12000, ExpenseCycle.yearly);
      expect(expense.monthlyAmount, closeTo(1000.0, 0.01));
    });

    test('daily expense is multiplied by 30', () {
      final expense = _makeExpense(100, ExpenseCycle.daily);
      expect(expense.monthlyAmount, closeTo(3000.0, 0.01));
    });

    test('weekly expense uses 52/12 factor', () {
      final expense = _makeExpense(1000, ExpenseCycle.weekly);
      // 1000 * 52 / 12 ≈ 4333.33
      expect(expense.monthlyAmount, closeTo(4333.33, 0.1));
    });

    test('monthly total across multiple expenses', () {
      final expenses = [
        _makeExpense(3000, ExpenseCycle.monthly),  // 3000/month
        _makeExpense(36000, ExpenseCycle.yearly),  // 3000/month
        _makeExpense(50, ExpenseCycle.daily),      // 1500/month
      ];
      final total = expenses.fold(0.0, (sum, e) => sum + e.monthlyAmount);
      expect(total, closeTo(7500.0, 0.1));
    });
  });

  group('ExpenseCycle labels', () {
    test('returns correct Chinese labels', () {
      expect(ExpenseCycle.daily.label, '每天');
      expect(ExpenseCycle.weekly.label, '每周');
      expect(ExpenseCycle.monthly.label, '每月');
      expect(ExpenseCycle.yearly.label, '每年');
    });

    test('expenseCycleFromString round-trips correctly', () {
      expect(expenseCycleFromString('daily'), ExpenseCycle.daily);
      expect(expenseCycleFromString('weekly'), ExpenseCycle.weekly);
      expect(expenseCycleFromString('monthly'), ExpenseCycle.monthly);
      expect(expenseCycleFromString('yearly'), ExpenseCycle.yearly);
    });
  });
}
