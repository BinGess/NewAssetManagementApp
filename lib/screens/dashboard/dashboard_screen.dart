import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/common/app_loading.dart';
import '../../widgets/dashboard/breakdown_section.dart';
import '../../widgets/dashboard/net_worth_card.dart';
import '../../widgets/dashboard/trend_chart.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('资产总览'),
        centerTitle: false,
      ),
      body: summaryAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (summary) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardSummaryProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              NetWorthCard(summary: summary),
              const SizedBox(height: AppSpacing.md),
              const TrendChart(),
              const SizedBox(height: AppSpacing.md),
              BreakdownSection(
                title: '资产构成',
                items: summary.assetsByType,
                total: summary.totalAssets,
                barColor: AppColors.assetColor,
              ),
              if (summary.liabilitiesByType.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                BreakdownSection(
                  title: '负债构成',
                  items: summary.liabilitiesByType,
                  total: summary.totalLiabilities,
                  barColor: AppColors.liabilityColor,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
