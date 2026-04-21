import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

// ─── GlassCard ────────────────────────────────────────────────────────────────
/// Glassmorphism card: backdrop blur + translucent fill + subtle border.
/// Use for dashboard panels, list items, and info cards.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;
  final double blurSigma;
  final Color? fillColor;
  final Color? borderColor;
  final Gradient? gradient;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = AppSpacing.cardRadius,
    this.blurSigma = 16,
    this.fillColor,
    this.borderColor,
    this.gradient,
    this.shadows,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final fill = fillColor ?? AppColors.glass;
    final border = borderColor ?? AppColors.glassBorder;

    Widget card = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            color: gradient == null ? fill : null,
            borderRadius: radius,
            border: Border.all(color: border, width: 1),
            boxShadow: shadows ??
                [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
          ),
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      card = GestureDetector(onTap: onTap, child: card);
    }

    return card;
  }
}

// ─── Elevated GlassCard ───────────────────────────────────────────────────────
/// Higher-contrast glass card — use for hero metrics or CTAs.
class GlassCardHero extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final List<Color>? gradientColors;

  const GlassCardHero({
    super.key,
    required this.child,
    this.padding,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: padding,
      blurSigma: 20,
      fillColor: AppColors.glassHigh,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors ??
            [
              AppColors.primary.withValues(alpha: 0.18),
              AppColors.bgPurple.withValues(alpha: 0.6),
            ],
      ),
      shadows: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.18),
          blurRadius: 32,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
      child: child,
    );
  }
}

// ─── AppCard (legacy wrapper — delegates to GlassCard) ────────────────────────
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: padding,
      fillColor: color,
      child: child,
    );
  }
}
