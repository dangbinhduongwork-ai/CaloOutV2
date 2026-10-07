import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:caloout/core/theme/app_colors.dart';
import 'package:caloout/core/utils/calorie_formatter.dart';
import 'package:caloout/core/utils/date_formatter.dart';
import 'package:caloout/l10n/app_localizations.dart';
import 'package:caloout/features/profile/presentation/providers/profile_provider.dart';
import 'package:caloout/features/activity/domain/entities/activity_entry.dart';
import 'package:caloout/features/activity/domain/entities/activity_type.dart';
import 'package:caloout/features/activity/domain/services/activity_calorie_calculator.dart';
import 'package:caloout/features/activity/domain/validators/activity_validator.dart';
import 'package:caloout/features/activity/presentation/providers/activity_providers.dart';

/// Screen for adding or editing logged physical activities.
class AddActivityScreen extends ConsumerStatefulWidget {
  const AddActivityScreen({this.entryToEdit, super.key});

  final ActivityEntry? entryToEdit;

  @override
  ConsumerState<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends ConsumerState<AddActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Selected Activity
  ActivityType? _selectedActivity;
  String _searchQuery = '';
  String _selectedCategory = 'all';

  // Custom Activity Inputs
  final TextEditingController _customNameController = TextEditingController();
  final TextEditingController _customMetController = TextEditingController(text: '5.0');
  bool _saveCustomForFuture = true;
  String? _customNameError;
  String? _customMetError;

