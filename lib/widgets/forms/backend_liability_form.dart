import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/validators.dart';
import '../../data/services/backend_asset_api.dart';
import '../../providers/auth_provider.dart';
import '../../providers/backend_data_providers.dart';
import '../common/bottom_sheet_picker.dart';
import '../common/form_sheet.dart';

class BackendLiabilityForm extends ConsumerStatefulWidget {
  final BackendLiability? initialLiability;

  const BackendLiabilityForm({super.key, this.initialLiability});

  @override
  ConsumerState<BackendLiabilityForm> createState() =>
      _BackendLiabilityFormState();
}

class _BackendLiabilityFormState extends ConsumerState<BackendLiabilityForm> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl =
      TextEditingController(text: widget.initialLiability?.name ?? '');
  late final _amountCtrl =
      TextEditingController(text: widget.initialLiability?.amount ?? '');
  late final _interestRateCtrl =
      TextEditingController(text: widget.initialLiability?.interestRate ?? '');
  late final _notesCtrl =
      TextEditingController(text: widget.initialLiability?.notes ?? '');

  String? _selectedTypeId;
  String _currency = 'CNY';
  DateTime? _dueDate;
  String? _selectedPersonId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialLiability;
    if (initial != null) {
      _selectedTypeId = initial.typeId;
      _currency = initial.currency;
      _dueDate = initial.dueDate;
      _selectedPersonId = initial.personId;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    _interestRateCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final token = ref.read(authProvider).valueOrNull?.accessToken;
    if (token == null) return;

    setState(() => _isSubmitting = true);
    try {
      final api = ref.read(backendAssetApiProvider);
      final notes =
          _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim();
      final interestRate = _interestRateCtrl.text.trim().isEmpty
          ? null
          : _interestRateCtrl.text.trim();
      final initial = widget.initialLiability;
      if (initial == null) {
        await api.createLiability(
          token,
          BackendLiabilityCreate(
            name: _nameCtrl.text.trim(),
            typeId: _selectedTypeId!,
            amount: _amountCtrl.text.trim(),
            currency: _currency,
            interestRate: interestRate,
            dueDate: _dueDate,
            notes: notes,
            personId: _selectedPersonId,
          ),
        );
      } else {
        await api.updateLiability(
          token,
          liabilityId: initial.id,
          input: BackendLiabilityUpdate(
            version: initial.version,
            name: _nameCtrl.text.trim(),
            typeId: _selectedTypeId!,
            amount: _amountCtrl.text.trim(),
            currency: _currency,
            interestRate: interestRate,
            dueDate: _dueDate,
            notes: notes,
            personId: _selectedPersonId,
          ),
        );
      }
      ref.invalidate(backendLiabilitiesProvider);
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
    final liabilityTypesAsync = ref.watch(backendLiabilityTypesProvider);
    final personsAsync = ref.watch(backendPersonsProvider);

    return FormSheet(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.initialLiability == null ? '添加负债' : '编辑负债',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: '负债名称 *'),
              validator: (v) => validateRequired(v, fieldName: '负债名称'),
            ),
            const SizedBox(height: AppSpacing.sm),
            liabilityTypesAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const Text('加载类型失败'),
              data: (types) => BottomSheetPicker<String>(
                label: '负债类型 *',
                selectedValue: _selectedTypeId,
                options: types
                    .where((t) => t.enabled)
                    .map((t) => PickerOption(value: t.id, label: t.label))
                    .toList(),
                onChanged: (v) => setState(() => _selectedTypeId = v),
                validator: (v) => v == null ? '请选择负债类型' : null,
                emptyHint: '请选择负债类型',
              ),
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
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _interestRateCtrl,
              decoration: const InputDecoration(labelText: '年利率（可选）'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => validateRate(v),
            ),
            const SizedBox(height: AppSpacing.sm),
            personsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (persons) => BottomSheetPicker<String>(
                label: '所属人员（可选）',
                selectedValue: _selectedPersonId,
                options: persons
                    .where((p) => p.enabled)
                    .map((p) => PickerOption(value: p.id, label: p.name))
                    .toList(),
                onChanged: (v) => setState(() => _selectedPersonId = v),
                clearable: true,
                emptyHint: '未指定人员',
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('到期日期（可选）'),
              subtitle: Text(_dueDate == null ? '未设置' : formatDate(_dueDate!)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null && mounted) {
                  setState(() => _dueDate = picked);
                }
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
                  : Text(widget.initialLiability == null ? '添加' : '保存'),
            ),
          ],
        ),
      ),
    );
  }
}
