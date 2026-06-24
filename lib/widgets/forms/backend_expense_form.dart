import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/utils/validators.dart';
import '../../data/models/enums.dart';
import '../../data/services/backend_asset_api.dart';
import '../../providers/auth_provider.dart';
import '../../providers/backend_data_providers.dart';
import '../common/bottom_sheet_picker.dart';
import '../common/form_sheet.dart';

class BackendExpenseForm extends ConsumerStatefulWidget {
  final BackendExpense? initialExpense;

  const BackendExpenseForm({super.key, this.initialExpense});

  @override
  ConsumerState<BackendExpenseForm> createState() => _BackendExpenseFormState();
}

class _BackendExpenseFormState extends ConsumerState<BackendExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl =
      TextEditingController(text: widget.initialExpense?.name ?? '');
  late final _amountCtrl =
      TextEditingController(text: widget.initialExpense?.amount ?? '');
  late final _notesCtrl =
      TextEditingController(text: widget.initialExpense?.notes ?? '');

  late ExpenseCycle _cycle = _cycleFromServer(widget.initialExpense?.cycle);
  late String? _selectedPersonId = widget.initialExpense?.personId;
  late DateTime _date = widget.initialExpense?.date ?? DateTime.now();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPersonId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择人员')),
      );
      return;
    }
    final token = ref.read(authProvider).valueOrNull?.accessToken;
    if (token == null) return;

    setState(() => _isSubmitting = true);
    try {
      final api = ref.read(backendAssetApiProvider);
      final notes =
          _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim();
      final initial = widget.initialExpense;
      if (initial == null) {
        await api.createExpense(
          token,
          BackendExpenseCreate(
            name: _nameCtrl.text.trim(),
            amount: _amountCtrl.text.trim(),
            cycle: _cycle.name.toUpperCase(),
            personId: _selectedPersonId!,
            date: _date,
            notes: notes,
          ),
        );
      } else {
        await api.updateExpense(
          token,
          expenseId: initial.id,
          input: BackendExpenseUpdate(
            version: initial.version,
            name: _nameCtrl.text.trim(),
            amount: _amountCtrl.text.trim(),
            cycle: _cycle.name.toUpperCase(),
            personId: _selectedPersonId!,
            date: _date,
            notes: notes,
          ),
        );
      }
      ref.invalidate(backendExpensesProvider);
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
    final personsAsync = ref.watch(backendPersonsProvider);

    return FormSheet(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.initialExpense == null ? '添加固定支出' : '编辑固定支出',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: '支出名称 *'),
              validator: (v) => validateRequired(v, fieldName: '支出名称'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _amountCtrl,
              decoration:
                  const InputDecoration(labelText: '金额 *', suffixText: '元'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => validatePositiveNumber(v, fieldName: '金额'),
            ),
            const SizedBox(height: AppSpacing.md),
            SegmentedButton<ExpenseCycle>(
              segments: ExpenseCycle.values
                  .map((c) => ButtonSegment(value: c, label: Text(c.label)))
                  .toList(),
              selected: {_cycle},
              onSelectionChanged: (set) => setState(() => _cycle = set.first),
              showSelectedIcon: false,
            ),
            const SizedBox(height: AppSpacing.sm),
            personsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const Text('加载人员失败'),
              data: (persons) => BottomSheetPicker<String>(
                label: '归属人员 *',
                selectedValue: _selectedPersonId,
                options: persons
                    .where((p) => p.enabled)
                    .map((p) => PickerOption(value: p.id, label: p.name))
                    .toList(),
                onChanged: (v) => setState(() => _selectedPersonId = v),
                validator: (v) => v == null ? '请选择人员' : null,
                emptyHint: '请选择人员',
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('日期'),
              subtitle: Text(_dateText(_date)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null && mounted) setState(() => _date = picked);
              },
            ),
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(labelText: '备注（可选）'),
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.initialExpense == null ? '添加' : '保存'),
            ),
          ],
        ),
      ),
    );
  }
}

ExpenseCycle _cycleFromServer(String? value) {
  return switch (value) {
    'DAILY' => ExpenseCycle.daily,
    'WEEKLY' => ExpenseCycle.weekly,
    'YEARLY' => ExpenseCycle.yearly,
    _ => ExpenseCycle.monthly,
  };
}

String _dateText(DateTime value) {
  return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}
