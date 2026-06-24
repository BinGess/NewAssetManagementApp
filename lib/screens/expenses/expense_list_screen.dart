import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/enums.dart';
import '../../data/services/backend_asset_api.dart';
import '../../providers/auth_provider.dart';
import '../../providers/backend_data_providers.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/app_empty_state.dart';
import '../../widgets/common/app_loading.dart';
import '../../widgets/common/confirm_dialog.dart';
import '../../widgets/forms/backend_expense_form.dart';

class ExpenseListScreen extends ConsumerStatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  String? _selectedPersonId;
  ExpenseCycle? _selectedCycle;

  void _showForm({BackendExpense? expense}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BackendExpenseForm(initialExpense: expense),
    );
  }

  List<BackendExpense> _applyFilters(List<BackendExpense> expenses) {
    return expenses.where((expense) {
      if (_selectedPersonId != null && expense.personId != _selectedPersonId) {
        return false;
      }
      if (_selectedCycle != null &&
          _cycleFromServer(expense.cycle) != _selectedCycle) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(backendExpensesProvider);
    final persons = ref.watch(backendPersonsProvider).valueOrNull ?? [];
    final personMap = {for (final person in persons) person.id: person.name};

    return Scaffold(
      appBar: AppBar(
        title: const Text('固定支出'),
        actions: [
          IconButton(
            tooltip: '刷新',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(backendExpensesProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
      body: expensesAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (allExpenses) {
          final filtered = _applyFilters(allExpenses);
          final monthlyTotal =
              filtered.fold(0.0, (s, e) => s + _monthlyAmount(e));

          return Column(
            children: [
              _FilterBar(
                persons: persons,
                selectedPersonId: _selectedPersonId,
                selectedCycle: _selectedCycle,
                onPersonChanged: (id) => setState(() => _selectedPersonId = id),
                onCycleChanged: (cycle) =>
                    setState(() => _selectedCycle = cycle),
              ),
              _MonthlyTotalCard(total: monthlyTotal, count: filtered.length),
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
                                onPressed: () => _showForm(),
                                child: const Text('添加支出'),
                              )
                            : null,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final expense = filtered[index];
                          return _ExpenseCard(
                            expense: expense,
                            personName: personMap[expense.personId] ?? '未知',
                            onEdit: () => _showForm(expense: expense),
                            onDelete: () => _deleteExpense(expense),
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

  Future<void> _deleteExpense(BackendExpense expense) async {
    final confirmed = await showConfirmDialog(
      context,
      title: '删除支出',
      content: '确认删除「${expense.name}」？此操作无法撤销。',
      isDestructive: true,
    );
    if (!confirmed || !mounted) return;
    final token = ref.read(authProvider).valueOrNull?.accessToken;
    if (token == null) return;
    await ref.read(backendAssetApiProvider).deleteExpense(token, expense.id);
    ref.invalidate(backendExpensesProvider);
  }
}

class _FilterBar extends StatelessWidget {
  final List<BackendPerson> persons;
  final String? selectedPersonId;
  final ExpenseCycle? selectedCycle;
  final ValueChanged<String?> onPersonChanged;
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
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: FilterChip(
                label: const Text('全部'),
                selected: selectedPersonId == null && selectedCycle == null,
                onSelected: (_) {
                  onPersonChanged(null);
                  onCycleChanged(null);
                },
              ),
            ),
            ...ExpenseCycle.values.map(
              (cycle) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: Text(cycle.label),
                  selected: selectedCycle == cycle,
                  onSelected: (selected) =>
                      onCycleChanged(selected ? cycle : null),
                ),
              ),
            ),
            ...persons.map(
              (person) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: Text(person.name),
                  selected: selectedPersonId == person.id,
                  onSelected: (selected) =>
                      onPersonChanged(selected ? person.id : null),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthlyTotalCard extends StatelessWidget {
  final double total;
  final int count;

  const _MonthlyTotalCard({required this.total, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: GlassCard(
        child: Row(
          children: [
            const Icon(Icons.calendar_month_outlined, color: AppColors.accent),
            const SizedBox(width: 12),
            Expanded(child: Text('$count 笔固定支出，月均合计')),
            Text(
              formatCNY(total),
              style: const TextStyle(
                color: AppColors.liabilityColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final BackendExpense expense;
  final String personName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ExpenseCard({
    required this.expense,
    required this.personName,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cycle = _cycleFromServer(expense.cycle);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.receipt_long_rounded, color: AppColors.accent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(expense.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    '${cycle.label} · $personName · 月均 ${formatCNY(_monthlyAmount(expense))}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              formatCNY(_amount(expense)),
              style: const TextStyle(
                color: AppColors.liabilityColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            PopupMenuButton<String>(
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
      ),
    );
  }
}

ExpenseCycle _cycleFromServer(String value) {
  return switch (value) {
    'DAILY' => ExpenseCycle.daily,
    'WEEKLY' => ExpenseCycle.weekly,
    'YEARLY' => ExpenseCycle.yearly,
    _ => ExpenseCycle.monthly,
  };
}

double _amount(BackendExpense expense) => double.tryParse(expense.amount) ?? 0;

double _monthlyAmount(BackendExpense expense) {
  final amount = _amount(expense);
  return switch (_cycleFromServer(expense.cycle)) {
    ExpenseCycle.daily => amount * 30,
    ExpenseCycle.weekly => amount * (52 / 12),
    ExpenseCycle.monthly => amount,
    ExpenseCycle.yearly => amount / 12,
  };
}
