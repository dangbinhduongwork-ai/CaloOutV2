import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:caloout/core/theme/app_colors.dart';
import 'package:caloout/core/utils/calorie_formatter.dart';
import 'package:caloout/core/utils/date_formatter.dart';
import 'package:caloout/l10n/app_localizations.dart';
import 'package:caloout/features/activity/domain/entities/activity_entry.dart';
import 'package:caloout/features/activity/presentation/add_activity_screen.dart';
import 'package:caloout/features/activity/presentation/providers/activity_providers.dart';
import 'package:caloout/features/profile/presentation/providers/profile_provider.dart';
import 'package:caloout/features/health/domain/entities/health_sync_result.dart';
import 'package:caloout/features/health/domain/entities/health_sync_status.dart';
import 'package:caloout/features/health/presentation/providers/health_sync_providers.dart';

/// Dashboard screen showing Today's Calorie Burn progress ring and activity logs.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(profileProvider);
    final summary = ref.watch(todaySummaryProvider);
    final dailyGoal = ref.watch(currentDailyGoalProvider) ?? 2000.0;
    final entriesAsync = ref.watch(todayEntriesStreamProvider);
    final today = ref.watch(todayDateProvider);
    final healthSyncEnabled = ref.watch(healthSyncEnabledProvider);
    final healthResult = ref.watch(healthSyncResultProvider);
    final hasHealthData = healthSyncEnabled &&
        (healthResult.status == HealthSyncStatus.authorized ||
            healthResult.status == HealthSyncStatus.noData) &&
        (healthResult.deduplicatedCalories > 0 || healthResult.totalSteps > 0);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.calorieOrange.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_fire_department, color: AppColors.calorieOrange, size: 20),
            ),
            const SizedBox(width: 8),
            Text(l10n.appTitle),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  DateFormatter.formatShortDate(today),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (profile) {
          if (profile == null) {
            return Center(
              child: ElevatedButton(
                onPressed: () => context.go('/onboarding'),
                child: Text(l10n.onboardingTitle),
              ),
            );
          }

          final entries = entriesAsync.valueOrNull ?? [];
          final progressRatio = dailyGoal > 0 ? (summary.totalKcal / dailyGoal).clamp(0.0, 1.5) : 0.0;
          final percent = (progressRatio * 100).round();

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            children: [
              // Calorie Progress Ring Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 220,
                        height: 220,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0.0, end: progressRatio),
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, _) {
                                return CustomPaint(
                                  size: const Size(220, 220),
                                  painter: _CalorieProgressPainter(
                                    progress: value,
                                    trackColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                    progressGradient: AppColors.calorieBurnGradient,
                                  ),
                                );
                              },
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  l10n.dashboardTodayBurned,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  CalorieFormatter.format(summary.totalKcal),
                                  key: const Key('dashboard_total_burn_text'),
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                Text(
                                  l10n.unitKcal,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: (percent >= 100 ? AppColors.primary : AppColors.calorieOrange)
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '$percent%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: percent >= 100 ? AppColors.primaryDark : AppColors.calorieOrangeDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${CalorieFormatter.format(summary.totalKcal)} / ${CalorieFormatter.format(dailyGoal)} ${l10n.unitKcal}',
                        key: const Key('dashboard_goal_text'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Two Breakdown Metric Tiles (BMR + Activity)
              Row(
                children: [
                  Expanded(
                    child: _buildBreakdownCard(
                      context: context,
                      icon: Icons.bedtime_outlined,
                      color: AppColors.primary,
                      title: l10n.dashboardBmrPortion,
                      value: CalorieFormatter.format(summary.bmr),
                      unit: l10n.unitKcal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildBreakdownCard(
                      context: context,
                      icon: Icons.directions_run,
                      color: AppColors.calorieOrange,
                      title: l10n.dashboardActivePortion,
                      value: CalorieFormatter.format(summary.activityKcal + summary.healthActiveKcal),
                      unit: l10n.unitKcal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Activity Log Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${l10n.dashboardActivitiesLogged} (${entries.length + (hasHealthData ? 1 : 0)})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (entries.isNotEmpty || hasHealthData)
                    TextButton.icon(
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(l10n.dashboardAddActivity),
                      onPressed: () => _openAddActivity(context),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Dedicated Health Sync Tile (Apple Health / Health Connect)
              if (hasHealthData) ...[
                _buildHealthSyncTile(context, healthResult, l10n),
                const SizedBox(height: 8),
              ],

              // Today's Activity List or Friendly Empty State
              if (entries.isEmpty && !hasHealthData)
                _buildEmptyStateCard(context, l10n)
              else if (entries.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return _buildDismissibleActivityTile(context, entry, l10n, ref);
                  },
                ),
              const SizedBox(height: 70), // Bottom padding for FAB
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('dashboard_add_activity_fab'),
        tooltip: l10n.dashboardAddActivity,
        onPressed: () => _openAddActivity(context),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildHealthSyncTile(
    BuildContext context,
    HealthSyncResult result,
    AppLocalizations l10n,
  ) {
    final isApple = result.platformSourceName.toLowerCase().contains('apple');
    final accentColor = isApple ? const Color(0xFFFF2D55) : const Color(0xFF00897B);

    return Card(
      key: const Key('dashboard_health_sync_tile'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: accentColor.withOpacity(0.35),
          width: 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite_rounded,
                    color: accentColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            result.platformSourceName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'SYNC',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.healthSyncActivitySubtitle(result.totalSteps),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '+${CalorieFormatter.format(result.deduplicatedCalories)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    Text(
                      l10n.unitKcal,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            if (result.overlappingCaloriesIgnored > 0) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined, size: 14, color: Colors.amber),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l10n.healthSyncExcludedNote(
                          result.overlappingSamples.length,
                          result.overlappingCaloriesIgnored,
                        ),
                        style: const TextStyle(fontSize: 11, color: Colors.brown),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _openAddActivity(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const AddActivityScreen(),
      ),
    );
  }

  Widget _buildBreakdownCard({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.directions_run, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.dashboardNoActivities,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: Text(l10n.dashboardAddActivity),
              onPressed: () => _openAddActivity(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDismissibleActivityTile(
    BuildContext context,
    ActivityEntry entry,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    return Dismissible(
      key: Key('activity_entry_${entry.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.delete, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              l10n.delete,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      onDismissed: (_) async {
        final repo = ref.read(activityLogRepositoryProvider);
        await repo.deleteEntry(entry.id);

        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.activityDeletedSnackbar(entry.displayName)),
              action: SnackBarAction(
                label: l10n.undo,
                onPressed: () async {
                  await repo.addEntry(entry);
                },
              ),
            ),
          );
        }
      },
      child: Card(
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => AddActivityScreen(entryToEdit: entry),
              ),
            );
          },
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.calorieOrange.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.fitness_center, color: AppColors.calorieOrange, size: 22),
          ),
          title: Text(
            entry.displayName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          subtitle: Text(
            '${entry.durationMinutes} ${l10n.unitMinutes} • ${DateFormatter.formatTime(entry.performedAt)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${CalorieFormatter.format(entry.caloriesBurned)}',
                style: const TextStyle(
                  color: AppColors.calorieOrangeDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              Text(
                l10n.unitKcal,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// CustomPainter for the smooth Calorie Progress Ring
class _CalorieProgressPainter extends CustomPainter {
  const _CalorieProgressPainter({
    required this.progress,
    required this.trackColor,
    required this.progressGradient,
  });

  final double progress;
  final Color trackColor;
  final Gradient progressGradient;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 16.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track Paint
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    // Progress Paint with Gradient Shader
    final rect = Rect.fromCircle(center: center, radius: radius);
    final progressPaint = Paint()
      ..shader = progressGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final startAngle = -math.pi / 2;
    final sweepAngle = (2 * math.pi) * progress.clamp(0.0, 1.0);

    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _CalorieProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.trackColor != trackColor;
  }
}
