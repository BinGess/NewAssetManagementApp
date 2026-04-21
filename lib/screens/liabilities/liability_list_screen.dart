import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/liability.dart';
import '../../providers/data_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/common/app_empty_state.dart';
import '../../widgets/common/app_loading.dart';
import '../../widgets/common/confirm_dialog.dart';
import '../../widgets/forms/liability_form.dart';
import '../../widgets/liabilities/liability_list_tile.dart';

class LiabilityListScreen extends ConsumerWidget {
  const LiabilityListScreen({super.key});

  void _showForm(BuildContext context, {Liability? liability}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => LiabilityForm(initialLiability: liability),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liabilitiesAsync = ref.watch(liabilitiesStreamProvider);
    final liabilityTypesAsync = ref.watch(liabilityTypesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('负债管理')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add),
      ),
      body: liabilitiesAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (liabilities) {
          if (liabilities.isEmpty) {
            return AppEmptyState(
              icon: Icons.credit_card_outlined,
              title: '还没有负债',
              subtitle: '点击右下角按钮添加您的第一笔负债',
              action: ElevatedButton(
                onPressed: () => _showForm(context),
                child: const Text('添加负债'),
              ),
            );
          }

          final typeMap = liabilityTypesAsync.valueOrNull
                  ?.fold<Map<int, String>>({}, (m, t) => m..[t.id] = t.label) ??
              {};

          // Summary card
          final total = liabilities.fold(0.0, (s, l) => s + l.amount);
          final overdueCount = liabilities.where((l) => l.isOverdue).length;

          return Column(
            children: [
              // Summary banner
              Container(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    Text('共 ${liabilities.length} 笔',
                        style: Theme.of(context).textTheme.bodySmall),
                    if (overdueCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('$overdueCount 笔已逾期',
                            style: const TextStyle(fontSize: 11, color: Colors.red)),
                      ),
                    ],
                    const Spacer(),
                    Text('合计: ',
                        style: Theme.of(context).textTheme.bodySmall),
                    Text(
                      liabilities.isNotEmpty
                          ? '¥${(total / 10000).toStringAsFixed(2)}万'
                          : '¥0',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: liabilities.length,
                  itemBuilder: (context, index) {
                    final liability = liabilities[index];
                    return LiabilityListTile(
                      liability: liability,
                      typeName: typeMap[liability.typeId] ?? '未知类型',
                      onEdit: () => _showForm(context, liability: liability),
                      onDelete: () async {
                        final confirmed = await showConfirmDialog(
                          context,
                          title: '删除负债',
                          content: '确认删除「${liability.name}」？此操作无法撤销。',
                          isDestructive: true,
                        );
                        if (confirmed) {
                          await ref.read(liabilityRepositoryProvider).delete(liability.id);
                          await ref.read(dashboardServiceProvider).recordSnapshot();
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
