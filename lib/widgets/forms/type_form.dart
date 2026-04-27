import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/validators.dart';
import '../../data/models/asset_type.dart';
import '../../data/models/liability_type.dart';
import '../../providers/repository_providers.dart';
import '../common/form_sheet.dart';

// ─── Generic Type Form (asset or liability) ───────────────────────────────────

enum _TypeKind { asset, liability }

/// Dialog form for creating/editing an asset type or liability type.
/// Pass [initialAssetType] OR [initialLiabilityType]; not both.
class TypeForm extends ConsumerStatefulWidget {
  final AssetType? initialAssetType;
  final LiabilityType? initialLiabilityType;

  const TypeForm.forAsset({super.key, this.initialAssetType})
      : initialLiabilityType = null;

  const TypeForm.forLiability({super.key, this.initialLiabilityType})
      : initialAssetType = null;

  @override
  ConsumerState<TypeForm> createState() => _TypeFormState();
}

class _TypeFormState extends ConsumerState<TypeForm> {
  final _formKey = GlobalKey<FormState>();
  late final _codeCtrl = TextEditingController(
    text: widget.initialAssetType?.code ??
        widget.initialLiabilityType?.code ??
        '',
  );
  late final _labelCtrl = TextEditingController(
    text: widget.initialAssetType?.label ??
        widget.initialLiabilityType?.label ??
        '',
  );
  late bool _enabled =
      widget.initialAssetType?.enabled ??
      widget.initialLiabilityType?.enabled ??
      true;
  bool _isSubmitting = false;

  _TypeKind get _kind => widget.initialLiabilityType != null ||
          (widget.initialAssetType == null && widget.initialLiabilityType == null &&
              _isLiabilityContext)
      ? _TypeKind.liability
      : _TypeKind.asset;

  // Determined by which constructor was used
  bool get _isLiabilityContext => widget.initialAssetType == null;

  bool get _isEditing =>
      widget.initialAssetType != null || widget.initialLiabilityType != null;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _labelCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      final code = _codeCtrl.text.trim();
      final label = _labelCtrl.text.trim();

      if (_kind == _TypeKind.asset) {
        final repo = ref.read(assetTypeRepositoryProvider);
        if (widget.initialAssetType == null) {
          await repo.insert(code, label);
        } else {
          await repo.update(widget.initialAssetType!.copyWith(
            code: code,
            label: label,
            enabled: _enabled,
          ));
        }
      } else {
        final repo = ref.read(liabilityTypeRepositoryProvider);
        if (widget.initialLiabilityType == null) {
          await repo.insert(code, label);
        } else {
          await repo.update(widget.initialLiabilityType!.copyWith(
            code: code,
            label: label,
            enabled: _enabled,
          ));
        }
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
    final title = _isEditing
        ? (_kind == _TypeKind.asset ? '编辑资产类型' : '编辑负债类型')
        : (_kind == _TypeKind.asset ? '添加资产类型' : '添加负债类型');

    return FormSheet(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _codeCtrl,
              decoration: const InputDecoration(labelText: '代码 *'),
              validator: (v) => validateRequired(v, fieldName: '代码'),
            ),
            const SizedBox(height: AppSpacing.sm),

            TextFormField(
              controller: _labelCtrl,
              decoration: const InputDecoration(labelText: '名称 *'),
              validator: (v) => validateRequired(v, fieldName: '名称'),
            ),

            if (_isEditing) ...[
              const SizedBox(height: AppSpacing.sm),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('启用'),
                value: _enabled,
                onChanged: (v) => setState(() => _enabled = v),
              ),
            ],

            const SizedBox(height: AppSpacing.lg),

            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(_isEditing ? '保存' : '添加'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Person Form ──────────────────────────────────────────────────────────────

class PersonForm extends ConsumerStatefulWidget {
  final String? initialName;
  final bool? initialEnabled;
  final int? personId; // non-null = edit mode

  const PersonForm({
    super.key,
    this.initialName,
    this.initialEnabled,
    this.personId,
  });

  @override
  ConsumerState<PersonForm> createState() => _PersonFormState();
}

class _PersonFormState extends ConsumerState<PersonForm> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl =
      TextEditingController(text: widget.initialName ?? '');
  late bool _enabled = widget.initialEnabled ?? true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(personRepositoryProvider);
      final name = _nameCtrl.text.trim();

      if (widget.personId == null) {
        await repo.insert(name);
      } else {
        // Fetch existing to preserve createdAt, then update
        final all = await repo.getAll();
        final existing = all.firstWhere((p) => p.id == widget.personId);
        await repo.update(existing.copyWith(name: name, enabled: _enabled));
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
    final isEditing = widget.personId != null;
    return FormSheet(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isEditing ? '编辑人员' : '添加人员',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: '姓名 *'),
              validator: (v) => validateRequired(v, fieldName: '姓名'),
            ),

            if (isEditing) ...[
              const SizedBox(height: AppSpacing.sm),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('启用'),
                value: _enabled,
                onChanged: (v) => setState(() => _enabled = v),
              ),
            ],

            const SizedBox(height: AppSpacing.lg),

            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(isEditing ? '保存' : '添加'),
            ),
          ],
        ),
      ),
    );
  }
}
