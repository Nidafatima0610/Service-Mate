import '../../../core/errors/app_exception.dart';
import '../../../core/utils/input_validators.dart';
import '../models/user_profile_model.dart';
import 'profile_local_data_source.dart';

class ProfileRepository {
  final IProfileLocalDataSource _localDataSource;
  UserProfile? _cachedProfile;

  ProfileRepository(this._localDataSource);

  Future<UserProfile> getProfile({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedProfile != null) {
      return _cachedProfile!;
    }
    final profile = await _localDataSource.getProfile();
    _cachedProfile = profile;
    return profile;
  }

  Future<UserProfile> updateProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String address,
  }) async {
    // 1. Validation
    final nameError = InputValidators.validateName(fullName);
    if (nameError != null) throw ValidationException(nameError);

    final emailError = InputValidators.validateEmail(email);
    if (emailError != null) throw ValidationException(emailError);

    final phoneError = InputValidators.validatePhone(phoneNumber);
    if (phoneError != null) throw ValidationException(phoneError);

    final addressError = InputValidators.validateAddress(address);
    if (addressError != null) throw ValidationException(addressError);

    final current = await getProfile();
    final updated = current.copyWith(
      fullName: fullName.trim(),
      email: email.trim(),
      phoneNumber: phoneNumber.trim(),
      address: address.trim(),
    );

    await _localDataSource.saveProfile(updated);
    _cachedProfile = updated;
    return updated;
  }

  Future<void> resetProfile() async {
    await _localDataSource.resetProfile();
    _cachedProfile = null;
  }
}

