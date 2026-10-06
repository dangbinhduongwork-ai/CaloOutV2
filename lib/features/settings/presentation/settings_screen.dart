import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/presentation/providers/profile_provider.dart';
import '../domain/entities/unit_settings.dart';
import 'providers/unit_settings_provider.dart';

/// Settings screen for managing language, theme, measurement units, and data.
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
          // Preferences Card (Language & Theme)
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(l10n.settingsLanguage),
                  subtitle: Text(currentLocale.languageCode == 'vi' ? 'Tiếng Việt' : 'English'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (code) {
                      ref.read(localeProvider.notifier).setLocale(Locale(code));
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'vi', child: Text('Tiếng Việt')),
                      PopupMenuItem(value: 'en', child: Text('English')),
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
                  await ref.read(profileProvider.notifier).clearProfile();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.settingsDataClearedSuccess)),
                    );
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 24),

          // Disclaimer
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
        ],
      ),
    );
  }
}
