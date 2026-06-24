import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/utils/validators.dart';
import '../../data/services/backend_asset_api.dart';
import '../../providers/auth_provider.dart';
import '../../providers/backend_data_providers.dart';
import '../common/form_sheet.dart';

class BackendPersonForm extends ConsumerStatefulWidget {
  final BackendPerson? initialPerson;

  const BackendPersonForm({super.key, this.initialPerson});

  @override
  ConsumerState<BackendPersonForm> createState() => _BackendPersonFormState();
}

class _BackendPersonFormState extends ConsumerState<BackendPersonForm> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl =
      TextEditingController(text: widget.initialPerson?.name ?? '');
  late bool _enabled = widget.initialPerson?.enabled ?? true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final token = ref.read(authProvider).valueOrNull?.accessToken;
    if (token == null) return;

    setState(() => _isSubmitting = true);
    try {
      final api = ref.read(backendAssetApiProvider);
      final name = _nameCtrl.text.trim();
      final initial = widget.initialPerson;
      if (initial == null) {
        await api.createPerson(
          token,
          BackendPersonCreate(name: name, enabled: _enabled),
        );
      } else {
        await api.updatePerson(
          token,
          personId: initial.id,
          input: BackendPersonUpdate(
            version: initial.version,
            name: name,
            enabled: _enabled,
          ),
        );
      }
      ref.invalidate(backendPersonsProvider);
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
    final isEditing = widget.initialPerson != null;
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
            const SizedBox(height: AppSpacing.sm),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('启用'),
              value: _enabled,
              onChanged: (v) => setState(() => _enabled = v),
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
                  : Text(isEditing ? '保存' : '添加'),
            ),
          ],
        ),
      ),
    );
  }
}
