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
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '资产总览',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              '个人财务管理',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
            onPressed: () => ref.invalidate(dashboardSummaryProvider),
            tooltip: '刷新',
          ),
        ],
      ),
      body: summaryAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => Center(
          child: Text('加载失败: $e',
              style: const TextStyle(color: AppColors.textSecondary)),
        ),
        data: (summary) => RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.bgMid,
          onRefresh: () async => ref.invalidate(dashboardSummaryProvider),
          child: ListView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + kToolbarHeight + AppSpacing.md,
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.xl,
            ),
            children: [
              // Hero net worth card
              NetWorthCard(summary: summary),
              const SizedBox(height: AppSpacing.md),

              // Trend chart
              const TrendChart(),
              const SizedBox(height: AppSpacing.md),

              // Asset breakdown
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
            ],
          ),
        ),
      ),
    );
  }
}
