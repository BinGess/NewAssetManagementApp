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

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '净资产趋势',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: '30d', label: Text('30天')),
                  ButtonSegment(value: '6m', label: Text('6月')),
                  ButtonSegment(value: '1y', label: Text('1年')),
                ],
                selected: {_period},
                onSelectionChanged: (selected) {
                  setState(() => _period = selected.first);
                },
                style: SegmentedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 12),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 180,
            child: snapshotsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator.adaptive()),
              error: (_, __) => Center(
                child: Text(
                  '加载失败',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ),
              data: (snapshots) {
                if (snapshots.length < 2) {
                  return Center(
                    child: Text(
                      '暂无数据',
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  );
                }
                return _buildChart(snapshots
                    .map((s) => FlSpot(
                          s.createdAt.millisecondsSinceEpoch.toDouble(),
                          s.netWorth,
                        ))
                    .toList());
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
    final padding = (maxY - minY) * 0.1;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 4,
          getDrawingHorizontalLine: (_) => FlLine(
            color: Colors.grey.shade100,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) => Text(
                formatCNY(value),
                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
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
            color: AppColors.primary,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: spots.length <= 10,
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots.map((spot) {
              return LineTooltipItem(
                formatCNY(spot.y),
                const TextStyle(
                  color: Colors.white,
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
