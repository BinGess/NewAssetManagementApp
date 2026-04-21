import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/validators.dart';
import '../../data/models/enums.dart';
import '../../data/models/expense.dart';
import '../../providers/data_providers.dart';
import '../../providers/repository_providers.dart';

class ExpenseForm extends ConsumerStatefulWidget {
  final Expense? initialExpense;

  const ExpenseForm({super.key, this.initialExpense});

  @override
  ConsumerState<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends ConsumerState<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl =
      TextEditingController(text: widget.initialExpense?.name ?? '');
  late final _amountCtrl = TextEditingController(
    text: widget.initialExpense?.amount.toStringAsFixed(2) ?? '',
  );
  late final _notesCtrl =
      TextEditingController(text: widget.initialExpense?.notes ?? '');

  late ExpenseCycle _cycle =
      widget.initialExpense?.cycle ?? ExpenseCycle.monthly;
  late int? _selectedPersonId = widget.initialExpense?.personId;
  late DateTime _date = widget.initialExpense?.date ?? DateTime.now();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() => _date = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPersonId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择人员')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(expenseRepositoryProvider);
      final amount = double.parse(_amountCtrl.text.trim());
      final notes = _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim();

      if (widget.initialExpense == null) {
        await repo.insert(
          name: _nameCtrl.text.trim(),
          amount: amount,
          cycle: _cycle,
          personId: _selectedPersonId!,
          date: _date,
          notes: notes,
        );
      } else {
        await repo.update(widget.initialExpense!.copyWith(
          name: _nameCtrl.text.trim(),
          amount: amount,
          cycle: _cycle,
          personId: _selectedPersonId!,
          date: _date,
          notes: notes,
        ));
      }

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final personsAsync = ref.watch(personsStreamProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.initialExpense == null ? '添加固定支出' : '编辑固定支出',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),

              // Name
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: '支出名称 *'),
                validator: (v) => validateRequired(v, fieldName: '支出名称'),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Amount
              TextFormField(
                controller: _amountCtrl,
                decoration: const InputDecoration(labelText: '金额 *', suffixText: '元'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => validatePositiveNumber(v, fieldName: '金额'),
              ),
              const SizedBox(height: AppSpacing.md),

              // Cycle — SegmentedButton
              Text('周期', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: AppSpacing.xs),
              SegmentedButton<ExpenseCycle>(
                segments: ExpenseCycle.values
                    .map((c) => ButtonSegment(value: c, label: Text(c.label)))
                    .toList(),
                selected: {_cycle},
                onSelectionChanged: (set) =>
                    setState(() => _cycle = set.first),
                showSelectedIcon: false,
              ),
              const SizedBox(height: AppSpacing.sm),

              // Person dropdown
              personsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('加载人员失败'),
                data: (persons) {
                  final enabled = persons.where((p) => p.enabled).toList();
                  return DropdownButtonFormField<int>(
                    initialValue: _selectedPersonId,
                    decoration: const InputDecoration(labelText: '归属人员 *'),
                    items: enabled
                        .map((p) =>
                            DropdownMenuItem(value: p.id, child: Text(p.name)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedPersonId = v),
                    validator: (v) => v == null ? '请选择人员' : null,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),

              // Date
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('日期'),
                subtitle: Text(
                    '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}'),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: _pickDate,
              ),

              // Notes
              TextFormField(
                controller: _notesCtrl,
                decoration:
                    const InputDecoration(labelText: '备注（可选）'),
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.lg),

              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(
                        widget.initialExpense == null ? '添加' : '保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
