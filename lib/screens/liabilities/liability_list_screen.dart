import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import '../../widgets/forms/backend_liability_form.dart';

class LiabilityListScreen extends ConsumerWidget {
  const LiabilityListScreen({super.key});

  void _showForm(BuildContext context, {BackendLiability? liability}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BackendLiabilityForm(initialLiability: liability),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liabilitiesAsync = ref.watch(backendLiabilitiesProvider);
    final types = ref.watch(backendLiabilityTypesProvider).valueOrNull ?? [];
    final persons = ref.watch(backendPersonsProvider).valueOrNull ?? [];
    final typeMap = {for (final type in types) type.id: type.label};
    final personMap = {for (final person in persons) person.id: person.name};

    return Scaffold(
      appBar: AppBar(
        title: const Text('负债管理'),
        actions: [
          IconButton(
            tooltip: '刷新',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(backendLiabilitiesProvider),
          ),
        ],
      ),
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

          final total = liabilities.fold(0.0, (s, l) => s + _amount(l));
          return Column(
            children: [
              Container(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Text('共 ${liabilities.length} 笔'),
                    const Spacer(),
                    Text('合计 ${formatCNY(total)}',
                        style: const TextStyle(
                          color: AppColors.liabilityColor,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: liabilities.length,
                  itemBuilder: (context, index) {
                    final liability = liabilities[index];
                    return _LiabilityCard(
                      liability: liability,
                      typeName: typeMap[liability.typeId] ?? '未知类型',
                      personName: liability.personId == null
                          ? null
                          : personMap[liability.personId],
                      onEdit: () => _showForm(context, liability: liability),
                      onDelete: () => _deleteLiability(context, ref, liability),
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

  Future<void> _deleteLiability(
    BuildContext context,
    WidgetRef ref,
    BackendLiability liability,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: '删除负债',
      content: '确认删除「${liability.name}」？此操作无法撤销。',
      isDestructive: true,
    );
    if (!confirmed) return;
    final token = ref.read(authProvider).valueOrNull?.accessToken;
    if (token == null) return;
    await ref
        .read(backendAssetApiProvider)
        .deleteLiability(token, liability.id);
    ref.invalidate(backendLiabilitiesProvider);
  }
}

class _LiabilityCard extends StatelessWidget {
  final BackendLiability liability;
  final String typeName;
  final String? personName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _LiabilityCard({
    required this.liability,
    required this.typeName,
    required this.personName,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.credit_card_rounded,
                color: AppColors.liabilityColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(liability.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    [
                      typeName,
                      if (liability.dueDate != null)
                        '到期 ${formatDate(liability.dueDate!)}',
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
              formatCNY(_amount(liability)),
              style: const TextStyle(
                color: AppColors.liabilityColor,
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

double _amount(BackendLiability liability) =>
    double.tryParse(liability.amount) ?? 0;
