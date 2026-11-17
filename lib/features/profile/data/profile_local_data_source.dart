import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../models/user_profile_model.dart';

abstract class IProfileLocalDataSource {
  Future<UserProfile> getProfile();
  Future<void> saveProfile(UserProfile profile);
  Future<void> resetProfile();
}

class ProfileLocalDataSource implements IProfileLocalDataSource {
  final SharedPreferences _prefs;

  ProfileLocalDataSource(this._prefs);

  @override
  Future<UserProfile> getProfile() async {
    try {
      final raw = _prefs.getString(AppConstants.keyUserProfile);
      if (raw == null || raw.isEmpty) {
        final defaultUser = UserProfile.defaultProfile();
        await saveProfile(defaultUser);
        return defaultUser;
      }
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return UserProfile.fromJson(map);
    } catch (e) {
      throw StorageException('Failed to read profile from storage: $e');
    }
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    try {
      final raw = jsonEncode(profile.toJson());
      await _prefs.setString(AppConstants.keyUserProfile, raw);
    } catch (e) {
      throw StorageException('Failed to persist profile: $e');
    }
  }

  @override
  Future<void> resetProfile() async {
    await _prefs.remove(AppConstants.keyUserProfile);
  }
}

