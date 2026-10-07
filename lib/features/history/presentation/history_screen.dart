import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:caloout/core/theme/app_colors.dart';
import 'package:caloout/core/utils/calorie_formatter.dart';
import 'package:caloout/core/utils/date_formatter.dart';
import 'package:caloout/l10n/app_localizations.dart';
import 'package:caloout/features/activity/domain/entities/activity_entry.dart';
import 'package:caloout/features/activity/presentation/add_activity_screen.dart';
import 'package:caloout/features/activity/presentation/providers/activity_providers.dart';
import 'package:caloout/features/profile/presentation/providers/profile_provider.dart';
import 'package:caloout/features/history/domain/entities/day_burn_record.dart';
import 'package:caloout/features/history/domain/entities/history_period_summary.dart';
import 'package:caloout/features/history/domain/entities/history_range_type.dart';
import 'package:caloout/features/history/presentation/providers/history_providers.dart';

/// History screen displaying bar charts, trends, and statistics across Day, Week, and Month.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final rangeType = ref.watch(historyRangeTypeProvider);
    final range = ref.watch(historyDateRangeProvider);
    final anchor = ref.watch(historyAnchorDateProvider);
    final canGoNext = ref.watch(canGoForwardProvider);
    final summaryAsync = ref.watch(historyPeriodSummaryProvider);
    final dailyGoal = ref.watch(currentDailyGoalProvider) ?? 2000.0;
    final nav = HistoryNavigationController(ref);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyTitle),
        actions: [
          // Debug Seed Data button only in development
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.auto_fix_high),
              tooltip: 'Tạo dữ liệu mẫu 60 ngày (Debug)',
              onPressed: () async {
                await debugSeedSampleHistoryData(ref);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã tạo thành công dữ liệu mẫu 60 ngày!')),
                  );
                }
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Section: Range Selector & Date Navigator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  // Day / Week / Month Segmented Button
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<HistoryRangeType>(
                      key: const Key('history_range_segmented_button'),
                      segments: [
                        ButtonSegment(
                          value: HistoryRangeType.day,
                          label: Text(l10n.historyDay),
                        ),
                        ButtonSegment(
                          value: HistoryRangeType.week,
                          label: Text(l10n.historyWeek),
                        ),
                        ButtonSegment(
                          value: HistoryRangeType.month,
                          label: Text(l10n.historyMonth),
                        ),
                      ],
                      selected: {rangeType},
                      onSelectionChanged: (set) => nav.setRangeType(set.first),
                      style: const ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Date range label with Previous/Next buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        key: const Key('history_prev_button'),
                        icon: const Icon(Icons.chevron_left),
                        tooltip: l10n.historyPreviousPeriod,
                        onPressed: nav.goToPrevious,
                      ),
                      InkWell(
                        onTap: nav.resetToToday,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Text(
                            _formatPeriodLabel(rangeType, range, anchor, Localizations.localeOf(context).languageCode),
                            key: const Key('history_period_label'),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ),
                      IconButton(
                        key: const Key('history_next_button'),
                        icon: const Icon(Icons.chevron_right),
                        tooltip: l10n.historyNextPeriod,
                        onPressed: canGoNext ? nav.goToNext : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Content: Chart + Stats Cards + Day Drill-down
            Expanded(
              child: summaryAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
                data: (summary) {
                  return ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      // Statistics Summary Cards
                      _buildStatisticsCards(context, summary, l10n),
                      const SizedBox(height: 20),

                      // Bar Chart Card
                      Semantics(
                        label: 'Biểu đồ cột calo tiêu hao từ ${DateFormatter.formatShortDate(summary.startDate)} đến ${DateFormatter.formatShortDate(summary.endDate)}',
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      l10n.historyDailyBurnTitle,
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    // Legend
                                    Row(
                                      children: [
                                        _buildLegendItem(AppColors.primary, l10n.dashboardBmrPortion),
                                        const SizedBox(width: 10),
                                        _buildLegendItem(AppColors.calorieOrange, l10n.dashboardActivePortion),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  height: 220,
                                  child: _buildBarChart(context, summary, dailyGoal),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Day Details List (Single day or breakdown of selected period)
                      Text(
                        l10n.historyDayDetailsTitle,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...summary.dailyRecords.reversed.map((record) {
                        return _buildDayRecordTile(context, record, l10n, ref);
                      }),
                      const SizedBox(height: 40),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- STATS HEADER CARDS ---
  Widget _buildStatisticsCards(
    BuildContext context,
    HistoryPeriodSummary summary,
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatTile(
            context: context,
            title: l10n.historyTotalBurned,
            value: CalorieFormatter.format(summary.totalKcal),
            unit: l10n.unitKcal,
            color: AppColors.calorieOrange,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatTile(
            context: context,
            title: l10n.historyAverageBurned,
            value: CalorieFormatter.format(summary.averageDailyKcal),
            unit: l10n.unitKcal,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatTile(
            context: context,
            title: l10n.historyHighestDay,
            value: summary.highestDay != null ? CalorieFormatter.format(summary.highestDay!.totalKcal) : '--',
            unit: l10n.unitKcal,
            color: Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildStatTile({
    required BuildContext context,
    required String title,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- FL_CHART BAR CHART ---
  Widget _buildBarChart(
    BuildContext context,
    HistoryPeriodSummary summary,
    double dailyGoal,
  ) {
    final records = summary.dailyRecords;
    if (records.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context).historyNoData));
    }

    // Determine max Y for nice scaling
    var maxY = dailyGoal * 1.25;
    for (final r in records) {
      if (r.totalKcal * 1.15 > maxY) {
        maxY = r.totalKcal * 1.15;
      }
    }

    final barGroups = <BarChartGroupData>[];
    for (int i = 0; i < records.length; i++) {
      final rec = records[i];
      final bmrY = rec.bmr;
      final totalY = rec.totalKcal;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: totalY,
              width: summary.rangeType.isMonth ? 6 : 18,
              borderRadius: BorderRadius.circular(4),
              rodStackItems: [
                BarChartRodStackItem(0, bmrY, AppColors.primary),
                BarChartRodStackItem(bmrY, totalY, AppColors.calorieOrange),
              ],
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        barGroups: barGroups,
        alignment: BarChartAlignment.spaceAround,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 500,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.15),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              interval: 1000,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox.shrink();
                return Text(
                  '${(value / 1000).toStringAsFixed(0)}k',
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 26,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= records.length) return const SizedBox.shrink();
                final rec = records[index];

                // Labels for Week vs Month vs Day
                if (summary.rangeType.isWeek) {
                  return Text(
                    DateFormatter.formatWeekday(rec.date),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  );
                } else if (summary.rangeType.isMonth) {
                  // Sparse labels for Month view to prevent crowding
                  final dayNum = rec.date.day;
                  final totalDays = records.length;
                  if (dayNum == 1 || dayNum == 10 || dayNum == 20 || dayNum == totalDays) {
                    return Text(
                      dayNum.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    );
                  }
                  return const SizedBox.shrink();
                } else {
                  return Text(
                    DateFormatter.formatShortDate(rec.date),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  );
                }
              },
            ),
          ),
        ),
        // Daily Calorie Target Dash Line
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: dailyGoal,
              color: Colors.amber.shade700,
              strokeWidth: 1.5,
              dashArray: [6, 4],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade800,
                ),
                labelResolver: (_) => 'Mục tiêu: ${CalorieFormatter.format(dailyGoal)}',
              ),
            ),
          ],
        ),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final rec = records[group.x.toInt()];
              return BarTooltipItem(
                '${DateFormatter.formatShortDate(rec.date)}\n'
                'Tổng: ${CalorieFormatter.format(rec.totalKcal)} kcal\n'
                '• BMR: ${CalorieFormatter.format(rec.bmr)}\n'
                '• Vận động: ${CalorieFormatter.format(rec.activityKcal)}',
                const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
              );
            },
          ),
          touchCallback: (FlTouchEvent event, barTouchResponse) {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              return;
            }
            if (event is FlTapUpEvent) {
              final index = barTouchResponse.spot!.touchedBarGroupIndex;
              if (index >= 0 && index < records.length) {
                _showDayDetailModal(context, records[index]);
              }
            }
          },
        ),
      ),
    );
  }

  // --- DAY RECORD TILE & BOTTOM SHEET DRILLDOWN ---
  Widget _buildDayRecordTile(
    BuildContext context,
    DayBurnRecord record,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    return Card(
      child: ListTile(
        onTap: () => _showDayDetailModal(context, record),
        leading: CircleAvatar(
          backgroundColor: record.hasActivities
              ? AppColors.calorieOrange.withOpacity(0.12)
              : Colors.grey.withOpacity(0.12),
          child: Icon(
            record.hasActivities ? Icons.local_fire_department : Icons.bedtime_outlined,
            color: record.hasActivities ? AppColors.calorieOrange : Colors.grey,
            size: 20,
          ),
        ),
        title: Text(
          DateFormatter.formatFullDate(record.date, locale: Localizations.localeOf(context).languageCode),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          record.hasActivities
              ? l10n.historyActivitiesCountAndMinutes(record.entries.length, record.activeMinutes)
              : l10n.historyBmrOnly,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              CalorieFormatter.format(record.totalKcal),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              l10n.unitKcal,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _showDayDetailModal(BuildContext context, DayBurnRecord record) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _DayDetailSheet(record: record),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  String _formatPeriodLabel(
    HistoryRangeType type,
    ({DateTime start, DateTime end}) range,
    DateTime anchor,
    String locale,
  ) {
    switch (type) {
      case HistoryRangeType.day:
        return DateFormatter.formatFullDate(range.start, locale: locale);
      case HistoryRangeType.week:
        return '${DateFormatter.formatShortDate(range.start)} - ${DateFormatter.formatShortDate(range.end)}';
      case HistoryRangeType.month:
        return DateFormat('MMMM yyyy', locale).format(anchor);
    }
  }
}

/// Bottom sheet displaying detailed activity list for a specific selected day
class _DayDetailSheet extends ConsumerWidget {
  const _DayDetailSheet({required this.record});

  final DayBurnRecord record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.read(activityLogRepositoryProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormatter.formatFullDate(record.date),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${CalorieFormatter.format(record.totalKcal)} kcal',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.calorieOrangeDark),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // BMR & Active chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                avatar: const Icon(Icons.bedtime_outlined, size: 16, color: AppColors.primary),
                label: Text('${l10n.dashboardBmrPortion}: ${CalorieFormatter.format(record.bmr)} ${l10n.unitKcal}'),
                backgroundColor: AppColors.primary.withValues(alpha: 0.08),
              ),
              Chip(
                avatar: const Icon(Icons.directions_run, size: 16, color: AppColors.calorieOrange),
                label: Text('${l10n.dashboardActivePortion}: ${CalorieFormatter.format(record.activityKcal)} ${l10n.unitKcal}'),
                backgroundColor: AppColors.calorieOrange.withValues(alpha: 0.08),
              ),
            ],
          ),
          const Divider(height: 24),
          Text(
            l10n.historyActivitiesLoggedCount(record.entries.length),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          if (record.entries.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Text(l10n.historyNoActivitiesOnDay, style: const TextStyle(color: Colors.grey)),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: record.entries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final entry = record.entries[index];
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => AddActivityScreen(entryToEdit: entry),
                          ),
                        );
                      },
                      title: Text(entry.displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${entry.durationMinutes} phút • ${DateFormatter.formatTime(entry.performedAt)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '+${CalorieFormatter.format(entry.caloriesBurned)} kcal',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.calorieOrange),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                            onPressed: () async {
                              await repo.deleteEntry(entry.id);
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
