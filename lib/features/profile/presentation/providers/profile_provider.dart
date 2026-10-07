import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caloout/core/theme/theme_provider.dart';
import 'package:caloout/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:caloout/features/profile/domain/entities/user_profile.dart';
import 'package:caloout/features/profile/domain/repositories/profile_repository.dart';
import 'package:caloout/features/profile/domain/services/bmr_calculator.dart';
import 'package:caloout/features/profile/domain/services/tdee_calculator.dart';

/// Provider for ProfileRepository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ProfileRepositoryImpl(prefs);
});

/// AsyncNotifier managing the user profile lifecycle (load, save, update, clear)
class ProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    final repository = ref.watch(profileRepositoryProvider);
    return repository.getProfile();
  }

  /// Persists a new profile and updates state
  Future<void> saveProfile(UserProfile profile) async {
    state = const AsyncLoading();
    final repository = ref.read(profileRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.saveProfile(profile);
      return profile;
    });
  }

  /// Alias for saveProfile
  Future<void> updateProfile(UserProfile profile) async {
    await saveProfile(profile);
  }

  /// Clears profile from local storage and resets state to null
  Future<void> clearProfile() async {
    state = const AsyncLoading();
    final repository = ref.read(profileRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.clearProfile();
      return null;
    });
  }
}

/// Provider for UserProfile state
final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, UserProfile?>(ProfileNotifier.new);

/// Computed provider for BMR based on the currently loaded profile
final currentBmrProvider = Provider<double?>((ref) {
  final profile = ref.watch(profileProvider).valueOrNull;
  if (profile == null) return null;
  return BmrCalculator.calculate(profile);
});

/// Computed provider for TDEE based on the currently loaded profile
final currentTdeeProvider = Provider<double?>((ref) {
  final bmr = ref.watch(currentBmrProvider);
  final profile = ref.watch(profileProvider).valueOrNull;
  if (bmr == null || profile == null) return null;
  return TdeeCalculator.calculate(bmr, profile.activityLevel);
});

/// Computed provider for daily target calories (profile override or TDEE rounded to nearest 10)
final currentDailyGoalProvider = Provider<double?>((ref) {
  final profile = ref.watch(profileProvider).valueOrNull;
  if (profile == null) return null;
  if (profile.dailyGoalKcal != null && profile.dailyGoalKcal! > 0) {
    return profile.dailyGoalKcal;
  }
  final tdee = ref.watch(currentTdeeProvider);
  if (tdee == null) return null;
  // Default to TDEE rounded to nearest 10
  return (tdee / 10).round() * 10.0;
});
