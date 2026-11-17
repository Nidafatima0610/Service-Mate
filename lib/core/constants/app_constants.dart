/// Application-wide constants
class AppConstants {
  AppConstants._();

  static const String appName = 'ServiceMate';
  static const String appTagline = 'Premium Service Booking';
  static const String appVersion = '1.0.0 (Arrowstack Build)';

  // Storage Keys
  static const String keyBookings = 'servicemate_saved_bookings_v1';
  static const String keyUserProfile = 'servicemate_user_profile_v1';
  static const String keyFirstLaunch = 'servicemate_first_launch_v1';

  // Demo Location
  static const String defaultLocation = 'San Francisco, Bay Area (Demo)';

  // Fee calculation
  static const double serviceFeePercentage = 0.05; // 5% platform fee
  static const double taxPercentage = 0.08; // 8% local tax
}

