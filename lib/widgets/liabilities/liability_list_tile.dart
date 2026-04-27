import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/person_color.dart';
import '../../data/models/liability.dart';
import '../common/app_card.dart';

class LiabilityListTile extends StatelessWidget {
  final Liability liability;
  final String typeName;
  final String? personName; // optional — shown as a coloured tag
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const LiabilityListTile({
    super.key,
    required this.liability,
    required this.typeName,
    this.personName,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = liability.isOverdue;
    final personColor = PersonColors.forId(liability.personId);

    // Border: overdue takes priority over person color
    final borderColor = isOverdue
        ? AppColors.liabilityColor.withValues(alpha: 0.4)
        : liability.personId != null
            ? PersonColors.borderForId(liability.personId)
            : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: EdgeInsets.zero,
        borderColor: borderColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Icon badge — tinted in person color when assigned
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: liability.personId != null
                      ? PersonColors.bgForId(liability.personId)
                      : AppColors.liabilityGlow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: liability.personId != null
                        ? personColor.withValues(alpha: 0.3)
                        : AppColors.liabilityColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.credit_card_rounded,
                  color: liability.personId != null
                      ? personColor
                      : AppColors.liabilityColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Name + tags
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      liability.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Wrap(
                      spacing: 5,
                      runSpacing: 3,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // Type chip
                        _Tag(label: typeName),
                        // Due date chip
                        if (liability.dueDate != null)
                          _Tag(
                            label: isOverdue
                                ? '已逾期 ${formatDate(liability.dueDate!)}'
                                : '到期 ${formatDate(liability.dueDate!)}',
                            color: isOverdue
                                ? AppColors.liabilityColor
                                : null,
                          ),
                        // Person chip (coloured)
                        if (personName != null)
                          _Tag(
                            label: personName!,
                            color: personColor,
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Amount + rate
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatCNY(liability.amount),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.liabilityColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (liability.interestRate != null)
                    Text(
                      formatRate(liability.interestRate!),
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                ],
              ),

              if (onEdit != null || onDelete != null)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert,
                      size: 18, color: AppColors.textMuted),
                  onSelected: (value) {
                    if (value == 'edit') onEdit?.call();
                    if (value == 'delete') onDelete?.call();
                  },
                  itemBuilder: (_) => [
                    if (onEdit != null)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(children: [
                          Icon(Icons.edit_outlined, size: 16),
                          SizedBox(width: 8),
                          Text('编辑'),
                        ]),
                      ),
                    if (onDelete != null)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(children: [
                          Icon(Icons.delete_outline,
                              size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Text('删除',
                              style: TextStyle(color: Colors.red)),
                        ]),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color? color;

  const _Tag({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: c != null ? c.withValues(alpha: 0.12) : AppColors.glass,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: c != null ? c.withValues(alpha: 0.4) : AppColors.glassBorder,
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: c ?? AppColors.textSecondary,
          fontWeight: c != null ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
