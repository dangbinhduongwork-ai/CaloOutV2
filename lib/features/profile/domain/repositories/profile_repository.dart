import '../entities/user_profile.dart';

/// Repository interface for storing and retrieving user profile data.
/// Always handles measurements in metric units (kg, cm).
abstract interface class ProfileRepository {
  /// Loads saved profile. Returns null if profile is not set or data is corrupted.
  Future<UserProfile?> getProfile();

  /// Persists profile to local storage.
  Future<void> saveProfile(UserProfile profile);

  /// Removes profile data completely.
  Future<void> clearProfile();
}
