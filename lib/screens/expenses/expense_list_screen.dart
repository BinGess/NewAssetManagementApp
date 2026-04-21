import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/enums.dart';
import '../../data/models/expense.dart';
import '../../providers/data_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/common/app_empty_state.dart';
import '../../widgets/common/app_loading.dart';
import '../../widgets/common/confirm_dialog.dart';
import '../../widgets/expenses/expense_list_tile.dart';
import '../../widgets/forms/expense_form.dart';

class ExpenseListScreen extends ConsumerStatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  // Filter state
  int? _selectedPersonId;
  ExpenseCycle? _selectedCycle;

  void _showForm(BuildContext context, {Expense? expense}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ExpenseForm(initialExpense: expense),
    );
  }

  List<Expense> _applyFilters(List<Expense> expenses) {
    return expenses.where((e) {
      if (_selectedPersonId != null && e.personId != _selectedPersonId) {
        return false;
      }
      if (_selectedCycle != null && e.cycle != _selectedCycle) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expensesStreamProvider);
    final personsAsync = ref.watch(personsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('固定支出')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add),
      ),
      body: expensesAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (allExpenses) {
          final persons = personsAsync.valueOrNull ?? [];
          final personMap =
              persons.fold<Map<int, String>>({}, (m, p) => m..[p.id] = p.name);

          final filtered = _applyFilters(allExpenses);
          final monthlyTotal =
              filtered.fold(0.0, (s, e) => s + e.monthlyAmount);

          return Column(
            children: [
              // Filter bar
              _FilterBar(
                persons: persons,
                selectedPersonId: _selectedPersonId,
                selectedCycle: _selectedCycle,
                onPersonChanged: (id) =>
                    setState(() => _selectedPersonId = id),
                onCycleChanged: (cycle) =>
                    setState(() => _selectedCycle = cycle),
              ),

              // Monthly total card
              _MonthlyTotalCard(
                total: monthlyTotal,
                count: filtered.length,
              ),

              // List
              Expanded(
                child: filtered.isEmpty
                    ? AppEmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: allExpenses.isEmpty ? '还没有固定支出' : '没有匹配的支出',
                        subtitle: allExpenses.isEmpty
                            ? '点击右下角按钮添加您的第一笔固定支出'
                            : '请调整筛选条件',
                        action: allExpenses.isEmpty
                            ? ElevatedButton(
                                onPressed: () => _showForm(context),
                                child: const Text('添加支出'),
                              )
                            : null,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final expense = filtered[index];
                          return ExpenseListTile(
                            expense: expense,
                            personName: personMap[expense.personId] ?? '未知',
                            onEdit: () =>
                                _showForm(context, expense: expense),
                            onDelete: () async {
                              final confirmed = await showConfirmDialog(
                                context,
                                title: '删除支出',
                                content:
                                    '确认删除「${expense.name}」？此操作无法撤销。',
                                isDestructive: true,
                              );
                              if (confirmed && mounted) {
                                await ref
                                    .read(expenseRepositoryProvider)
                                    .delete(expense.id);
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Filter Bar ──────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final List<dynamic> persons;
  final int? selectedPersonId;
  final ExpenseCycle? selectedCycle;
  final ValueChanged<int?> onPersonChanged;
  final ValueChanged<ExpenseCycle?> onCycleChanged;

  const _FilterBar({
    required this.persons,
    required this.selectedPersonId,
    required this.selectedCycle,
    required this.onPersonChanged,
    required this.onCycleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // All chip
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: FilterChip(
                label: const Text('全部'),
                selected:
                    selectedPersonId == null && selectedCycle == null,
                onSelected: (_) {
                  onPersonChanged(null);
                  onCycleChanged(null);
                },
              ),
            ),
            // Cycle filter chips
            ...ExpenseCycle.values.map((cycle) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(cycle.label),
                    selected: selectedCycle == cycle,
                    onSelected: (selected) =>
                        onCycleChanged(selected ? cycle : null),
                  ),
                )),
            // Person filter chips
            ...persons.map((p) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(p.name as String),
                    selected: selectedPersonId == (p.id as int),
                    onSelected: (selected) =>
                        onPersonChanged(selected ? p.id as int : null),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

// ─── Monthly Total Card ───────────────────────────────────────────────────────

class _MonthlyTotalCard extends StatelessWidget {
  final double total;
  final int count;

  const _MonthlyTotalCard({required this.total, required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Row(
        children: [
          Icon(Icons.receipt_long, color: colorScheme.onErrorContainer),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('当前筛选月均总支出',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onErrorContainer,
                    )),
                Text(
                  formatCNY(total),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$count 笔',
            style: TextStyle(color: colorScheme.onErrorContainer),
          ),
        ],
      ),
    );
  }
}
