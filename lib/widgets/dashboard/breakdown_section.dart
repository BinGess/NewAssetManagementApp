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

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Text(
                formatCNY(item.total),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: fraction,
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }
}
