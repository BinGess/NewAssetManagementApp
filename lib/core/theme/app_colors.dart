import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand palette ───────────────────────────────────────────────────────────
  static const Color primary       = Color(0xFF3B82F6); // blue-500
  static const Color primaryLight  = Color(0xFF60A5FA); // blue-400
  static const Color primaryDark   = Color(0xFF1D4ED8); // blue-700
  static const Color accent        = Color(0xFFF59E0B); // amber-500

  // ── Semantic ─────────────────────────────────────────────────────────────────
  static const Color assetColor     = Color(0xFF10B981); // emerald-500
  static const Color liabilityColor = Color(0xFFEF4444); // red-500
  static const Color netWorthColor  = Color(0xFFF59E0B); // amber-500
  static const Color success        = Color(0xFF10B981);
  static const Color error          = Color(0xFFEF4444);
  static const Color warning        = Color(0xFFF59E0B);

  // ── Background layers ────────────────────────────────────────────────────────
  static const Color bgBase    = Color(0xFF0F172A); // slate-900
  static const Color bgMid     = Color(0xFF1E293B); // slate-800
  static const Color bgDeep    = Color(0xFF0D1B3E); // deep midnight blue
  static const Color bgPurple  = Color(0xFF1E1B4B); // indigo-950

  // ── Glassmorphism tokens ─────────────────────────────────────────────────────
  /// Card fill — white 8%
  static const Color glass       = Color(0x14FFFFFF);
  /// Card fill elevated — white 12%
  static const Color glassHigh   = Color(0x1FFFFFFF);
  /// Card border — white 15%
  static const Color glassBorder = Color(0x26FFFFFF);
  /// Subtle divider — white 8%
  static const Color glassDivider = Color(0x14FFFFFF);

  // ── Glow / tint overlays ─────────────────────────────────────────────────────
  static const Color primaryGlow    = Color(0x403B82F6); // blue 25%
  static const Color assetGlow      = Color(0x3310B981); // emerald 20%
  static const Color liabilityGlow  = Color(0x33EF4444); // red 20%
  static const Color accentGlow     = Color(0x40F59E0B); // amber 25%

  // ── Text ─────────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFF8FAFC); // slate-50
  static const Color textSecondary = Color(0xFF94A3B8); // slate-400
  static const Color textMuted     = Color(0xFF64748B); // slate-500
  static const Color textHint      = Color(0xFF475569); // slate-600

  // ── Legacy aliases for backward compatibility ────────────────────────────────
  static const Color divider    = Color(0xFF334155); // slate-700
  static const Color background = bgBase;
  static const Color surface    = Color(0xFF1E293B);
}
