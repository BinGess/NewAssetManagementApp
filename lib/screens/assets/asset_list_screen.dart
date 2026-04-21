import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/asset.dart';
import '../../providers/data_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/assets/asset_list_tile.dart';
import '../../widgets/common/app_empty_state.dart';
import '../../widgets/common/app_loading.dart';
import '../../widgets/common/confirm_dialog.dart';
import '../../widgets/forms/asset_form.dart';

class AssetListScreen extends ConsumerWidget {
  const AssetListScreen({super.key});

  void _showAddForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const AssetForm(),
    );
  }

  void _showEditForm(BuildContext context, Asset asset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AssetForm(initialAsset: asset),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.watch(assetsStreamProvider);
    final assetTypesAsync = ref.watch(assetTypesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('资产管理')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddForm(context),
        child: const Icon(Icons.add),
      ),
      body: assetsAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (assets) {
          if (assets.isEmpty) {
            return AppEmptyState(
              icon: Icons.account_balance_wallet_outlined,
              title: '还没有资产',
              subtitle: '点击右下角按钮添加您的第一笔资产',
              action: ElevatedButton(
                onPressed: () => _showAddForm(context),
                child: const Text('添加资产'),
              ),
            );
          }

          // Build a type id → name lookup map
          final typeMap = assetTypesAsync.valueOrNull
                  ?.fold<Map<int, String>>({}, (m, t) => m..[t.id] = t.label) ??
              {};

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: assets.length,
            itemBuilder: (context, index) {
              final asset = assets[index];
              return AssetListTile(
                asset: asset,
                typeName: typeMap[asset.typeId] ?? '未知类型',
                onTap: () => context.push('/assets/${asset.id}'),
                onEdit: () => _showEditForm(context, asset),
                onDelete: () async {
                  final confirmed = await showConfirmDialog(
                    context,
                    title: '删除资产',
                    content: '确认删除「${asset.name}」？此操作无法撤销。',
                    isDestructive: true,
                  );
                  if (confirmed) {
                    await ref.read(assetRepositoryProvider).delete(asset.id);
                    await ref.read(dashboardServiceProvider).recordSnapshot();
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
