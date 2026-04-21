class Snapshot {
  final int id;
  final double totalAssets;
  final double totalLiabilities;
  final double netWorth;
  final String currency;
  final DateTime createdAt;

  const Snapshot({
    required this.id,
    required this.totalAssets,
    required this.totalLiabilities,
    required this.netWorth,
    required this.currency,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Snapshot && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
