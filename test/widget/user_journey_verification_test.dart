import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:service_mate/core/theme/app_theme.dart';
import 'package:service_mate/features/shared/providers/storage_providers.dart';
import 'package:service_mate/features/bookings/data/booking_local_data_source.dart';
import 'package:service_mate/features/bookings/data/booking_repository.dart';
import 'package:service_mate/features/bookings/models/booking_model.dart';
import 'package:service_mate/features/bookings/presentation/screens/booking_confirmation_screen.dart';
import 'package:service_mate/features/bookings/presentation/screens/booking_history_screen.dart';
import 'package:service_mate/features/home/presentation/screens/home_screen.dart';
import 'package:service_mate/features/profile/data/profile_local_data_source.dart';
import 'package:service_mate/features/profile/data/profile_repository.dart';
import 'package:service_mate/features/profile/presentation/screens/profile_screen.dart';
import 'package:service_mate/features/services/data/service_api_client.dart';
import 'package:service_mate/features/services/data/service_mock_data.dart';
import 'package:service_mate/features/services/data/service_repository.dart';
import 'package:service_mate/features/services/presentation/screens/service_catalog_screen.dart';
import 'package:service_mate/features/services/presentation/screens/service_details_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Full User Journey & Cold Restart Persistence Verification', () {
    late SharedPreferences prefs;
    late BookingLocalDataSource bookingDataSource;
    late BookingRepository bookingRepository;
    late ProfileLocalDataSource profileDataSource;
    late ProfileRepository profileRepository;
    late ServiceRepository serviceRepository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      bookingDataSource = BookingLocalDataSource(prefs);
      bookingRepository = BookingRepository(bookingDataSource);
      profileDataSource = ProfileLocalDataSource(prefs);
      profileRepository = ProfileRepository(profileDataSource);
      serviceRepository = ServiceRepository(apiClient: MockServiceApiClient());
    });

    testWidgets('1. Home Screen renders greeting, categories and upcoming bookings', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            bookingRepositoryProvider.overrideWithValue(bookingRepository),
            profileRepositoryProvider.overrideWithValue(profileRepository),
            serviceRepositoryProvider.overrideWithValue(serviceRepository),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Hello, Alex 👋'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
      expect(find.text('Featured Services'), findsOneWidget);
    });

    testWidgets('2. Service Catalog filters categories and displays service cards', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            bookingRepositoryProvider.overrideWithValue(bookingRepository),
            profileRepositoryProvider.overrideWithValue(profileRepository),
            serviceRepositoryProvider.overrideWithValue(serviceRepository),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ServiceCatalogScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Services Catalog'), findsOneWidget);
      expect(find.text('Home Cleaning'), findsWidgets);
      expect(find.text('Beauty & Salon'), findsWidgets);
    });

    testWidgets('3. Service Details Screen displays provider, checklist, and pricing', (tester) async {
      final sampleService = ServiceMockData.services.first;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            bookingRepositoryProvider.overrideWithValue(bookingRepository),
            profileRepositoryProvider.overrideWithValue(profileRepository),
            serviceRepositoryProvider.overrideWithValue(serviceRepository),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: ServiceDetailsScreen(serviceId: sampleService.id),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text(sampleService.name), findsOneWidget);
      expect(find.text(sampleService.providerName), findsOneWidget);
      expect(find.text("What's Included"), findsOneWidget);
      expect(find.text('Book Appointment'), findsOneWidget);
    });

    testWidgets('4. End-to-End Booking Creation, Confirmation & History Verification', (tester) async {
      final sampleService = ServiceMockData.services.first;

      // Create a new booking via repository
      final futureDate = DateTime.now().add(const Duration(days: 3));
      final newBooking = await bookingRepository.createBooking(
        serviceId: sampleService.id,
        serviceName: sampleService.name,
        serviceCategory: sampleService.categoryName,
        providerName: sampleService.providerName,
        date: futureDate,
        timeSlot: '10:00 AM',
        customerName: 'Verified Intern',
        customerEmail: 'intern@arrowstack.dev',
        customerPhone: '+15559876543',
        customerAddress: '100 Innovation Way, Tech Park',
        basePrice: sampleService.price,
      );

      expect(newBooking.referenceCode, startsWith('SM-'));
      expect(newBooking.totalPrice, greaterThan(newBooking.basePrice));

      // Test Booking Confirmation UI with this booking
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: BookingConfirmationScreen(booking: newBooking),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Booking Confirmed!'), findsOneWidget);
      expect(find.text(newBooking.referenceCode), findsOneWidget);
      expect(find.text(newBooking.customerAddress), findsOneWidget);

      // Verify the booking is listed in BookingHistoryScreen
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            bookingRepositoryProvider.overrideWithValue(bookingRepository),
            profileRepositoryProvider.overrideWithValue(profileRepository),
            serviceRepositoryProvider.overrideWithValue(serviceRepository),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const BookingHistoryScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text(newBooking.referenceCode), findsOneWidget);
      expect(find.text('Confirmed'), findsWidgets);
    });

    testWidgets('5. Profile Screen edits and saves user information', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            bookingRepositoryProvider.overrideWithValue(bookingRepository),
            profileRepositoryProvider.overrideWithValue(profileRepository),
            serviceRepositoryProvider.overrideWithValue(serviceRepository),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ProfileScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('My Profile'), findsOneWidget);
      expect(find.text('Save Profile Changes'), findsOneWidget);

      // Update profile directly through repository
      final updatedProfile = await profileRepository.updateProfile(
        fullName: 'Alexander Hamilton',
        email: 'alexander@treasury.gov',
        phoneNumber: '+15557778888',
        address: '10 Wall Street, New York, NY',
      );

      expect(updatedProfile.fullName, 'Alexander Hamilton');
      expect(updatedProfile.initials, 'AH');
    });

    testWidgets('6. Cold Restart Persistence Test: Bookings and Profile survive restart', (tester) async {
      // Step A: Save custom booking and profile in session 1
      final targetDate = DateTime.now().add(const Duration(days: 5));
      final booked = await bookingRepository.createBooking(
        serviceId: ServiceMockData.services[2].id,
        serviceName: ServiceMockData.services[2].name,
        serviceCategory: ServiceMockData.services[2].categoryName,
        providerName: ServiceMockData.services[2].providerName,
        date: targetDate,
        timeSlot: '02:00 PM',
        customerName: 'Persistent User',
        customerEmail: 'persist@test.com',
        customerPhone: '+15551112222',
        customerAddress: '42 Cold Restart Lane',
        basePrice: ServiceMockData.services[2].price,
      );

      await profileRepository.updateProfile(
        fullName: 'Dr. Jane Foster',
        email: 'jane.foster@astrophysics.org',
        phoneNumber: '+15554445555',
        address: 'New Asgard Observatory',
      );

      // Step B: Simulate Cold App Restart by re-instantiating data sources and repositories
      // with the same SharedPreferences mock backing instance
      final restartedBookingDataSource = BookingLocalDataSource(prefs);
      final restartedBookingRepo = BookingRepository(restartedBookingDataSource);
      final restartedProfileDataSource = ProfileLocalDataSource(prefs);
      final restartedProfileRepo = ProfileRepository(restartedProfileDataSource);

      // Step C: Verify persisted bookings after restart
      final recoveredBookings = await restartedBookingRepo.getAllBookings();
      final hasBookedItem = recoveredBookings.any((b) => b.referenceCode == booked.referenceCode);
      expect(hasBookedItem, isTrue, reason: 'Saved booking must persist across app restart');

      final recoveredItem = recoveredBookings.firstWhere((b) => b.referenceCode == booked.referenceCode);
      expect(recoveredItem.customerName, 'Persistent User');
      expect(recoveredItem.serviceName, ServiceMockData.services[2].name);
      expect(recoveredItem.status, BookingStatus.confirmed);

      // Step D: Verify persisted profile after restart
      final recoveredProfile = await restartedProfileRepo.getProfile();
      expect(recoveredProfile.fullName, 'Dr. Jane Foster');
      expect(recoveredProfile.email, 'jane.foster@astrophysics.org');
      expect(recoveredProfile.address, 'New Asgard Observatory');
      expect(recoveredProfile.initials, 'DF');
    });
  });
}
