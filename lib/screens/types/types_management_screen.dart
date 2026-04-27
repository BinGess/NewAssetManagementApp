import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/asset_type.dart';
import '../../data/models/liability_type.dart';
import '../../data/models/person.dart';
import '../../providers/data_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/common/app_loading.dart';
import '../../widgets/common/confirm_dialog.dart';
import '../../widgets/forms/type_form.dart';

class TypesManagementScreen extends ConsumerWidget {
  const TypesManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('分类管理'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '资产类型'),
              Tab(text: '负债类型'),
              Tab(text: '人员管理'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _AssetTypesTab(),
            _LiabilityTypesTab(),
            _PersonsTab(),
          ],
        ),
      ),
    );
  }
}

// ─── Asset Types Tab ──────────────────────────────────────────────────────────

class _AssetTypesTab extends ConsumerWidget {
  const _AssetTypesTab();

  void _showForm(BuildContext context, {AssetType? type}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TypeForm.forAsset(initialAssetType: type),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typesAsync = ref.watch(assetTypesStreamProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'add_asset_type',
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add),
      ),
      body: typesAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (types) {
          if (types.isEmpty) {
            return const Center(child: Text('暂无资产类型'));
          }
          return ReorderableListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: types.length,
            onReorder: (oldIndex, newIndex) async {
              if (newIndex > oldIndex) newIndex--;
              final reordered = List<AssetType>.from(types);
              final item = reordered.removeAt(oldIndex);
              reordered.insert(newIndex, item);
              final repo = ref.read(assetTypeRepositoryProvider);
              for (var i = 0; i < reordered.length; i++) {
                await repo.update(reordered[i].copyWith(sortOrder: i));
              }
            },
            itemBuilder: (context, index) {
              final type = types[index];
              return _TypeRow(
                key: ValueKey(type.id),
                title: type.label,
                subtitle: type.code,
                enabled: type.enabled,
                onToggle: () => ref
                    .read(assetTypeRepositoryProvider)
                    .update(type.copyWith(enabled: !type.enabled)),
                onEdit: () => _showForm(context, type: type),
                onDelete: () async {
                  final confirmed = await showConfirmDialog(
                    context,
                    title: '删除资产类型',
                    content: '确认删除「${type.label}」？\n如果有资产使用此类型，删除将失败。',
                    isDestructive: true,
                  );
                  if (confirmed) {
                    try {
                      await ref
                          .read(assetTypeRepositoryProvider)
                          .delete(type.id);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('删除失败: $e'),
                              backgroundColor: Colors.red),
                        );
                      }
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

// ─── Liability Types Tab ──────────────────────────────────────────────────────

class _LiabilityTypesTab extends ConsumerWidget {
  const _LiabilityTypesTab();

  void _showForm(BuildContext context, {LiabilityType? type}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TypeForm.forLiability(initialLiabilityType: type),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typesAsync = ref.watch(liabilityTypesStreamProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'add_liability_type',
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add),
      ),
      body: typesAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (types) {
          if (types.isEmpty) {
            return const Center(child: Text('暂无负债类型'));
          }
          return ReorderableListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: types.length,
            onReorder: (oldIndex, newIndex) async {
              if (newIndex > oldIndex) newIndex--;
              final reordered = List<LiabilityType>.from(types);
              final item = reordered.removeAt(oldIndex);
              reordered.insert(newIndex, item);
              final repo = ref.read(liabilityTypeRepositoryProvider);
              for (var i = 0; i < reordered.length; i++) {
                await repo.update(reordered[i].copyWith(sortOrder: i));
              }
            },
            itemBuilder: (context, index) {
              final type = types[index];
              return _TypeRow(
                key: ValueKey(type.id),
                title: type.label,
                subtitle: type.code,
                enabled: type.enabled,
                onToggle: () => ref
                    .read(liabilityTypeRepositoryProvider)
                    .update(type.copyWith(enabled: !type.enabled)),
                onEdit: () => _showForm(context, type: type),
                onDelete: () async {
                  final confirmed = await showConfirmDialog(
                    context,
                    title: '删除负债类型',
                    content: '确认删除「${type.label}」？\n如果有负债使用此类型，删除将失败。',
                    isDestructive: true,
                  );
                  if (confirmed) {
                    try {
                      await ref
                          .read(liabilityTypeRepositoryProvider)
                          .delete(type.id);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('删除失败: $e'),
                              backgroundColor: Colors.red),
                        );
                      }
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

// ─── Persons Tab ──────────────────────────────────────────────────────────────

class _PersonsTab extends ConsumerWidget {
  const _PersonsTab();

  void _showForm(BuildContext context, {Person? person}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PersonForm(
        personId: person?.id,
        initialName: person?.name,
        initialEnabled: person?.enabled,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personsAsync = ref.watch(personsStreamProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'add_person',
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add),
      ),
      body: personsAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (persons) {
          if (persons.isEmpty) {
            return const Center(child: Text('暂无人员'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: persons.length,
            itemBuilder: (context, index) {
              final person = persons[index];
              return _TypeRow(
                key: ValueKey(person.id),
                title: person.name,
                subtitle: person.enabled ? '启用' : '停用',
                enabled: person.enabled,
                onToggle: () async {
                  final all =
                      await ref.read(personRepositoryProvider).getAll();
                  final existing =
                      all.firstWhere((p) => p.id == person.id);
                  await ref
                      .read(personRepositoryProvider)
                      .update(existing.copyWith(enabled: !person.enabled));
                },
                onEdit: () => _showForm(context, person: person),
                onDelete: () async {
                  final confirmed = await showConfirmDialog(
                    context,
                    title: '删除人员',
                    content: '确认删除「${person.name}」？\n如果有支出关联此人员，删除将失败。',
                    isDestructive: true,
                  );
                  if (confirmed) {
                    try {
                      await ref
                          .read(personRepositoryProvider)
                          .delete(person.id);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('删除失败: $e'),
                              backgroundColor: Colors.red),
                        );
                      }
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

// ─── Shared Row Widget ────────────────────────────────────────────────────────

class _TypeRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TypeRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          Icons.drag_handle,
          color: Theme.of(context).colorScheme.outline,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: enabled ? null : Theme.of(context).colorScheme.outline,
            decoration: enabled ? null : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Text(subtitle,
            style: TextStyle(
                color: Theme.of(context).colorScheme.outline, fontSize: 12)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: enabled,
              onChanged: (_) => onToggle(),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: onEdit,
              tooltip: '编辑',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: onDelete,
              tooltip: '删除',
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
