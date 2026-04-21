class LiabilityType {
  final int id;
  final String code;
  final String label;
  final bool enabled;
  final int sortOrder;

  const LiabilityType({
    required this.id,
    required this.code,
    required this.label,
    required this.enabled,
    required this.sortOrder,
  });

  LiabilityType copyWith({
    int? id,
    String? code,
    String? label,
    bool? enabled,
    int? sortOrder,
  }) {
    return LiabilityType(
      id: id ?? this.id,
      code: code ?? this.code,
      label: label ?? this.label,
      enabled: enabled ?? this.enabled,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is LiabilityType && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
