import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/dashboard_summary.dart';
import '../common/amount_text.dart';
import '../common/app_card.dart';

class NetWorthCard extends StatelessWidget {
  final DashboardSummary summary;

  const NetWorthCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          // Net worth prominently in the center
          Text(
            '净资产',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          AmountText(
            amount: summary.netWorth,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.netWorthColor,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),
          // Assets and liabilities side by side
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  label: '总资产',
                  amount: summary.totalAssets,
                  color: AppColors.assetColor,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade200,
              ),
              Expanded(
                child: _SummaryItem(
                  label: '总负债',
                  amount: summary.totalLiabilities,
                  color: AppColors.liabilityColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 4),
        AmountText(
          amount: amount,
          color: color,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
