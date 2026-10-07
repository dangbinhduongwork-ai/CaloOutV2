import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../activity/presentation/providers/activity_providers.dart';
import '../../profile/presentation/onboarding_screen.dart';
import '../../profile/presentation/providers/profile_provider.dart';
import '../domain/entities/unit_settings.dart';
import 'providers/unit_settings_provider.dart';

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
