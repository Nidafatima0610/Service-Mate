import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bookings/data/booking_local_data_source.dart';
import '../../bookings/data/booking_repository.dart';
import '../../profile/data/profile_local_data_source.dart';
import '../../profile/data/profile_repository.dart';
import '../../services/data/service_api_client.dart';
import '../../services/data/service_repository.dart';

/// Provider for SharedPreferences instance initialized at startup
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden at main initialization.');
});

/// API Client Provider
final serviceApiClientProvider = Provider<IServiceApiClient>((ref) {
  return MockServiceApiClient();
});

/// Service Repository Provider
final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  final apiClient = ref.watch(serviceApiClientProvider);
  return ServiceRepository(apiClient: apiClient);
});

/// Booking Data Source & Repository
final bookingLocalDataSourceProvider = Provider<IBookingLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return BookingLocalDataSource(prefs);
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final dataSource = ref.watch(bookingLocalDataSourceProvider);
  return BookingRepository(dataSource);
});

/// Profile Data Source & Repository
final profileLocalDataSourceProvider = Provider<IProfileLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ProfileLocalDataSource(prefs);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dataSource = ref.watch(profileLocalDataSourceProvider);
  return ProfileRepository(dataSource);
});

