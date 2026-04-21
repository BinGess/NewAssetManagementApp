import 'enums.dart';

class Expense {
  final int id;
  final String name;
  final double amount;
  final ExpenseCycle cycle;
  final int personId;
  final DateTime date;
  final String? notes;

  const Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.cycle,
    required this.personId,
    required this.date,
    this.notes,
  });

  /// Normalized monthly amount for comparison and totalling
  double get monthlyAmount => switch (cycle) {
        ExpenseCycle.daily => amount * 30,
        ExpenseCycle.weekly => amount * (52 / 12),
        ExpenseCycle.monthly => amount,
        ExpenseCycle.yearly => amount / 12,
      };

  Expense copyWith({
    int? id,
    String? name,
    double? amount,
    ExpenseCycle? cycle,
    int? personId,
    DateTime? date,
    Object? notes = _sentinel,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      cycle: cycle ?? this.cycle,
      personId: personId ?? this.personId,
      date: date ?? this.date,
      notes: notes == _sentinel ? this.notes : notes as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Expense && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

const _sentinel = Object();
