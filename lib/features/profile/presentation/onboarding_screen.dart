import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/calorie_formatter.dart';
import '../../../core/utils/unit_converter.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/domain/entities/unit_settings.dart';
import '../../settings/presentation/providers/unit_settings_provider.dart';
import '../domain/entities/activity_level.dart';
import '../domain/entities/gender.dart';
import '../domain/entities/user_profile.dart';
import '../domain/services/bmr_calculator.dart';
import '../domain/services/tdee_calculator.dart';
import '../domain/validators/profile_validator.dart';
import 'providers/profile_provider.dart';

/// Interactive 4-step onboarding flow for new users.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Step 1: Gender & Age
  Gender _gender = Gender.male;
  final TextEditingController _ageController = TextEditingController(text: '25');
  String? _ageError;

  // Step 2: Height & Weight
  WeightUnit _weightUnit = WeightUnit.kg;
  HeightUnit _heightUnit = HeightUnit.cm;
  final TextEditingController _weightController = TextEditingController(text: '65');
  final TextEditingController _heightController = TextEditingController(text: '170');
  final TextEditingController _heightFtController = TextEditingController(text: '5');
  final TextEditingController _heightInController = TextEditingController(text: '7');
  String? _weightError;
  String? _heightError;

  // Step 3: Activity Level
  ActivityLevel _activityLevel = ActivityLevel.moderate;

  // Step 4: Daily Goal override
  final TextEditingController _goalController = TextEditingController();
  bool _isCustomGoal = false;

  @override
  void initState() {
    super.initState();
    // Validate initial values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateStep1();
      _validateStep2();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _heightFtController.dispose();
    _heightInController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  // --- Step 1 Validation ---
  bool _validateStep1() {
    final ageVal = int.tryParse(_ageController.text.trim());
    final res = ProfileValidator.validateAge(ageVal);
    setState(() {
      _ageError = res.isValid ? null : res.errorMessage;
    });
    return res.isValid;
  }

  // --- Step 2 Conversion & Validation ---
  double get _currentWeightInKg {
    final text = _weightController.text.trim();
    final raw = double.tryParse(text) ?? 0.0;
    if (_weightUnit == WeightUnit.lb) {
      return UnitConverter.lbToKg(raw);
    }
    return raw;
  }

  double get _currentHeightInCm {
    if (_heightUnit == HeightUnit.ftIn) {
      final feet = int.tryParse(_heightFtController.text.trim()) ?? 0;
      final inches = double.tryParse(_heightInController.text.trim()) ?? 0.0;
      return UnitConverter.ftInToCm(feet, inches);
    }
    final raw = double.tryParse(_heightController.text.trim()) ?? 0.0;
    return raw;
  }

  bool _validateStep2() {
    final weightKg = _currentWeightInKg;
    final heightCm = _currentHeightInCm;

    final weightRes = ProfileValidator.validateWeight(weightKg);
    final heightRes = ProfileValidator.validateHeight(heightCm);

    setState(() {
      _weightError = weightRes.isValid ? null : weightRes.errorMessage;
      _heightError = heightRes.isValid ? null : heightRes.errorMessage;
    });

    return weightRes.isValid && heightRes.isValid;
  }

  void _onToggleWeightUnit(WeightUnit newUnit) {
    if (_weightUnit == newUnit) return;
    final currentWeight = double.tryParse(_weightController.text.trim());
    if (currentWeight != null && currentWeight > 0) {
      if (newUnit == WeightUnit.lb) {
        // kg -> lb
        final lb = UnitConverter.kgToLb(currentWeight);
        _weightController.text = lb.toStringAsFixed(1);
      } else {
        // lb -> kg
        final kg = UnitConverter.lbToKg(currentWeight);
        _weightController.text = kg.toStringAsFixed(1);
      }
    }
    setState(() {
      _weightUnit = newUnit;
    });
    _validateStep2();
  }

  void _onToggleHeightUnit(HeightUnit newUnit) {
    if (_heightUnit == newUnit) return;
    if (newUnit == HeightUnit.ftIn) {
      // cm -> ft-in
      final cm = double.tryParse(_heightController.text.trim()) ?? 170.0;
      final pair = UnitConverter.cmToFeetAndInches(cm);
      _heightFtController.text = pair.feet.toString();
      _heightInController.text = pair.inches.toStringAsFixed(1);
    } else {
      // ft-in -> cm
      final feet = int.tryParse(_heightFtController.text.trim()) ?? 0;
      final inches = double.tryParse(_heightInController.text.trim()) ?? 0.0;
      final cm = UnitConverter.ftInToCm(feet, inches);
      _heightController.text = cm.toStringAsFixed(0);
    }
    setState(() {
      _heightUnit = newUnit;
    });
    _validateStep2();
  }

  // --- Step 4 calculations ---
  double get _calculatedBmr {
    final age = int.tryParse(_ageController.text.trim()) ?? 25;
    return BmrCalculator.calculateRaw(
      gender: _gender,
      weightKg: _currentWeightInKg,
      heightCm: _currentHeightInCm,
      age: age,
    );
  }

  double get _calculatedTdee {
    final bmr = _calculatedBmr;
    return TdeeCalculator.calculate(bmr, _activityLevel);
  }

  double get _defaultTargetGoal {
    return (_calculatedTdee / 10).round() * 10.0;
  }

  void _nextPage() {
    if (_currentPage == 0 && !_validateStep1()) return;
    if (_currentPage == 1 && !_validateStep2()) return;

    if (_currentPage == 2) {
      // Transitioning to results: populate goal controller if not customized
      if (!_isCustomGoal || _goalController.text.isEmpty) {
        _goalController.text = _defaultTargetGoal.toStringAsFixed(0);
      }
    }

    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _onFinish() async {
    final age = int.tryParse(_ageController.text.trim()) ?? 25;
    final weightKg = _currentWeightInKg;
    final heightCm = _currentHeightInCm;
    final goalKcal = double.tryParse(_goalController.text.trim()) ?? _defaultTargetGoal;

    final profile = UserProfile(
      gender: _gender,
      age: age,
      heightCm: heightCm,
      weightKg: weightKg,
      activityLevel: _activityLevel,
      dailyGoalKcal: goalKcal,
    );

    // Save unit preferences
    await ref.read(unitSettingsProvider.notifier).updateSettings(
          UnitSettings(weightUnit: _weightUnit, heightUnit: _heightUnit),
        );

    // Save profile -> will trigger GoRouter redirect to /dashboard
    await ref.read(profileProvider.notifier).saveProfile(profile);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.onboardingTitle),
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousPage,
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                children: List.generate(4, (index) {
                  final isActive = index <= _currentPage;
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildStep1(l10n),
                  _buildStep2(l10n),
                  _buildStep3(l10n),
                  _buildStep4(l10n),
                ],
              ),
            ),
            // Bottom Action Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  key: const Key('onboarding_action_button'),
                  onPressed: _currentPage == 3 ? _onFinish : _nextPage,
                  child: Text(
                    _currentPage == 3 ? l10n.finishOnboarding : l10n.nextStep,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET STEP 1: Gender & Age ---
  Widget _buildStep1(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingStep1Title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.onboardingStep1Subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 28),
          Text(
            l10n.gender,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSelectCard(
                  key: const Key('gender_male_card'),
                  icon: Icons.male,
                  title: l10n.male,
                  isSelected: _gender == Gender.male,
                  onTap: () => setState(() => _gender = Gender.male),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSelectCard(
                  key: const Key('gender_female_card'),
                  icon: Icons.female,
                  title: l10n.female,
                  isSelected: _gender == Gender.female,
                  onTap: () => setState(() => _gender = Gender.female),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            l10n.age,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          TextField(
            key: const Key('age_input_field'),
            controller: _ageController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: '25',
              suffixText: l10n.ageUnit,
              errorText: _ageError,
            ),
            onChanged: (_) => _validateStep1(),
          ),
        ],
      ),
    );
  }

  // --- WIDGET STEP 2: Height & Weight ---
  Widget _buildStep2(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingStep2Title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.onboardingStep2Subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          // Height header with unit toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.height,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              SegmentedButton<HeightUnit>(
                key: const Key('height_unit_toggle'),
                segments: const [
                  ButtonSegment(value: HeightUnit.cm, label: Text('cm')),
                  ButtonSegment(value: HeightUnit.ftIn, label: Text('ft-in')),
                ],
                selected: {_heightUnit},
                onSelectionChanged: (set) => _onToggleHeightUnit(set.first),
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_heightUnit == HeightUnit.cm)
            TextField(
              key: const Key('height_cm_field'),
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
              ],
              decoration: InputDecoration(
                hintText: '170',
                suffixText: 'cm',
                errorText: _heightError,
              ),
              onChanged: (_) => _validateStep2(),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('height_ft_field'),
                    controller: _heightFtController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: '5',
                      suffixText: 'ft',
                      errorText: _heightError,
                    ),
                    onChanged: (_) => _validateStep2(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    key: const Key('height_in_field'),
                    controller: _heightInController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                    ],
                    decoration: const InputDecoration(
                      hintText: '7',
                      suffixText: 'in',
                    ),
                    onChanged: (_) => _validateStep2(),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 28),
          // Weight header with unit toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.weight,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              SegmentedButton<WeightUnit>(
                key: const Key('weight_unit_toggle'),
                segments: const [
                  ButtonSegment(value: WeightUnit.kg, label: Text('kg')),
                  ButtonSegment(value: WeightUnit.lb, label: Text('lb')),
                ],
                selected: {_weightUnit},
                onSelectionChanged: (set) => _onToggleWeightUnit(set.first),
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            key: const Key('weight_field'),
            controller: _weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
            ],
            decoration: InputDecoration(
              hintText: _weightUnit == WeightUnit.kg ? '65' : '143',
              suffixText: _weightUnit == WeightUnit.kg ? 'kg' : 'lb',
              errorText: _weightError,
            ),
            onChanged: (_) => _validateStep2(),
          ),
        ],
      ),
    );
  }

  // --- WIDGET STEP 3: Activity Level ---
  Widget _buildStep3(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingStep3Title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.onboardingStep3Subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          _buildActivityCard(
            key: const Key('activity_sedentary_card'),
            level: ActivityLevel.sedentary,
            title: l10n.activitySedentary,
            desc: l10n.activitySedentaryDesc,
            icon: Icons.chair_outlined,
          ),
          _buildActivityCard(
            key: const Key('activity_light_card'),
            level: ActivityLevel.light,
            title: l10n.activityLight,
            desc: l10n.activityLightDesc,
            icon: Icons.directions_walk,
          ),
          _buildActivityCard(
            key: const Key('activity_moderate_card'),
            level: ActivityLevel.moderate,
            title: l10n.activityModerate,
            desc: l10n.activityModerateDesc,
            icon: Icons.fitness_center,
          ),
          _buildActivityCard(
            key: const Key('activity_active_card'),
            level: ActivityLevel.active,
            title: l10n.activityActive,
            desc: l10n.activityActiveDesc,
            icon: Icons.directions_run,
          ),
          _buildActivityCard(
            key: const Key('activity_very_active_card'),
            level: ActivityLevel.veryActive,
            title: l10n.activityVeryActive,
            desc: l10n.activityVeryActiveDesc,
            icon: Icons.flash_on,
          ),
        ],
      ),
    );
  }

  // --- WIDGET STEP 4: Results & Target Goal ---
  Widget _buildStep4(AppLocalizations l10n) {
    final bmr = _calculatedBmr;
    final tdee = _calculatedTdee;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingResultTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.onboardingResultSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          // BMR & TDEE Metrics Card
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bedtime_outlined, size: 20, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            l10n.bmrTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        CalorieFormatter.format(bmr),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      Text(
                        l10n.unitKcal,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.calorieOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.calorieOrange.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.local_fire_department, size: 20, color: AppColors.calorieOrange),
                          const SizedBox(width: 6),
                          Text(
                            l10n.tdeeTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        CalorieFormatter.format(tdee),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.calorieOrangeDark,
                        ),
                      ),
                      Text(
                        l10n.unitKcal,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Formula & Explanation Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calculate_outlined, size: 20, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        l10n.formulaApplied,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.formulaBmrMifflin,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${l10n.formulaTdee} (${_activityLevel.multiplier}x)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Daily Target Calorie Goal
          Text(
            l10n.dailyCalorieTarget,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.dailyTargetHint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          TextField(
            key: const Key('target_goal_input_field'),
            controller: _goalController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              suffixText: l10n.unitKcal,
              suffixIcon: IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: l10n.settingsTargetUseTdee,
                onPressed: () {
                  setState(() {
                    _isCustomGoal = false;
                    _goalController.text = _defaultTargetGoal.toStringAsFixed(0);
                  });
                },
              ),
            ),
            onChanged: (_) {
              setState(() {
                _isCustomGoal = true;
              });
            },
          ),
          const SizedBox(height: 18),
          // Medical disclaimer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 20, color: Colors.amber),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.disclaimer,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.amber.shade900,
                          height: 1.3,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER CARD WIDGETS ---
  Widget _buildSelectCard({
    required Key key,
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final borderColor = isSelected ? AppColors.primary : theme.colorScheme.outline.withOpacity(0.3);
    final bgColor = isSelected ? AppColors.primary.withOpacity(0.08) : theme.cardTheme.color;

    return InkWell(
      key: key,
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 38,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primaryDark : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard({
    required Key key,
    required ActivityLevel level,
    required String title,
    required String desc,
    required IconData icon,
  }) {
    final isSelected = _activityLevel == level;
    final theme = Theme.of(context);
    final borderColor = isSelected ? AppColors.primary : theme.colorScheme.outline.withOpacity(0.3);
    final bgColor = isSelected ? AppColors.primary.withOpacity(0.08) : theme.cardTheme.color;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        key: key,
        onTap: () => setState(() => _activityLevel = level),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (isSelected ? AppColors.primary : Colors.grey).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? AppColors.primary : Colors.grey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? AppColors.primaryDark : null,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      desc,
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
      ),
    );
  }
}
