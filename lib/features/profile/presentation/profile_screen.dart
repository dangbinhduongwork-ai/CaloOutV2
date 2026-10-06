import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/calorie_formatter.dart';
import '../../../core/utils/unit_converter.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/presentation/providers/unit_settings_provider.dart';
import 'providers/profile_provider.dart';

/// Profile screen displaying user information, calculations, and formulas.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(profileProvider);
    final bmr = ref.watch(currentBmrProvider);
    final tdee = ref.watch(currentTdeeProvider);
    final unitSettings = ref.watch(unitSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navProfile),
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
            padding: const EdgeInsets.all(16.0),
            children: [
              // User Information Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primary.withOpacity(0.12),
                            child: Icon(
                              profile.gender.isMale ? Icons.face : Icons.face_3,
                              color: AppColors.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.gender.isMale ? l10n.male : l10n.female,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                '${profile.age} ${l10n.ageUnit}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildProfileItem(
                            label: l10n.height,
                            value: UnitConverter.formatHeight(
                              profile.heightCm,
                              isImperial: unitSettings.heightUnit.isImperial,
                            ),
                          ),
                          _buildProfileItem(
                            label: l10n.weight,
                            value: UnitConverter.formatWeight(
                              profile.weightKg,
                              isImperial: unitSettings.weightUnit.isImperial,
                            ),
                          ),
                          _buildProfileItem(
                            label: l10n.dailyActivityLevel,
                            value: '${profile.activityLevel.multiplier}x',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // BMR & TDEE Metrics Card
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.bmrTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          Text(
                            bmr != null ? CalorieFormatter.format(bmr) : '--',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                          ),
                          Text(l10n.unitKcal, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.calorieOrange.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.calorieOrange.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.tdeeTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          Text(
                            tdee != null ? CalorieFormatter.format(tdee) : '--',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.calorieOrangeDark),
                          ),
                          Text(l10n.unitKcal, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Formula Breakdown Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calculate_outlined, color: AppColors.primary, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            l10n.formulaTitle,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(l10n.formulaBmrMifflin),
                      const Divider(height: 24),
                      Text(l10n.formulaTdee),
                      const Divider(height: 24),
                      Text(l10n.formulaActivityBurn),
                      const Divider(height: 24),
                      Text(l10n.formulaDailyTotal),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Disclaimer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  l10n.disclaimer,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileItem({required String label, required String value}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
