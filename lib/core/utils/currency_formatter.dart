/// Formats a monetary amount with Chinese units (万, 亿).
/// Examples:
///   999.5    → ¥999.50
///   12340    → ¥1.23万
///   10000000 → ¥1000.00万  (or ¥0.10亿 depending on threshold)
///   100000000 → ¥1.00亿
String formatCNY(double amount) {
  final absAmount = amount.abs();
  final sign = amount < 0 ? '-' : '';
  if (absAmount >= 1e8) {
    return '$sign¥${(absAmount / 1e8).toStringAsFixed(2)}亿';
  } else if (absAmount >= 1e4) {
    return '$sign¥${(absAmount / 1e4).toStringAsFixed(2)}万';
  } else {
    return '$sign¥${absAmount.toStringAsFixed(2)}';
  }
}

/// Formats a percentage rate (as a decimal, e.g. 0.03 → "3.00%")
String formatRate(double rate) {
  return '${(rate * 100).toStringAsFixed(2)}%';
}
