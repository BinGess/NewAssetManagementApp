import 'package:flutter/material.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/expense.dart';
import '../../data/models/enums.dart';

class ExpenseListTile extends StatelessWidget {
  final Expense expense;
  final String personName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExpenseListTile({
    super.key,
    required this.expense,
    required this.personName,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(
            _cycleIcon(expense.cycle),
            color: colorScheme.onPrimaryContainer,
            size: 20,
          ),
        ),
        title: Text(expense.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text(expense.cycle.label,
                      style: const TextStyle(fontSize: 11)),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 6),
                Text(personName,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: colorScheme.secondary)),
              ],
            ),
            Text(
              '月均 ${formatCNY(expense.monthlyAmount)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatCNY(expense.amount),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
                fontSize: 15,
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 20),
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('编辑')),
                PopupMenuItem(value: 'delete', child: Text('删除')),
              ],
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  IconData _cycleIcon(ExpenseCycle cycle) => switch (cycle) {
        ExpenseCycle.daily => Icons.today_outlined,
        ExpenseCycle.weekly => Icons.view_week_outlined,
        ExpenseCycle.monthly => Icons.calendar_month_outlined,
        ExpenseCycle.yearly => Icons.calendar_today_outlined,
      };
}
