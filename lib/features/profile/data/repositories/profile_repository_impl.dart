import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/user_profile_model.dart';

/// Implementation of ProfileRepository backed by SharedPreferences.
/// Defensive against corrupted or missing data: returns null instead of throwing.
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<UserProfile?> getProfile() async {
    final rawJson = _prefs.getString(AppConstants.keyProfile);
    if (rawJson == null || rawJson.trim().isEmpty) {
      return null;
    }

    try {
      final dynamic decoded = json.decode(rawJson);
      if (decoded is! Map<dynamic, dynamic>) {
        return null;
      }
      final map = Map<String, dynamic>.from(decoded);
      final model = UserProfileModel.fromJson(map);
      return model.toEntity();
    } catch (_) {
      // Data is corrupted or missing fields: treat as no profile
      return null;
    }
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    final model = UserProfileModel.fromEntity(profile);
    final jsonStr = json.encode(model.toJson());
    await _prefs.setString(AppConstants.keyProfile, jsonStr);
  }

  @override
  Future<void> clearProfile() async {
    await _prefs.remove(AppConstants.keyProfile);
  }
}
