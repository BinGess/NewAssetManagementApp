import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/asset.dart';
import '../../providers/data_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/assets/asset_list_tile.dart';
import '../../widgets/common/app_empty_state.dart';
import '../../widgets/common/app_loading.dart';
import '../../widgets/common/confirm_dialog.dart';
import '../../widgets/forms/asset_form.dart';

// ── Sort options ──────────────────────────────────────────────────────────────

enum _AssetSort {
  timeDesc('时间↓'),
  timeAsc('时间↑'),
  amountDesc('金额↓'),
  amountAsc('金额↑'),
  byPerson('按人员');

  const _AssetSort(this.label);
  final String label;
}

// ─────────────────────────────────────────────────────────────────────────────

class AssetListScreen extends ConsumerStatefulWidget {
  const AssetListScreen({super.key});

  @override
  ConsumerState<AssetListScreen> createState() => _AssetListScreenState();
}

class _AssetListScreenState extends ConsumerState<AssetListScreen> {
  _AssetSort _sortOption = _AssetSort.timeDesc;

  void _showAddForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AssetForm(),
    );
  }

  void _showEditForm(Asset asset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AssetForm(initialAsset: asset),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _SortSheet(
          current: _sortOption,
          onSelected: (s) {
            setState(() => _sortOption = s);
            Navigator.of(ctx).pop();
          },
        );
      },
    );
  }

  List<Asset> _sorted(List<Asset> raw) {
    final list = [...raw];
    switch (_sortOption) {
      case _AssetSort.timeDesc:
        list.sort((a, b) => b.valuationDate.compareTo(a.valuationDate));
      case _AssetSort.timeAsc:
        list.sort((a, b) => a.valuationDate.compareTo(b.valuationDate));
      case _AssetSort.amountDesc:
        list.sort((a, b) => b.amount.compareTo(a.amount));
      case _AssetSort.amountAsc:
        list.sort((a, b) => a.amount.compareTo(b.amount));
      case _AssetSort.byPerson:
        // null personId assets go last
        list.sort((a, b) {
          if (a.personId == null && b.personId == null) return 0;
          if (a.personId == null) return 1;
          if (b.personId == null) return -1;
          return a.personId!.compareTo(b.personId!);
        });
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final assetsAsync = ref.watch(assetsStreamProvider);
    final assetTypesAsync = ref.watch(assetTypesStreamProvider);
    final personsAsync = ref.watch(personsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('资产管理'),
        actions: [
          // Sort button
          IconButton(
            tooltip: '排序',
            icon: Stack(
              children: [
                const Icon(Icons.sort_rounded),
                if (_sortOption != _AssetSort.timeDesc)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _showSortSheet,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddForm,
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
                onPressed: _showAddForm,
                child: const Text('添加资产'),
              ),
            );
          }

          final typeMap = assetTypesAsync.valueOrNull
                  ?.fold<Map<int, String>>({}, (m, t) => m..[t.id] = t.label) ??
              {};
          final personMap = personsAsync.valueOrNull
                  ?.fold<Map<int, String>>({}, (m, p) => m..[p.id] = p.name) ??
              {};

          final sorted = _sorted(assets);

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: sorted.length,
            itemBuilder: (context, index) {
              final asset = sorted[index];
              return AssetListTile(
                asset: asset,
                typeName: typeMap[asset.typeId] ?? '未知类型',
                personName: asset.personId != null
                    ? personMap[asset.personId]
                    : null,
                onTap: () => context.push('/assets/${asset.id}'),
                onEdit: () => _showEditForm(asset),
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

// ── Sort bottom sheet ─────────────────────────────────────────────────────────

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
        border: Border(top: BorderSide(color: AppColors.glassBorder, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.glassDivider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                const Text(
                  '排序方式',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('取消',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.glassDivider),
          ...(_AssetSort.values.map((s) {
            final isSelected = s == current;
            return InkWell(
              onTap: () => onSelected(s),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: 14),
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                child: Row(
                  children: [
                    Icon(
                      _sortIcon(s),
                      size: 18,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      s.label,
                      style: TextStyle(
                        fontSize: 15,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    if (isSelected)
                      const Icon(Icons.check_rounded,
                          color: AppColors.primary, size: 18),
                  ],
                ),
              ),
            );
          })),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  IconData _sortIcon(_AssetSort s) => switch (s) {
        _AssetSort.timeDesc => Icons.access_time_rounded,
        _AssetSort.timeAsc => Icons.history_rounded,
        _AssetSort.amountDesc => Icons.trending_down_rounded,
        _AssetSort.amountAsc => Icons.trending_up_rounded,
        _AssetSort.byPerson => Icons.people_outline_rounded,
      };
}
