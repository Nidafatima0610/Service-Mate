import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_mate/features/profile/models/user_profile_model.dart';
import 'package:service_mate/features/shared/providers/storage_providers.dart';

class ProfileNotifier extends AsyncNotifier<UserProfile> {
  @override
  FutureOr<UserProfile> build() async {
    final repository = ref.watch(profileRepositoryProvider);
    return repository.getProfile();
  }

  Future<void> updateProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String address,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(profileRepositoryProvider);
      return repository.updateProfile(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        address: address,
      );
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(profileRepositoryProvider);
      return repository.getProfile(forceRefresh: true);
    });
  }
}

final profileNotifierProvider =
    AsyncNotifierProvider<ProfileNotifier, UserProfile>(() {
  return ProfileNotifier();
});
