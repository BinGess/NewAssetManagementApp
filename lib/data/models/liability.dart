class Liability {
  final int id;
  final String name;
  final int typeId;
  final double amount;
  final double? interestRate;
  final DateTime? dueDate;
  final String currency;
  final String? notes;
  final int? personId;

  const Liability({
    required this.id,
    required this.name,
    required this.typeId,
    required this.amount,
    required this.currency,
    this.interestRate,
    this.dueDate,
    this.notes,
    this.personId,
  });

  /// Whether this liability is past its due date
  bool get isOverdue => dueDate != null && dueDate!.isBefore(DateTime.now());

  Liability copyWith({
    int? id,
    String? name,
    int? typeId,
    double? amount,
    Object? interestRate = _sentinel,
    Object? dueDate = _sentinel,
    String? currency,
    Object? notes = _sentinel,
    Object? personId = _sentinel,
  }) {
    return Liability(
      id: id ?? this.id,
      name: name ?? this.name,
      typeId: typeId ?? this.typeId,
      amount: amount ?? this.amount,
      interestRate:
          interestRate == _sentinel ? this.interestRate : interestRate as double?,
      dueDate: dueDate == _sentinel ? this.dueDate : dueDate as DateTime?,
      currency: currency ?? this.currency,
      notes: notes == _sentinel ? this.notes : notes as String?,
      personId: personId == _sentinel ? this.personId : personId as int?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Liability && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Liability(id: $id, name: $name, amount: $amount)';
}

const _sentinel = Object();
