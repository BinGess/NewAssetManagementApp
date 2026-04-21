import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/liability.dart';

class LiabilityListTile extends StatelessWidget {
  final Liability liability;
  final String typeName;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const LiabilityListTile({
    super.key,
    required this.liability,
    required this.typeName,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.liabilityColor.withValues(alpha: 0.1),
          child: const Icon(Icons.credit_card_outlined, color: AppColors.liabilityColor, size: 20),
        ),
        title: Text(liability.name, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              typeName,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            if (liability.dueDate != null)
              Text(
                '到期：${formatDate(liability.dueDate!)}',
                style: TextStyle(
                  fontSize: 11,
                  color: liability.isOverdue ? AppColors.error : AppColors.textSecondary,
                  fontWeight: liability.isOverdue ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
          ],
        ),
        isThreeLine: liability.dueDate != null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCNY(liability.amount),
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.liabilityColor),
                ),
                if (liability.interestRate != null)
                  Text(
                    formatRate(liability.interestRate!),
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
              ],
            ),
            if (onEdit != null || onDelete != null)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 18, color: AppColors.textSecondary),
                itemBuilder: (_) => [
                  if (onEdit != null)
                    const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, size: 16), SizedBox(width: 8), Text('编辑')])),
                  if (onDelete != null)
                    const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 16, color: Colors.red), SizedBox(width: 8), Text('删除', style: TextStyle(color: Colors.red))])),
                ],
                onSelected: (value) {
                  if (value == 'edit') onEdit?.call();
                  if (value == 'delete') onDelete?.call();
                },
              ),
          ],
        ),
      ),
    );
  }
}
