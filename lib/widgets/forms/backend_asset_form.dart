import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/utils/validators.dart';
import '../../data/services/backend_asset_api.dart';
import '../../providers/auth_provider.dart';
import '../../providers/backend_data_providers.dart';
import '../common/bottom_sheet_picker.dart';
import '../common/form_sheet.dart';

class BackendAssetForm extends ConsumerStatefulWidget {
  final BackendAsset? initialAsset;

  const BackendAssetForm({super.key, this.initialAsset});

  @override
  ConsumerState<BackendAssetForm> createState() => _BackendAssetFormState();
}

class _BackendAssetFormState extends ConsumerState<BackendAssetForm> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl =
      TextEditingController(text: widget.initialAsset?.name ?? '');
  late final _amountCtrl =
      TextEditingController(text: widget.initialAsset?.amount ?? '');
  late final _annualRateCtrl =
      TextEditingController(text: widget.initialAsset?.annualRate ?? '');
  late final _notesCtrl =
      TextEditingController(text: widget.initialAsset?.notes ?? '');

  String? _selectedTypeId;
  String _currency = 'CNY';
  DateTime _valuationDate = DateTime.now();
  DateTime? _startDate;
  String? _selectedPersonId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialAsset;
    if (initial != null) {
      _selectedTypeId = initial.typeId;
      _currency = initial.currency;
      _valuationDate = initial.valuationDate;
      _startDate = initial.startDate;
      _selectedPersonId = initial.personId;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    _annualRateCtrl.dispose();
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
      final annualRate = _annualRateCtrl.text.trim().isEmpty
          ? null
          : _annualRateCtrl.text.trim();
      final initial = widget.initialAsset;
      if (initial == null) {
        await api.createAsset(
          token,
          BackendAssetCreate(
            name: _nameCtrl.text.trim(),
            typeId: _selectedTypeId!,
            amount: _amountCtrl.text.trim(),
            currency: _currency,
            valuationDate: _valuationDate,
            annualRate: annualRate,
            startDate: _startDate,
            notes: notes,
            personId: _selectedPersonId,
          ),
        );
      } else {
        await api.updateAsset(
          token,
          assetId: initial.id,
          input: BackendAssetUpdate(
            version: initial.version,
            name: _nameCtrl.text.trim(),
            typeId: _selectedTypeId!,
            amount: _amountCtrl.text.trim(),
            currency: _currency,
            valuationDate: _valuationDate,
            annualRate: annualRate,
            startDate: _startDate,
            notes: notes,
            personId: _selectedPersonId,
          ),
        );
      }
      ref.invalidate(backendAssetsProvider);
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

  Future<void> _pickDate({required bool isStartDate}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          isStartDate ? (_startDate ?? DateTime.now()) : _valuationDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _valuationDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final assetTypesAsync = ref.watch(backendAssetTypesProvider);
    final personsAsync = ref.watch(backendPersonsProvider);

    return FormSheet(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.initialAsset == null ? '添加资产' : '编辑资产',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: '资产名称 *'),
              validator: (v) => validateRequired(v, fieldName: '资产名称'),
            ),
            const SizedBox(height: AppSpacing.sm),
            assetTypesAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const Text('加载类型失败'),
              data: (types) => BottomSheetPicker<String>(
                label: '资产类型 *',
                selectedValue: _selectedTypeId,
                options: types
                    .where((t) => t.enabled)
                    .map((t) => PickerOption(value: t.id, label: t.label))
                    .toList(),
                onChanged: (v) => setState(() => _selectedTypeId = v),
                validator: (v) => v == null ? '请选择资产类型' : null,
                emptyHint: '请选择资产类型',
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
            BottomSheetPicker<String>(
              label: '币种',
              selectedValue: _currency,
              options: const [
                PickerOption(value: 'CNY', label: '人民币 (CNY)'),
                PickerOption(value: 'USD', label: '美元 (USD)'),
                PickerOption(value: 'HKD', label: '港元 (HKD)'),
              ],
              onChanged: (v) => setState(() => _currency = v ?? 'CNY'),
              emptyHint: '请选择币种',
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
              title: const Text('估值日期'),
              subtitle: Text(_dateText(_valuationDate)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: () => _pickDate(isStartDate: false),
            ),
            TextFormField(
              controller: _annualRateCtrl,
              decoration: const InputDecoration(labelText: '年化利率（可选）'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => validateRate(v),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('起息日期（可选）'),
              subtitle:
                  Text(_startDate == null ? '未设置' : _dateText(_startDate!)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: () => _pickDate(isStartDate: true),
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
                  : Text(widget.initialAsset == null ? '添加' : '保存'),
            ),
          ],
        ),
      ),
    );
  }
}

String _dateText(DateTime value) {
  return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}
