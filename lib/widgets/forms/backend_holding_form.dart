import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/utils/validators.dart';
import '../../data/services/backend_asset_api.dart';
import '../../providers/auth_provider.dart';
import '../../providers/backend_data_providers.dart';
import '../common/form_sheet.dart';

class BackendHoldingForm extends ConsumerStatefulWidget {
  final String assetId;
  final BackendHolding? initialHolding;

  const BackendHoldingForm({
    super.key,
    required this.assetId,
    this.initialHolding,
  });

  @override
  ConsumerState<BackendHoldingForm> createState() => _BackendHoldingFormState();
}

class _BackendHoldingFormState extends ConsumerState<BackendHoldingForm> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl =
      TextEditingController(text: widget.initialHolding?.name ?? '');
  late final _priceCtrl =
      TextEditingController(text: widget.initialHolding?.price ?? '');
  late final _quantityCtrl =
      TextEditingController(text: widget.initialHolding?.quantity ?? '');
  late final _notesCtrl =
      TextEditingController(text: widget.initialHolding?.notes ?? '');
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
    final token = ref.read(authProvider).valueOrNull?.accessToken;
    if (token == null) return;

    setState(() => _isSubmitting = true);
    try {
      final api = ref.read(backendAssetApiProvider);
      final notes =
          _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim();
      final initial = widget.initialHolding;
      if (initial == null) {
        await api.createHolding(
          token,
          assetId: widget.assetId,
          input: BackendHoldingCreate(
            name: _nameCtrl.text.trim(),
            price: _priceCtrl.text.trim(),
            quantity: _quantityCtrl.text.trim(),
            notes: notes,
          ),
        );
      } else {
        await api.updateHolding(
          token,
          assetId: widget.assetId,
          holdingId: initial.id,
          input: BackendHoldingUpdate(
            version: initial.version,
            name: _nameCtrl.text.trim(),
            price: _priceCtrl.text.trim(),
            quantity: _quantityCtrl.text.trim(),
            notes: notes,
          ),
        );
      }
      ref.invalidate(backendHoldingsProvider(widget.assetId));
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
    return FormSheet(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.initialHolding == null ? '添加持仓' : '编辑持仓',
              style: Theme.of(context).textTheme.titleLarge,
            ),
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
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => validatePositiveNumber(v, fieldName: '单价'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _quantityCtrl,
              decoration: const InputDecoration(labelText: '数量 *'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.initialHolding == null ? '添加' : '保存'),
            ),
          ],
        ),
      ),
    );
  }
}
