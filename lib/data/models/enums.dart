enum ExpenseCycle { daily, weekly, monthly, yearly }

extension ExpenseCycleLabel on ExpenseCycle {
  String get label => switch (this) {
        ExpenseCycle.daily => '每天',
        ExpenseCycle.weekly => '每周',
        ExpenseCycle.monthly => '每月',
        ExpenseCycle.yearly => '每年',
      };
}

/// Parse an ExpenseCycle from its string name (e.g. 'monthly' → ExpenseCycle.monthly)
ExpenseCycle expenseCycleFromString(String s) =>
    ExpenseCycle.values.firstWhere((e) => e.name == s);
