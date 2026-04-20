import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1565C0); // Deep blue
  static const Color primaryLight = Color(0xFF1E88E5);
  static const Color success = Color(0xFF2E7D32); // Green for assets
  static const Color error = Color(0xFFC62828);   // Red for liabilities
  static const Color warning = Color(0xFFF57F17); // Amber

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  static const Color divider = Color(0xFFE0E0E0);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);

  // Semantic colors
  static const Color assetColor = success;
  static const Color liabilityColor = error;
  static const Color netWorthColor = primary;
}