  // Duration & DateTime
  final TextEditingController _durationController = TextEditingController(text: '30');
  String? _durationError;
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    final edit = widget.entryToEdit;
    if (edit != null) {
      _selectedDateTime = edit.performedAt;
      _durationController.text = edit.durationMinutes.toString();

      if (edit.customName != null && edit.customName!.isNotEmpty) {
        _tabController.index = 1; // Custom tab
        _customNameController.text = edit.customName!;
        _customMetController.text = edit.activityType?.met.toString() ?? '5.0';
      } else {
        _selectedActivity = edit.activityType;
      }
    } else {
      _selectedDateTime = DateTime.now();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _customNameController.dispose();
    _customMetController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  double get _currentMet {
    if (_tabController.index == 1) {
      return double.tryParse(_customMetController.text.trim()) ?? 1.0;
    }
    return _selectedActivity?.met ?? 3.5;
  }

  int get _currentDuration {
    return int.tryParse(_durationController.text.trim()) ?? 0;
  }

  double get _previewCalories {
    final profile = ref.read(profileProvider).valueOrNull;
    final weightKg = profile?.weightKg ?? 65.0;
    return ActivityCalorieCalculator.calculate(
      met: _currentMet,
      weightKg: weightKg,
      durationMinutes: _currentDuration,
    );
  }

  bool _validateInputs() {
    var isValid = true;

    // Validate Duration
    final durationRes = ActivityValidator.validateDuration(_currentDuration);
    setState(() {
      _durationError = durationRes.isValid ? null : durationRes.errorMessage;
    });
    if (!durationRes.isValid) isValid = false;

    // Validate Tab 1 (Catalog) or Tab 2 (Custom)
    if (_tabController.index == 1) {
      final nameRes = ActivityValidator.validateCustomName(_customNameController.text.trim());
      final metVal = double.tryParse(_customMetController.text.trim());
      final metRes = ActivityValidator.validateMet(metVal);

      setState(() {
        _customNameError = nameRes.isValid ? null : nameRes.errorMessage;
        _customMetError = metRes.isValid ? null : metRes.errorMessage;
      });

      if (!nameRes.isValid || !metRes.isValid) isValid = false;
    } else {
      if (_selectedActivity == null) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.selectActivityPlease)),
        );
        isValid = false;
      }
    }

    return isValid;
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (pickedTime == null || !mounted) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _saveEntry() async {
    if (!_validateInputs()) return;

    final profile = ref.read(profileProvider).valueOrNull;
    final weightKg = profile?.weightKg ?? 65.0;
    final duration = _currentDuration;
    final calories = _previewCalories;

    ActivityType? activityType;
    String? customName;

    if (_tabController.index == 1) {
      customName = _customNameController.text.trim();
      final met = double.parse(_customMetController.text.trim());

      if (_saveCustomForFuture) {
        activityType = await ref
            .read(customActivitiesNotifierProvider.notifier)
            .addCustom(customName, met);
      } else {
        activityType = ActivityType(
          id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
          nameKey: customName,
          met: met,
          category: 'custom',
          isCustom: true,
        );
      }
    } else {
      activityType = _selectedActivity;
    }

    final repo = ref.read(activityLogRepositoryProvider);

    if (widget.entryToEdit != null) {
      final updated = widget.entryToEdit!.copyWith(
        activityType: activityType,
        customName: customName,
        durationMinutes: duration,
        caloriesBurned: calories,
        weightKgSnapshot: weightKg,
        performedAt: _selectedDateTime,
      );
      await repo.updateEntry(updated);
    } else {
      final newEntry = ActivityEntry(
        id: const Uuid().v4(),
        activityType: activityType,
        customName: customName,
        durationMinutes: duration,
        caloriesBurned: calories,
        weightKgSnapshot: weightKg,
        performedAt: _selectedDateTime,
      );
      await repo.addEntry(newEntry);
    }

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEditing = widget.entryToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editActivityTitle : l10n.addActivityTitle),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: l10n.selectActivity),
            Tab(text: l10n.customActivity),
          ],
          onTap: (_) => setState(() {}),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Section: Live Calorie Preview Card
            _buildCaloriePreviewBanner(l10n),

            // Tab Views: Catalog vs Custom
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCatalogTab(l10n),
                  _buildCustomTab(l10n),
                ],
              ),
            ),

            // Bottom Section: Duration inputs, Chips, and Save button
            _buildDurationAndActionSection(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildCaloriePreviewBanner(AppLocalizations l10n) {
    final preview = _previewCalories;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: AppColors.calorieBurnGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.calorieOrange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_fire_department, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.caloriesBurnedEstimated,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        CalorieFormatter.format(preview),
                        key: const Key('preview_calories_text'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.unitKcal,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Date time chip button
          InkWell(
            onTap: _pickDateTime,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    DateFormatter.formatTime(_selectedDateTime),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- CATALOG TAB ---
  Widget _buildCatalogTab(AppLocalizations l10n) {
    final catalogAsync = ref.watch(activityCatalogProvider);
    final customAsync = ref.watch(customActivitiesNotifierProvider);

    return catalogAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (catalog) {
        final customList = customAsync.valueOrNull ?? [];
        final allActivities = [...catalog, ...customList];

        // Filter by search and category
        final filtered = allActivities.where((a) {
          final matchesSearch = a.nameKey.toLowerCase().contains(_searchQuery.toLowerCase());
          final matchesCategory = _selectedCategory == 'all' || a.category == _selectedCategory;
          return matchesSearch && matchesCategory;
        }).toList();

        return Column(
          children: [
            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              child: TextField(
                key: const Key('search_activity_field'),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm hoạt động...',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),
            // Category filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  _buildCategoryChip('all', 'Tất cả'),
                  _buildCategoryChip('cardio', 'Cardio'),
                  _buildCategoryChip('strength', 'Gym & Kháng lực'),
                  _buildCategoryChip('sports', 'Thể thao'),
                  _buildCategoryChip('flexibility', 'Yoga & Giãn cơ'),
                  _buildCategoryChip('daily', 'Hằng ngày'),
                  _buildCategoryChip('custom', 'Tùy chỉnh'),
                ],
              ),
            ),
            // Activity List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final act = filtered[index];
                  final isSelected = _selectedActivity?.id == act.id;

                  return InkWell(
                    key: Key('activity_item_${act.id}'),
                    onTap: () {
                      setState(() {
                        _selectedActivity = act;
                      });
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.08)
                            : Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.2),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getCategoryIcon(act.category),
                            color: isSelected ? AppColors.primary : Colors.grey,
                            size: 26,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  act.nameKey,
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'MET: ${act.met} • ${act.category.toUpperCase()}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: AppColors.primary, size: 22),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // --- CUSTOM ACTIVITY TAB ---
  Widget _buildCustomTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.customActivityName,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('custom_activity_name_field'),
            controller: _customNameController,
            decoration: InputDecoration(
              hintText: 'Ví dụ: Leo núi, Chèo thuyền...',
              errorText: _customNameError,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.customActivityMet,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Gợi ý: Nhẹ 2.5–3.5 • Vừa 4.0–6.0 • Nặng 7.0–10.0 • Cực nặng >10.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          TextField(
            key: const Key('custom_activity_met_field'),
            controller: _customMetController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
            ],
            decoration: InputDecoration(
              hintText: '5.0',
              errorText: _customMetError,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          // Quick MET suggestion chips
          Wrap(
            spacing: 8,
            children: [
              _buildMetPresetChip(2.5, 'Nhẹ (2.5)'),
              _buildMetPresetChip(4.5, 'Vừa (4.5)'),
              _buildMetPresetChip(7.0, 'Khá (7.0)'),
              _buildMetPresetChip(9.0, 'Nặng (9.0)'),
              _buildMetPresetChip(12.0, 'Rất nặng (12.0)'),
            ],
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _saveCustomForFuture,
            onChanged: (val) => setState(() => _saveCustomForFuture = val ?? true),
            title: Text(l10n.saveToCustomTemplate),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
    );
  }

  // --- DURATION INPUT & ACTION BUTTON ---
  Widget _buildDurationAndActionSection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.15))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('activity_duration_field'),
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.durationMinutes,
                    suffixText: l10n.unitMinutes,
                    errorText: _durationError,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 10),
              // Quick duration preset buttons
              _buildDurationChip(15),
              const SizedBox(width: 6),
              _buildDurationChip(30),
              const SizedBox(width: 6),
              _buildDurationChip(45),
              const SizedBox(width: 6),
              _buildDurationChip(60),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              key: const Key('save_activity_button'),
              onPressed: _saveEntry,
              child: Text(l10n.save),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category, String label) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedCategory = category),
        backgroundColor: Colors.transparent,
        selectedColor: AppColors.primary.withOpacity(0.15),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primaryDark : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildMetPresetChip(double met, String label) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        setState(() {
          _customMetController.text = met.toString();
        });
      },
    );
  }

  Widget _buildDurationChip(int minutes) {
    final isSelected = _currentDuration == minutes;
    return InkWell(
      onTap: () {
        setState(() {
          _durationController.text = minutes.toString();
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '$minutes m',
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primaryDark,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'cardio':
        return Icons.directions_run;
      case 'strength':
        return Icons.fitness_center;
      case 'sports':
        return Icons.sports_tennis;
      case 'flexibility':
        return Icons.self_improvement;
      case 'daily':
        return Icons.cleaning_services;
      case 'custom':
      default:
        return Icons.star_outline;
    }
  }
}
