class Liability {
  final int id;
  final String name;
  final int typeId;
  final double amount;
  final double? interestRate;
  final DateTime? dueDate;
  final String currency;
  final String? notes;

  const Liability({
    required this.id,
    required this.name,
    required this.typeId,
    required this.amount,
    required this.currency,
    this.interestRate,
    this.dueDate,
    this.notes,
  });

  /// Whether this liability is past its due date
  bool get isOverdue => dueDate != null && dueDate!.isBefore(DateTime.now());

  Liability copyWith({
    int? id,
    String? name,
    int? typeId,
    double? amount,
    double? interestRate,
    DateTime? dueDate,
    String? currency,
    String? notes,
  }) {
    return Liability(
      id: id ?? this.id,
      name: name ?? this.name,
      typeId: typeId ?? this.typeId,
      amount: amount ?? this.amount,
      interestRate: interestRate ?? this.interestRate,
      dueDate: dueDate ?? this.dueDate,
      currency: currency ?? this.currency,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Liability && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
