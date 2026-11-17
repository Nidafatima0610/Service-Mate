import 'package:flutter_test/flutter_test.dart';
import 'package:service_mate/core/errors/app_exception.dart';
import 'package:service_mate/features/profile/data/profile_local_data_source.dart';
import 'package:service_mate/features/profile/data/profile_repository.dart';
import 'package:service_mate/features/profile/models/user_profile_model.dart';

class InMemoryProfileDataSource implements IProfileLocalDataSource {
  UserProfile? _profile;

  @override
  Future<UserProfile> getProfile() async {
    return _profile ?? UserProfile.defaultProfile();
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    _profile = profile;
  }

  @override
  Future<void> resetProfile() async {
    _profile = null;
  }
}

void main() {
  group('ProfileRepository', () {
    late InMemoryProfileDataSource dataSource;
    late ProfileRepository repository;

    setUp(() {
      dataSource = InMemoryProfileDataSource();
      repository = ProfileRepository(dataSource);
    });

    test('initializes with default demo profile', () async {
      final profile = await repository.getProfile();
      expect(profile.fullName, 'Alex Vance');
      expect(profile.email, 'alex.vance@example.com');
      expect(profile.initials, 'AV');
    });

    test('updates profile and persists new details', () async {
      final updated = await repository.updateProfile(
        fullName: 'Morgan Freeman',
        email: 'morgan@freeman.com',
        phoneNumber: '+15551234567',
        address: '500 Hollywood Blvd, Los Angeles, CA',
      );

      expect(updated.fullName, 'Morgan Freeman');
      expect(updated.email, 'morgan@freeman.com');
      expect(updated.initials, 'MF');

      final reloaded = await repository.getProfile();
      expect(reloaded.fullName, 'Morgan Freeman');
      expect(reloaded.address, '500 Hollywood Blvd, Los Angeles, CA');
    });

    test('validates inputs before updating profile', () async {
      // Invalid name
      expect(
        () => repository.updateProfile(
          fullName: 'A',
          email: 'valid@example.com',
          phoneNumber: '+15551234567',
          address: 'Valid address street',
        ),
        throwsA(isA<ValidationException>()),
      );

      // Invalid email
      expect(
        () => repository.updateProfile(
          fullName: 'Valid Name',
          email: 'bad-email',
          phoneNumber: '+15551234567',
          address: 'Valid address street',
        ),
        throwsA(isA<ValidationException>()),
      );
    });
  });
}

