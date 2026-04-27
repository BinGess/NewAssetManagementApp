import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/validators.dart';
import '../../data/models/asset.dart';
import '../../providers/data_providers.dart';
import '../../providers/repository_providers.dart';
import '../common/bottom_sheet_picker.dart';
import '../common/form_sheet.dart';

class AssetForm extends ConsumerStatefulWidget {
  final Asset? initialAsset; // null = create, non-null = edit
  final VoidCallback? onSuccess;

  const AssetForm({super.key, this.initialAsset, this.onSuccess});

  @override
  ConsumerState<AssetForm> createState() => _AssetFormState();
}

class _AssetFormState extends ConsumerState<AssetForm> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(text: widget.initialAsset?.name ?? '');
  late final _amountCtrl = TextEditingController(
    text: widget.initialAsset?.amount.toStringAsFixed(2) ?? '',
  );
  late final _annualRateCtrl = TextEditingController(
    text: widget.initialAsset?.annualRate != null
        ? (widget.initialAsset!.annualRate! * 100).toStringAsFixed(2)
        : '',
  );
  late final _notesCtrl = TextEditingController(text: widget.initialAsset?.notes ?? '');

  int? _selectedTypeId;
  String _currency = 'CNY';
  DateTime _valuationDate = DateTime.now();
  DateTime? _startDate;
  int? _selectedPersonId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialAsset != null) {
      _selectedTypeId = widget.initialAsset!.typeId;
      _currency = widget.initialAsset!.currency;
      _valuationDate = widget.initialAsset!.valuationDate;
      _startDate = widget.initialAsset!.startDate;
      _selectedPersonId = widget.initialAsset!.personId;
    }
    _annualRateCtrl.addListener(() => setState(() {}));
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

    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(assetRepositoryProvider);
      final service = ref.read(dashboardServiceProvider);
      final amount = double.parse(_amountCtrl.text.trim());
      final annualRate = _annualRateCtrl.text.trim().isEmpty
          ? null
          : double.parse(_annualRateCtrl.text.trim()) / 100;

      if (widget.initialAsset == null) {
        await repo.insert(
          name: _nameCtrl.text.trim(),
          typeId: _selectedTypeId!,
          amount: amount,
          currency: _currency,
          valuationDate: _valuationDate,
          annualRate: annualRate,
          startDate: _startDate,
          notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
          personId: _selectedPersonId,
        );
      } else {
        await repo.updateWithChangeTracking(
          widget.initialAsset!.copyWith(
            name: _nameCtrl.text.trim(),
            typeId: _selectedTypeId!,
            amount: amount,
            currency: _currency,
            valuationDate: _valuationDate,
            annualRate: annualRate,
            startDate: _startDate,
            notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
            personId: _selectedPersonId,
          ),
        );
      }
      await service.recordSnapshot();

      if (mounted) {
        Navigator.of(context).pop();
        widget.onSuccess?.call();
      }
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
      initialDate: isStartDate ? (_startDate ?? DateTime.now()) : _valuationDate,
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
    final assetTypesAsync = ref.watch(assetTypesStreamProvider);
    final personsAsync = ref.watch(personsStreamProvider);

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

              // Name
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: '资产名称 *'),
                validator: (v) => validateRequired(v, fieldName: '资产名称'),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Asset Type — bottom sheet picker
              assetTypesAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('加载类型失败'),
                data: (types) {
                  final enabledTypes = types.where((t) => t.enabled).toList();
                  return BottomSheetPicker<int>(
                    label: '资产类型 *',
                    selectedValue: _selectedTypeId,
                    options: enabledTypes
                        .map((t) => PickerOption(value: t.id, label: t.label))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedTypeId = v),
                    validator: (v) => v == null ? '请选择资产类型' : null,
                    emptyHint: '请选择资产类型',
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),

              // Amount
              TextFormField(
                controller: _amountCtrl,
                decoration: const InputDecoration(labelText: '金额 *', suffixText: '元'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => validatePositiveNumber(v, fieldName: '金额'),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Currency — bottom sheet picker
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

              // Person — bottom sheet picker (optional)
              personsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (persons) {
                  final enabledPersons = persons.where((p) => p.enabled).toList();
                  if (enabledPersons.isEmpty) return const SizedBox.shrink();
                  return Column(
                    children: [
                      BottomSheetPicker<int>(
                        label: '所属人员（可选）',
                        selectedValue: _selectedPersonId,
                        options: enabledPersons
                            .map((p) => PickerOption(value: p.id, label: p.name))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedPersonId = v),
                        clearable: true,
                        emptyHint: '未指定人员',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  );
                },
              ),

              // Valuation Date
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('估值日期'),
                subtitle: Text(
                    '${_valuationDate.year}-${_valuationDate.month.toString().padLeft(2, '0')}-${_valuationDate.day.toString().padLeft(2, '0')}'),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: () => _pickDate(isStartDate: false),
              ),

              // Annual Rate (optional)
              TextFormField(
                controller: _annualRateCtrl,
                decoration: const InputDecoration(
                  labelText: '年化利率（可选）',
                  suffixText: '%',
                  helperText: '货币基金/存款填写，如 3.00',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => validateRate(v),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Start Date (optional, shown only when annual rate is provided)
              if (_annualRateCtrl.text.trim().isNotEmpty)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('起息日期（可选）'),
                  subtitle: Text(_startDate != null
                      ? '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}'
                      : '未设置'),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: () => _pickDate(isStartDate: true),
                ),

              // Notes
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
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(widget.initialAsset == null ? '添加' : '保存'),
              ),
            ],
          ),
        ),
      );
  }
}
