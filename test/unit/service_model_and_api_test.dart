import 'package:flutter_test/flutter_test.dart';
import 'package:service_mate/core/errors/app_exception.dart';
import 'package:service_mate/features/services/data/service_api_client.dart';
import 'package:service_mate/features/services/data/service_repository.dart';
import 'package:service_mate/features/services/models/service_model.dart';

void main() {
  group('ServiceModel & Data Handling', () {
    test('ServiceModel duration formatting handles exact hours and combined hours/mins', () {
      const s1 = ServiceModel(
        id: '1',
        name: 'Service 1',
        categoryId: 'clean',
        categoryName: 'Cleaning',
        description: 'Desc',
        price: 50,
        durationMinutes: 60,
        providerName: 'Provider',
      );
      expect(s1.durationString, '1 hour');

      const s2 = ServiceModel(
        id: '2',
        name: 'Service 2',
        categoryId: 'clean',
        categoryName: 'Cleaning',
        description: 'Desc',
        price: 80,
        durationMinutes: 150,
        providerName: 'Provider',
      );
      expect(s2.durationString, '2 hr 30 min');

      const s3 = ServiceModel(
        id: '3',
        name: 'Service 3',
        categoryId: 'clean',
        categoryName: 'Cleaning',
        description: 'Desc',
        price: 30,
        durationMinutes: 45,
        providerName: 'Provider',
      );
      expect(s3.durationString, '45 mins');
    });

    test('ServiceModel json round-trip serialization', () {
      const original = ServiceModel(
        id: 'clean_01',
        name: 'Deep Clean',
        categoryId: 'home_cleaning',
        categoryName: 'Home Cleaning',
        description: 'Sanitize whole home',
        price: 140.0,
        durationMinutes: 150,
        providerName: 'CleanNest Pro',
        providerRating: 4.9,
        reviewCount: 142,
        isFeatured: true,
        isPopular: true,
        includes: ['Kitchen', 'Bathroom'],
        badge: 'Top Rated',
      );

      final json = original.toJson();
      final restored = ServiceModel.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.price, original.price);
      expect(restored.includes, original.includes);
    });
  });

  group('MockServiceApiClient & ServiceRepository', () {
    late MockServiceApiClient apiClient;
    late ServiceRepository repository;

    setUp(() {
      apiClient = MockServiceApiClient(simulatedDelay: Duration.zero);
      repository = ServiceRepository(apiClient: apiClient);
    });

    test('loads categories and verifies count', () async {
      final categories = await repository.getCategories();
      expect(categories.length, greaterThanOrEqualTo(6));
      expect(categories.any((c) => c.name == 'Home Cleaning'), isTrue);
      expect(categories.any((c) => c.name == 'Tutoring'), isTrue);
    });

    test('filters services by category', () async {
      final cleaningServices = await repository.getServices(categoryId: 'home_cleaning');
      expect(cleaningServices.isNotEmpty, isTrue);
      for (final s in cleaningServices) {
        expect(s.categoryId, 'home_cleaning');
      }
    });

    test('filters services by search query case-insensitively', () async {
      final results = await repository.getServices(searchQuery: 'electrical');
      expect(results.isNotEmpty, isTrue);
      expect(results.first.name.toLowerCase(), contains('electrical'));
    });

    test('fetches available time slots for service', () async {
      final now = DateTime.now();
      final slots = await repository.getAvailableSlots('clean_01', now);
      expect(slots.length, greaterThan(4));
      expect(slots.any((s) => s.label == '09:00 AM'), isTrue);
    });

    test('handles error simulation gracefully', () async {
      apiClient.shouldSimulateError = true;
      expect(() => repository.getCategories(forceRefresh: true), throwsA(isA<NetworkException>()));
    });
  });
}

