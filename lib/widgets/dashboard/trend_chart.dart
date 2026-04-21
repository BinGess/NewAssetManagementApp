import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/data_providers.dart';
import '../common/app_card.dart';

class TrendChart extends ConsumerStatefulWidget {
  const TrendChart({super.key});

  @override
  ConsumerState<TrendChart> createState() => _TrendChartState();
}

class _TrendChartState extends ConsumerState<TrendChart> {
  String _period = '30d';

  @override
  Widget build(BuildContext context) {
    final snapshotsAsync = ref.watch(snapshotsForPeriodProvider(_period));

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.7),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '净资产趋势',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Period selector
              Container(
                decoration: BoxDecoration(
                  color: AppColors.glass,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PeriodButton(label: '30天', value: '30d', selected: _period, onTap: (v) => setState(() => _period = v)),
                    _PeriodButton(label: '6月', value: '6m', selected: _period, onTap: (v) => setState(() => _period = v)),
                    _PeriodButton(label: '1年', value: '1y', selected: _period, onTap: (v) => setState(() => _period = v)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Chart area
          SizedBox(
            height: 160,
            child: snapshotsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              ),
              error: (_, __) => const Center(
                child: Text(
                  '加载失败',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
              data: (snapshots) {
                if (snapshots.length < 2) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.show_chart_rounded,
                            color: AppColors.textMuted, size: 32),
                        SizedBox(height: 8),
                        Text(
                          '暂无趋势数据\n添加资产后自动记录',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }
                return _buildChart(
                  snapshots
                      .map((s) => FlSpot(
                            s.createdAt.millisecondsSinceEpoch.toDouble(),
                            s.netWorth,
                          ))
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(List<FlSpot> spots) {
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.15 + 1;
    final isPositive = spots.last.y >= spots.first.y;
    final lineColor = isPositive ? AppColors.assetColor : AppColors.liabilityColor;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY + padding * 2) / 4,
          getDrawingHorizontalLine: (_) => const FlLine(
            color: AppColors.glassDivider,
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 64,
              getTitlesWidget: (value, _) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  formatCNY(value),
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.textMuted,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: spots.first.x,
        maxX: spots.last.x,
        minY: minY - padding,
        maxY: maxY + padding,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: lineColor,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: spots.length <= 15,
              getDotPainter: (spot, pct, bar, idx) => FlDotCirclePainter(
                radius: 3,
                color: lineColor,
                strokeWidth: 2,
                strokeColor: AppColors.bgBase,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  lineColor.withValues(alpha: 0.22),
                  lineColor.withValues(alpha: 0.0),
                ],
              ),
            ),
            shadow: Shadow(
              color: lineColor.withValues(alpha: 0.4),
              blurRadius: 8,
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AppColors.bgMid,
            tooltipBorder: const BorderSide(color: AppColors.glassBorder),
            tooltipRoundedRadius: 8,
            getTooltipItems: (spots) => spots.map((spot) {
              return LineTooltipItem(
                formatCNY(spot.y),
                TextStyle(
                  color: lineColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ─── Period toggle button ─────────────────────────────────────────────────────
class _PeriodButton extends StatelessWidget {
  final String label;
  final String value;
  final String selected;
  final ValueChanged<String> onTap;

  const _PeriodButton({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            color: isSelected ? AppColors.primary : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
