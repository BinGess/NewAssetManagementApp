import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/validators.dart';
import '../../data/models/liability.dart';
import '../../providers/data_providers.dart';
import '../../providers/repository_providers.dart';

class LiabilityForm extends ConsumerStatefulWidget {
  final Liability? initialLiability;

  const LiabilityForm({super.key, this.initialLiability});

  @override
  ConsumerState<LiabilityForm> createState() => _LiabilityFormState();
}

class _LiabilityFormState extends ConsumerState<LiabilityForm> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(text: widget.initialLiability?.name ?? '');
  late final _amountCtrl = TextEditingController(
    text: widget.initialLiability?.amount.toStringAsFixed(2) ?? '',
  );
  late final _interestRateCtrl = TextEditingController(
    text: widget.initialLiability?.interestRate != null
        ? (widget.initialLiability!.interestRate! * 100).toStringAsFixed(2)
        : '',
  );
  late final _notesCtrl = TextEditingController(text: widget.initialLiability?.notes ?? '');

  int? _selectedTypeId;
  String _currency = 'CNY';
  DateTime? _dueDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLiability != null) {
      _selectedTypeId = widget.initialLiability!.typeId;
      _currency = widget.initialLiability!.currency;
      _dueDate = widget.initialLiability!.dueDate;
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
    if (_selectedTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择负债类型')),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(liabilityRepositoryProvider);
      final service = ref.read(dashboardServiceProvider);
      final amount = double.parse(_amountCtrl.text.trim());
      final interestRate = _interestRateCtrl.text.trim().isEmpty
          ? null
          : double.parse(_interestRateCtrl.text.trim()) / 100;

      if (widget.initialLiability == null) {
        await repo.insert(
          name: _nameCtrl.text.trim(),
          typeId: _selectedTypeId!,
          amount: amount,
          currency: _currency,
          interestRate: interestRate,
          dueDate: _dueDate,
          notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        );
      } else {
        await repo.update(widget.initialLiability!.copyWith(
          name: _nameCtrl.text.trim(),
          typeId: _selectedTypeId!,
          amount: amount,
          currency: _currency,
          interestRate: interestRate,
          dueDate: _dueDate,
          notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        ));
      }
      await service.recordSnapshot();
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
    final liabilityTypesAsync = ref.watch(liabilityTypesStreamProvider);

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
                widget.initialLiability == null ? '添加负债' : '编辑负债',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),

              // Name
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: '负债名称 *'),
                validator: (v) => validateRequired(v, fieldName: '负债名称'),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Type
              liabilityTypesAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('加载类型失败'),
                data: (types) => DropdownButtonFormField<int>(
                  initialValue: _selectedTypeId,
                  decoration: const InputDecoration(labelText: '负债类型 *'),
                  items: types
                      .where((t) => t.enabled)
                      .map((t) => DropdownMenuItem(value: t.id, child: Text(t.label)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedTypeId = v),
                  validator: (v) => v == null ? '请选择负债类型' : null,
                ),
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

              // Currency
              DropdownButtonFormField<String>(
                initialValue: _currency,
                decoration: const InputDecoration(labelText: '币种'),
                items: const [
                  DropdownMenuItem(value: 'CNY', child: Text('人民币 (CNY)')),
                  DropdownMenuItem(value: 'USD', child: Text('美元 (USD)')),
                  DropdownMenuItem(value: 'HKD', child: Text('港元 (HKD)')),
                ],
                onChanged: (v) => setState(() => _currency = v ?? 'CNY'),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Interest Rate (optional)
              TextFormField(
                controller: _interestRateCtrl,
                decoration: const InputDecoration(
                  labelText: '年利率（可选）',
                  suffixText: '%',
                  helperText: '如房贷利率 3.85',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => validateRate(v),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Due Date (optional)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('到期日期（可选）'),
                subtitle: Text(_dueDate != null ? formatDate(_dueDate!) : '未设置'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today_outlined),
                    if (_dueDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => setState(() => _dueDate = null),
                      ),
                  ],
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null && mounted) setState(() => _dueDate = picked);
                },
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
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(widget.initialLiability == null ? '添加' : '保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
