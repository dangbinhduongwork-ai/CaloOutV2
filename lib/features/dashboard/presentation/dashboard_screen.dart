import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/calorie_formatter.dart';
import '../../../core/utils/unit_converter.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/presentation/providers/profile_provider.dart';
import '../../settings/presentation/providers/unit_settings_provider.dart';

/// Dashboard screen displaying current user metrics (BMR, TDEE, Daily Goal).
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(profileProvider);
    final bmr = ref.watch(currentBmrProvider);
    final tdee = ref.watch(currentTdeeProvider);
    final dailyGoal = ref.watch(currentDailyGoalProvider);
    final unitSettings = ref.watch(unitSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
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

          return ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              // Hero Calorie Target Card
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: AppColors.heroCardGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.dashboardGoal,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.flash_on, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${profile.activityLevel.multiplier}x',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          dailyGoal != null ? CalorieFormatter.format(dailyGoal) : '--',
                          key: const Key('dashboard_goal_text'),
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.unitKcal,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.tagline,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // BMR & TDEE side-by-side cards
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      context: context,
                      icon: Icons.bedtime_outlined,
                      iconColor: AppColors.primary,
                      title: l10n.bmrTitle,
                      value: bmr != null ? CalorieFormatter.format(bmr) : '--',
                      valueKey: const Key('dashboard_bmr_text'),
                      unit: l10n.unitKcal,
                      subtitle: l10n.dashboardBmrPortion,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildMetricTile(
                      context: context,
                      icon: Icons.local_fire_department,
                      iconColor: AppColors.calorieOrange,
                      title: l10n.tdeeTitle,
                      value: tdee != null ? CalorieFormatter.format(tdee) : '--',
                      valueKey: const Key('dashboard_tdee_text'),
                      unit: l10n.unitKcal,
                      subtitle: l10n.tdeeDescription,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // User Profile Info Summary Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.navProfile,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          TextButton(
                            onPressed: () => context.go('/profile'),
                            child: Text(l10n.edit),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildProfileStat(
                            label: l10n.gender,
                            value: profile.gender.isMale ? l10n.male : l10n.female,
                          ),
                          _buildProfileStat(
                            label: l10n.age,
                            value: '${profile.age} ${l10n.ageUnit}',
                          ),
                          _buildProfileStat(
                            label: l10n.height,
                            value: UnitConverter.formatHeight(
                              profile.heightCm,
                              isImperial: unitSettings.heightUnit.isImperial,
                            ),
                          ),
                          _buildProfileStat(
                            label: l10n.weight,
                            value: UnitConverter.formatWeight(
                              profile.weightKg,
                              isImperial: unitSettings.weightUnit.isImperial,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Activity Log Placeholder banner
              Card(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(Icons.fitness_center_outlined, size: 36, color: Colors.grey),
                      const SizedBox(height: 10),
                      Text(
                        l10n.dashboardNoActivities,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.dashboardAddActivity,
        onPressed: () => context.push('/activity/add'),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildMetricTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Key valueKey,
    required String unit,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                key: valueKey,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat({
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
