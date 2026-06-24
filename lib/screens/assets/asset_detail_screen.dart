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
import '../../widgets/forms/backend_asset_form.dart';
import '../../widgets/forms/backend_holding_form.dart';

class AssetDetailScreen extends ConsumerWidget {
  final String assetId;

  const AssetDetailScreen({super.key, required this.assetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.watch(backendAssetsProvider);
    final holdingsAsync = ref.watch(backendHoldingsProvider(assetId));
    final persons = ref.watch(backendPersonsProvider).valueOrNull ?? [];
    final personMap = {for (final person in persons) person.id: person.name};
    final asset = assetsAsync.valueOrNull
        ?.where((candidate) => candidate.id == assetId)
        .firstOrNull;

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
                backgroundColor: Colors.transparent,
                builder: (_) => BackendAssetForm(initialAsset: asset),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(backendAssetsProvider);
          ref.invalidate(backendHoldingsProvider(assetId));
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            _HeaderCard(
              asset: asset,
              personName:
                  asset.personId == null ? null : personMap[asset.personId],
            ),
            const SizedBox(height: AppSpacing.md),
            _HoldingsSection(asset: asset, holdingsAsync: holdingsAsync),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final BackendAsset asset;
  final String? personName;

  const _HeaderCard({required this.asset, this.personName});

  @override
  Widget build(BuildContext context) {
    final annualRate = double.tryParse(asset.annualRate ?? '');
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  formatCNY(_amount(asset)),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.assetColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              if (personName != null)
                Chip(
                  avatar: const Icon(Icons.person_outline_rounded, size: 14),
                  label: Text(personName!),
                ),
            ],
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
          if (annualRate != null)
            _InfoRow(label: '年化利率', value: formatRate(annualRate)),
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
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HoldingsSection extends ConsumerWidget {
  final BackendAsset asset;
  final AsyncValue<List<BackendHolding>> holdingsAsync;

  const _HoldingsSection({
    required this.asset,
    required this.holdingsAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '持仓明细',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => BackendHoldingForm(assetId: asset.id),
                  );
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('添加'),
              ),
            ],
          ),
          holdingsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(8),
              child: LinearProgressIndicator(),
            ),
            error: (error, _) => Text('加载失败: $error'),
            data: (holdings) {
              if (holdings.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      '暂无持仓',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                );
              }
              return Column(
                children: holdings
                    .map((holding) => _HoldingRow(holding: holding))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HoldingRow extends ConsumerWidget {
  final BackendHolding holding;

  const _HoldingRow({required this.holding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(holding.name),
      subtitle: Text(
        '${holding.quantity} × ${formatCNY(_price(holding))}',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            formatCNY(_totalValue(holding)),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 16),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('编辑')),
              PopupMenuItem(
                value: 'delete',
                child: Text('删除', style: TextStyle(color: Colors.red)),
              ),
            ],
            onSelected: (value) async {
              if (value == 'edit') {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => BackendHoldingForm(
                    assetId: holding.assetId,
                    initialHolding: holding,
                  ),
                );
              } else if (value == 'delete') {
                await _deleteHolding(context, ref);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteHolding(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: '删除持仓',
      content: '确认删除「${holding.name}」？',
      isDestructive: true,
    );
    if (!confirmed) return;
    final token = ref.read(authProvider).valueOrNull?.accessToken;
    if (token == null) return;
    await ref.read(backendAssetApiProvider).deleteHolding(
          token,
          assetId: holding.assetId,
          holdingId: holding.id,
        );
    ref.invalidate(backendHoldingsProvider(holding.assetId));
  }
}

double _amount(BackendAsset asset) => double.tryParse(asset.amount) ?? 0;
double _price(BackendHolding holding) => double.tryParse(holding.price) ?? 0;
double _quantity(BackendHolding holding) =>
    double.tryParse(holding.quantity) ?? 0;
double _totalValue(BackendHolding holding) =>
    _price(holding) * _quantity(holding);
