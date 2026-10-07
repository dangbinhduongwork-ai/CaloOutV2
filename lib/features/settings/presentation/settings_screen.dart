import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:caloout/core/theme/theme_provider.dart';
import 'package:caloout/l10n/app_localizations.dart';
import 'package:caloout/features/activity/presentation/providers/activity_providers.dart';
import 'package:caloout/features/profile/presentation/onboarding_screen.dart';
import 'package:caloout/features/profile/presentation/providers/profile_provider.dart';
import 'package:caloout/features/settings/domain/entities/unit_settings.dart';
import 'package:caloout/features/settings/presentation/providers/unit_settings_provider.dart';
import 'package:caloout/features/health/domain/entities/health_sync_status.dart';
import 'package:caloout/features/health/presentation/providers/health_sync_providers.dart';

/// Settings screen for managing profile, language, theme, measurement units, and data.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentTheme = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(localeProvider);
    final unitSettings = ref.watch(unitSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Profile Edit Card
          Card(
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(l10n.settingsProfile),
              subtitle: Text(l10n.adjustTargetOptional),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const OnboardingScreen(isEditing: true),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Preferences Card (Language & Theme)
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(l10n.settingsLanguage),
                  subtitle: Text(
                    currentLocale == null
                        ? l10n.languageSystem
                        : (currentLocale.languageCode == 'vi'
                            ? l10n.languageVietnamese
                            : l10n.languageEnglish),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (code) {
                      if (code == 'system') {
                        ref.read(localeProvider.notifier).setLocale(null);
                      } else {
                        ref.read(localeProvider.notifier).setLocale(Locale(code));
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 'system', child: Text(l10n.languageSystem)),
                      PopupMenuItem(value: 'vi', child: Text(l10n.languageVietnamese)),
                      PopupMenuItem(value: 'en', child: Text(l10n.languageEnglish)),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.dark_mode_outlined),
                  title: Text(l10n.settingsTheme),
                  subtitle: Text(
                    switch (currentTheme) {
                      ThemeMode.light => l10n.settingsThemeLight,
                      ThemeMode.dark => l10n.settingsThemeDark,
                      ThemeMode.system => l10n.settingsThemeSystem,
                    },
                  ),
                  trailing: PopupMenuButton<ThemeMode>(
                    onSelected: (mode) {
                      ref.read(themeModeProvider.notifier).setThemeMode(mode);
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: ThemeMode.system, child: Text(l10n.settingsThemeSystem)),
                      PopupMenuItem(value: ThemeMode.light, child: Text(l10n.settingsThemeLight)),
                      PopupMenuItem(value: ThemeMode.dark, child: Text(l10n.settingsThemeDark)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Units Card
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.straighten),
                  title: Text(l10n.height),
                  subtitle: Text(unitSettings.heightUnit.isMetric ? 'cm' : 'ft-in'),
                  trailing: SegmentedButton<HeightUnit>(
                    segments: const [
                      ButtonSegment(value: HeightUnit.cm, label: Text('cm')),
                      ButtonSegment(value: HeightUnit.ftIn, label: Text('ft-in')),
                    ],
                    selected: {unitSettings.heightUnit},
                    onSelectionChanged: (set) {
                      ref.read(unitSettingsProvider.notifier).setHeightUnit(set.first);
                    },
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.scale_outlined),
                  title: Text(l10n.weight),
                  subtitle: Text(unitSettings.weightUnit.isMetric ? 'kg' : 'lb'),
                  trailing: SegmentedButton<WeightUnit>(
                    segments: const [
                      ButtonSegment(value: WeightUnit.kg, label: Text('kg')),
                      ButtonSegment(value: WeightUnit.lb, label: Text('lb')),
                    ],
                    selected: {unitSettings.weightUnit},
                    onSelectionChanged: (set) {
                      ref.read(unitSettingsProvider.notifier).setWeightUnit(set.first);
                    },
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Health Data Sync Card (Default: OFF)
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    key: const Key('settings_health_sync_switch'),
                    title: Text(l10n.healthSyncTitle),
                    subtitle: Text(l10n.healthSyncSubtitle),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite, color: Colors.red),
                    ),
                    value: ref.watch(healthSyncEnabledProvider),
                    onChanged: (val) async {
                      final result = await ref
                          .read(healthSyncEnabledProvider.notifier)
                          .toggleEnabled(val);

                      if (!context.mounted) return;

                      if (!result.success) {
                        final msg = switch (result.status) {
                          HealthSyncStatus.permissionDenied =>
                            l10n.healthSyncStatusPermissionDenied,
                          HealthSyncStatus.notSupported =>
                            l10n.healthSyncStatusNotSupported,
                          HealthSyncStatus.readError =>
                            l10n.healthSyncStatusReadError,
                          _ => l10n.errorGeneric,
                        };

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(msg),
                            backgroundColor: Colors.red.shade700,
                            duration: const Duration(seconds: 4),
                          ),
                        );
                      }
                    },
                  ),
                  if (ref.watch(healthSyncEnabledProvider)) ...[
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      child: Row(
                        children: [
                          Icon(
                            switch (ref.watch(healthSyncStatusProvider)) {
                              HealthSyncStatus.syncing => Icons.sync,
                              HealthSyncStatus.authorized => Icons.check_circle_outline,
                              HealthSyncStatus.noData => Icons.info_outline,
                              HealthSyncStatus.permissionRevoked => Icons.warning_amber_rounded,
                              _ => Icons.error_outline,
                            },
                            size: 16,
                            color: switch (ref.watch(healthSyncStatusProvider)) {
                              HealthSyncStatus.authorized => Colors.green,
                              HealthSyncStatus.syncing => Colors.blue,
                              HealthSyncStatus.noData => Colors.blueGrey,
                              _ => Colors.orange,
                            },
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              switch (ref.watch(healthSyncStatusProvider)) {
                                HealthSyncStatus.syncing => l10n.healthSyncStatusSyncing,
                                HealthSyncStatus.authorized =>
                                  '${l10n.healthSyncStatusAuthorized} (${ref.watch(healthSyncRepositoryProvider).platformSourceName})',
                                HealthSyncStatus.noData => l10n.healthSyncStatusNoData,
                                HealthSyncStatus.permissionRevoked =>
                                  l10n.healthSyncStatusPermissionRevoked,
                                HealthSyncStatus.permissionDenied =>
                                  l10n.healthSyncStatusPermissionDenied,
                                HealthSyncStatus.notSupported =>
                                  l10n.healthSyncStatusNotSupported,
                                _ => l10n.healthSyncStatusReadError,
                              },
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 18),
                            tooltip: 'Sync now',
                            onPressed: () {
                              ref.read(healthSyncResultProvider.notifier).sync();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                  // Privacy Commitment Box
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.security, size: 18, color: Colors.teal),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l10n.healthSyncPrivacyNotice,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade700,
                                    height: 1.35,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // About & Scientific Info Card
          Card(
            child: ExpansionTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.aboutTitle),
              subtitle: Text('${l10n.aboutVersion} 1.0.0'),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1),
                const SizedBox(height: 12),
                Text(
                  l10n.aboutFormulas,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  '• ${l10n.aboutFormulaBmrDesc}\n'
                  '• ${l10n.aboutFormulaTdeeDesc}\n'
                  '• ${l10n.aboutFormulaActivityDesc}\n'
                  '• ${l10n.aboutFormulaTotalDesc}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.aboutDataSource,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.aboutDataSourceDesc,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.aboutMedicalDisclaimer,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.aboutMedicalDisclaimerDesc,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Clear Data Card
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(
                l10n.settingsClearData,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              ),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.settingsClearData),
                    content: Text(l10n.settingsClearDataConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(l10n.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: Text(l10n.delete),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  await ref.read(activityLogRepositoryProvider).clearAllLogs();
                  await ref.read(profileProvider.notifier).clearProfile();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.settingsDataClearedSuccess)),
                    );
                    context.go('/onboarding');
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 24),

          // Medical Disclaimer footer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              l10n.disclaimer,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
