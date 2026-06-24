import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/services/backend_asset_api.dart';
import '../../providers/auth_provider.dart';
import '../../providers/backend_data_providers.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/app_empty_state.dart';
import '../../widgets/common/app_loading.dart';
import '../../widgets/common/confirm_dialog.dart';
import '../../widgets/forms/backend_asset_form.dart';

enum _AssetSort {
  timeDesc('时间↓'),
  timeAsc('时间↑'),
  amountDesc('金额↓'),
  amountAsc('金额↑'),
  byPerson('按人员');

  const _AssetSort(this.label);
  final String label;
}

class AssetListScreen extends ConsumerStatefulWidget {
  const AssetListScreen({super.key});

  @override
  ConsumerState<AssetListScreen> createState() => _AssetListScreenState();
}

class _AssetListScreenState extends ConsumerState<AssetListScreen> {
  _AssetSort _sortOption = _AssetSort.timeDesc;

  void _showForm({BackendAsset? asset}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BackendAssetForm(initialAsset: asset),
    );
  }

  List<BackendAsset> _sorted(List<BackendAsset> raw) {
    final list = [...raw];
    switch (_sortOption) {
      case _AssetSort.timeDesc:
        list.sort((a, b) => b.valuationDate.compareTo(a.valuationDate));
      case _AssetSort.timeAsc:
        list.sort((a, b) => a.valuationDate.compareTo(b.valuationDate));
      case _AssetSort.amountDesc:
        list.sort((a, b) => _amount(b).compareTo(_amount(a)));
      case _AssetSort.amountAsc:
        list.sort((a, b) => _amount(a).compareTo(_amount(b)));
      case _AssetSort.byPerson:
        list.sort((a, b) => (a.personId ?? '~').compareTo(b.personId ?? '~'));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final assetsAsync = ref.watch(backendAssetsProvider);
    final types = ref.watch(backendAssetTypesProvider).valueOrNull ?? [];
    final persons = ref.watch(backendPersonsProvider).valueOrNull ?? [];
    final typeMap = {for (final type in types) type.id: type.label};
    final personMap = {for (final person in persons) person.id: person.name};

    return Scaffold(
      appBar: AppBar(
        title: const Text('资产管理'),
        actions: [
          IconButton(
            tooltip: '刷新',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(backendAssetsProvider),
          ),
          IconButton(
            tooltip: '排序',
            icon: const Icon(Icons.sort_rounded),
            onPressed: _showSortSheet,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
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
                onPressed: () => _showForm(),
                child: const Text('添加资产'),
              ),
            );
          }

          final sorted = _sorted(assets);
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: sorted.length,
            itemBuilder: (context, index) {
              final asset = sorted[index];
              return _AssetCard(
                asset: asset,
                typeName: typeMap[asset.typeId] ?? '未知类型',
                personName:
                    asset.personId == null ? null : personMap[asset.personId],
                onTap: () => context.push('/assets/${asset.id}'),
                onEdit: () => _showForm(asset: asset),
                onDelete: () => _deleteAsset(asset),
              );
            },
          );
        },
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SortSheet(
        current: _sortOption,
        onSelected: (sort) {
          setState(() => _sortOption = sort);
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  Future<void> _deleteAsset(BackendAsset asset) async {
    final confirmed = await showConfirmDialog(
      context,
      title: '删除资产',
      content: '确认删除「${asset.name}」？此操作无法撤销。',
      isDestructive: true,
    );
    if (!confirmed) return;
    final token = ref.read(authProvider).valueOrNull?.accessToken;
    if (token == null) return;
    await ref.read(backendAssetApiProvider).deleteAsset(token, asset.id);
    ref.invalidate(backendAssetsProvider);
  }
}

class _AssetCard extends StatelessWidget {
  final BackendAsset asset;
  final String typeName;
  final String? personName;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AssetCard({
    required this.asset,
    required this.typeName,
    required this.personName,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        onTap: onTap,
        child: Row(
          children: [
            const Icon(Icons.account_balance_wallet_rounded,
                color: AppColors.assetColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(asset.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    [
                      typeName,
                      formatDate(asset.valuationDate),
                      if (personName != null) personName!,
                    ].join(' · '),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              formatCNY(_amount(asset)),
              style: const TextStyle(
                color: AppColors.assetColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('编辑')),
                PopupMenuItem(value: 'delete', child: Text('删除')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SortSheet extends StatelessWidget {
  final _AssetSort current;
  final ValueChanged<_AssetSort> onSelected;

  const _SortSheet({required this.current, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A2540),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _AssetSort.values
              .map(
                (sort) => ListTile(
                  title: Text(sort.label),
                  trailing:
                      sort == current ? const Icon(Icons.check_rounded) : null,
                  onTap: () => onSelected(sort),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

double _amount(BackendAsset asset) => double.tryParse(asset.amount) ?? 0;
