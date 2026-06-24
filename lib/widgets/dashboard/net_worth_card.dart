import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/dashboard_summary.dart';
import '../../core/utils/currency_formatter.dart';
import '../common/app_card.dart';

class NetWorthCard extends StatelessWidget {
  final DashboardSummary summary;

  const NetWorthCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return GlassCardHero(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gradientColors: [
        AppColors.primary.withValues(alpha: 0.22),
        AppColors.bgPurple.withValues(alpha: 0.55),
        AppColors.bgDeep.withValues(alpha: 0.6),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '净资产',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.trending_up_rounded,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Net worth number — hero display
          Text(
            formatCNY(summary.netWorth),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppColors.netWorthColor,
              letterSpacing: -1,
              height: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.md + 4),

          // Divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.0),
                  Colors.white.withValues(alpha: 0.12),
                  Colors.white.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Assets + Liabilities row
          Row(
            children: [
              Expanded(
                child: _MetricItem(
                  label: '总资产',
                  amount: summary.totalAssets,
                  color: AppColors.assetColor,
                  icon: Icons.trending_up_rounded,
                  iconBg: AppColors.assetGlow,
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: AppColors.glassDivider,
              ),
              Expanded(
                child: _MetricItem(
                  label: '总负债',
                  amount: summary.totalLiabilities,
                  color: AppColors.liabilityColor,
                  icon: Icons.trending_down_rounded,
                  iconBg: AppColors.liabilityGlow,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.liabilityGlow.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.glassBorder, width: 1),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.liabilityColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    '月固定支出',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  formatCNY(summary.monthlyExpenses),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.liabilityColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;
  final Color iconBg;

  const _MetricItem({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            formatCNY(amount),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}
