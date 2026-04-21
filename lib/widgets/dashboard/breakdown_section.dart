import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/dashboard_summary.dart';
import '../../core/utils/currency_formatter.dart';
import '../common/app_card.dart';

class BreakdownSection extends StatelessWidget {
  final String title;
  final List<TypeTotal> items;
  final double total;
  final Color barColor;

  const BreakdownSection({
    super.key,
    required this.title,
    required this.items,
    required this.total,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                width: 3,
                height: 16,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: barColor.withValues(alpha: 0.6),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.2,
                ),
              ),
              const Spacer(),
              Text(
                formatCNY(total),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: barColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Rows
          ...items.map((item) => _BreakdownRow(
                item: item,
                total: total,
                barColor: barColor,
              )),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final TypeTotal item;
  final double total;
  final Color barColor;

  const _BreakdownRow({
    required this.item,
    required this.total,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = total > 0 ? (item.total / total).clamp(0.0, 1.0) : 0.0;
    final pct = (fraction * 100).toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Text(
                '$pct%',
                style: TextStyle(
                  fontSize: 11,
                  color: barColor.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formatCNY(item.total),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Custom progress bar with glow
          Stack(
            children: [
              // Background track
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.glassDivider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Fill bar
              FractionallySizedBox(
                widthFactor: fraction,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        barColor.withValues(alpha: 0.7),
                        barColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: barColor.withValues(alpha: 0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
