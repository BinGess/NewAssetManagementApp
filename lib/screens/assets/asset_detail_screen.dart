import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/asset.dart';
import '../../data/models/asset_change.dart';
import '../../data/models/asset_holding.dart';
import '../../providers/data_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/app_empty_state.dart';
import '../../widgets/common/app_loading.dart';
import '../../widgets/common/confirm_dialog.dart';
import '../../widgets/forms/asset_form.dart';
import '../../widgets/forms/holding_form.dart';

class AssetDetailScreen extends ConsumerWidget {
  final int assetId;

  const AssetDetailScreen({super.key, required this.assetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.watch(assetsStreamProvider);
    final holdingsAsync = ref.watch(assetHoldingsProvider(assetId));
    final changesAsync = ref.watch(assetChangesProvider(assetId));

    final asset = assetsAsync.valueOrNull?.where((a) => a.id == assetId).firstOrNull;

    if (assetsAsync.isLoading) return const Scaffold(body: AppLoading());
    if (asset == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('资产详情')),
        body: const AppEmptyState(icon: Icons.error_outline, title: '资产不存在'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(asset.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => AssetForm(initialAsset: asset),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // --- Header Card ---
                _HeaderCard(asset: asset),
                const SizedBox(height: AppSpacing.md),

                // --- Earnings Card (only if annualRate is set) ---
                if (asset.dailyEarnings != null) ...[
                  _EarningsCard(asset: asset),
                  const SizedBox(height: AppSpacing.md),
                ],

                // --- Holdings ---
                _HoldingsSection(asset: asset, holdingsAsync: holdingsAsync),
                const SizedBox(height: AppSpacing.md),

                // --- Change History ---
                _ChangeHistorySection(changesAsync: changesAsync),
                const SizedBox(height: AppSpacing.lg),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final Asset asset;
  const _HeaderCard({required this.asset});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatCNY(asset.amount),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.assetColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            asset.currency,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const Divider(height: AppSpacing.lg),
          _InfoRow(label: '估值日期', value: formatDate(asset.valuationDate)),
          if (asset.annualRate != null)
            _InfoRow(label: '年化利率', value: formatRate(asset.annualRate!)),
          if (asset.startDate != null)
            _InfoRow(label: '起息日期', value: formatDate(asset.startDate!)),
          if (asset.notes != null && asset.notes!.isNotEmpty)
            _InfoRow(label: '备注', value: asset.notes!),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _EarningsCard extends StatelessWidget {
  final Asset asset;
  const _EarningsCard({required this.asset});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('收益估算',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  )),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _EarningsItem(label: '日收益', value: formatCNY(asset.dailyEarnings!)),
              _EarningsItem(label: '月收益', value: formatCNY(asset.monthlyEarnings!)),
              _EarningsItem(label: '年收益', value: formatCNY(asset.yearlyEarnings!)),
            ],
          ),
          if (asset.cumulativeEarnings != null) ...[
            const Divider(height: AppSpacing.lg),
            Row(
              children: [
                Text('累计收益', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                const Spacer(),
                Text(formatCNY(asset.cumulativeEarnings!),
                    style: const TextStyle(color: AppColors.assetColor, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _EarningsItem extends StatelessWidget {
  final String label;
  final String value;
  const _EarningsItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.assetColor,
                  )),
        ],
      ),
    );
  }
}

class _HoldingsSection extends ConsumerWidget {
  final Asset asset;
  final AsyncValue<List<AssetHolding>> holdingsAsync;

  const _HoldingsSection({required this.asset, required this.holdingsAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('持仓明细',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      )),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (_) => HoldingForm(assetId: asset.id),
                  );
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('添加'),
              ),
            ],
          ),
          holdingsAsync.when(
            loading: () => const Padding(padding: EdgeInsets.all(8), child: LinearProgressIndicator()),
            error: (_, __) => const Text('加载失败'),
            data: (holdings) => holdings.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: Text('暂无持仓', style: TextStyle(color: AppColors.textSecondary))),
                  )
                : Column(
                    children: holdings.map((h) => _HoldingRow(holding: h)).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _HoldingRow extends ConsumerWidget {
  final AssetHolding holding;
  const _HoldingRow({required this.holding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(holding.name),
      subtitle: Text('${holding.quantity} × ${formatCNY(holding.price)}',
          style: const TextStyle(fontSize: 12)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(formatCNY(holding.totalValue),
              style: const TextStyle(fontWeight: FontWeight.w500)),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 16),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('编辑')),
              const PopupMenuItem(value: 'delete', child: Text('删除', style: TextStyle(color: Colors.red))),
            ],
            onSelected: (value) async {
              if (value == 'edit') {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (_) => HoldingForm(assetId: holding.assetId, initialHolding: holding),
                );
              } else if (value == 'delete') {
                final confirmed = await showConfirmDialog(
                  context,
                  title: '删除持仓',
                  content: '确认删除「${holding.name}」？',
                  isDestructive: true,
                );
                if (confirmed) {
                  await ref.read(assetRepositoryProvider).deleteHolding(holding.id);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ChangeHistorySection extends StatelessWidget {
  final AsyncValue<List<AssetChange>> changesAsync;
  const _ChangeHistorySection({required this.changesAsync});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('变更记录',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  )),
          changesAsync.when(
            loading: () => const Padding(padding: EdgeInsets.all(8), child: LinearProgressIndicator()),
            error: (_, __) => const Text('加载失败'),
            data: (changes) {
              if (changes.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: Text('暂无变更记录', style: TextStyle(color: AppColors.textSecondary))),
                );
              }
              return Column(
                children: [
                  for (var i = 0; i < changes.length; i++)
                    _ChangeRow(change: changes[i], isLast: i == changes.length - 1),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ChangeRow extends StatelessWidget {
  final AssetChange change;
  final bool isLast;
  const _ChangeRow({required this.change, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isIncrease = change.isIncrease;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isIncrease ? AppColors.assetColor : AppColors.liabilityColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: Colors.grey.shade200),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${formatCNY(change.beforeAmount)} → ${formatCNY(change.afterAmount)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Spacer(),
                      Text(
                        '${isIncrease ? '+' : ''}${formatCNY(change.difference)}',
                        style: TextStyle(
                          color: isIncrease ? AppColors.assetColor : AppColors.liabilityColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    formatDate(change.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
