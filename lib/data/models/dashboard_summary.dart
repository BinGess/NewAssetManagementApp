class TypeTotal {
  final int typeId;
  final String label;
  final double total;

  const TypeTotal({
    required this.typeId,
    required this.label,
    required this.total,
  });
}

class DashboardSummary {
  final double totalAssets;
  final double totalLiabilities;
  final double netWorth;
  final List<TypeTotal> assetsByType;
  final List<TypeTotal> liabilitiesByType;

  const DashboardSummary({
    required this.totalAssets,
    required this.totalLiabilities,
    required this.netWorth,
    required this.assetsByType,
    required this.liabilitiesByType,
  });
}
