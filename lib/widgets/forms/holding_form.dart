import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/validators.dart';
import '../../data/models/asset_holding.dart';
import '../../providers/repository_providers.dart';

class HoldingForm extends ConsumerStatefulWidget {
  final int assetId;
  final AssetHolding? initialHolding;

  const HoldingForm({super.key, required this.assetId, this.initialHolding});

  @override
  ConsumerState<HoldingForm> createState() => _HoldingFormState();
}

class _HoldingFormState extends ConsumerState<HoldingForm> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(text: widget.initialHolding?.name ?? '');
  late final _priceCtrl = TextEditingController(
    text: widget.initialHolding?.price.toStringAsFixed(4) ?? '',
  );
  late final _quantityCtrl = TextEditingController(
    text: widget.initialHolding?.quantity.toString() ?? '',
  );
  late final _notesCtrl = TextEditingController(text: widget.initialHolding?.notes ?? '');
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _quantityCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(assetRepositoryProvider);
      if (widget.initialHolding == null) {
        await repo.insertHolding(
          assetId: widget.assetId,
          name: _nameCtrl.text.trim(),
          price: double.parse(_priceCtrl.text.trim()),
          quantity: double.parse(_quantityCtrl.text.trim()),
          notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        );
      } else {
        await repo.updateHolding(widget.initialHolding!.copyWith(
          name: _nameCtrl.text.trim(),
          price: double.parse(_priceCtrl.text.trim()),
          quantity: double.parse(_quantityCtrl.text.trim()),
          notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
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
              Text(widget.initialHolding == null ? '添加持仓' : '编辑持仓',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: '名称 *'),
                validator: (v) => validateRequired(v, fieldName: '名称'),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(labelText: '单价 *'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => validatePositiveNumber(v, fieldName: '单价'),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _quantityCtrl,
                decoration: const InputDecoration(labelText: '数量 *'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => validatePositiveNumber(v, fieldName: '数量'),
              ),
              const SizedBox(height: AppSpacing.sm),
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
                    : Text(widget.initialHolding == null ? '添加' : '保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
