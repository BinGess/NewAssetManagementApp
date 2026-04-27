class Asset {
  final int id;
  final String name;
  final int typeId;
  final double amount;
  final String currency;
  final DateTime valuationDate;
  final double? annualRate;
  final DateTime? startDate;
  final String? notes;
  final int? personId;

  const Asset({
    required this.id,
    required this.name,
    required this.typeId,
    required this.amount,
    required this.currency,
    required this.valuationDate,
    this.annualRate,
    this.startDate,
    this.notes,
    this.personId,
  });

  /// Daily earnings based on annual rate (e.g. money market funds)
  double? get dailyEarnings =>
      annualRate != null ? amount * annualRate! / 365 : null;

  /// Monthly earnings based on annual rate
  double? get monthlyEarnings =>
      annualRate != null ? amount * annualRate! / 12 : null;

  /// Yearly earnings based on annual rate
  double? get yearlyEarnings =>
      annualRate != null ? amount * annualRate! : null;

  /// Cumulative earnings from startDate to today
  double? get cumulativeEarnings {
    if (annualRate == null || startDate == null) return null;
    final days = DateTime.now().difference(startDate!).inDays;
    return amount * annualRate! * days / 365;
  }

  Asset copyWith({
    int? id,
    String? name,
    int? typeId,
    double? amount,
    String? currency,
    DateTime? valuationDate,
    Object? annualRate = _sentinel,
    Object? startDate = _sentinel,
    Object? notes = _sentinel,
    Object? personId = _sentinel,
  }) {
    return Asset(
      id: id ?? this.id,
      name: name ?? this.name,
      typeId: typeId ?? this.typeId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      valuationDate: valuationDate ?? this.valuationDate,
      annualRate: annualRate == _sentinel ? this.annualRate : annualRate as double?,
      startDate: startDate == _sentinel ? this.startDate : startDate as DateTime?,
      notes: notes == _sentinel ? this.notes : notes as String?,
      personId: personId == _sentinel ? this.personId : personId as int?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Asset && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Asset(id: $id, name: $name, amount: $amount)';
}

const _sentinel = Object();
