class AssetChange {
  final int id;
  final int assetId;
  final double beforeAmount;
  final double afterAmount;
  final DateTime createdAt;
  final String? notes;

  const AssetChange({
    required this.id,
    required this.assetId,
    required this.beforeAmount,
    required this.afterAmount,
    required this.createdAt,
    this.notes,
  });

  /// Computed difference (positive = increase, negative = decrease)
  double get difference => afterAmount - beforeAmount;

  /// Whether this change was an increase
  bool get isIncrease => difference > 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AssetChange && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
