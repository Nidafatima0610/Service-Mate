import 'package:flutter_test/flutter_test.dart';
import 'package:service_mate/core/utils/currency_formatter.dart';
import 'package:service_mate/core/utils/date_formatter.dart';
import 'package:service_mate/core/utils/input_validators.dart';
import 'package:service_mate/features/bookings/data/booking_repository.dart';
import 'package:service_mate/features/bookings/models/booking_model.dart';
import 'package:service_mate/features/profile/models/user_profile_model.dart';
import 'package:service_mate/features/services/data/service_api_client.dart';
import 'package:service_mate/features/services/data/service_mock_data.dart';

import 'booking_repository_test.dart';

void main() {
  group('Edge Case Tests — Financial Calculations & Formatting', () {
    test('CurrencyFormatter handles whole numbers and fractional decimals accurately', () {
      expect(CurrencyFormatter.format(100.0), '\$100');
      expect(CurrencyFormatter.format(140.50), '\$140.50');
      expect(CurrencyFormatter.formatWithDecimals(100.0), '\$100.00');
      expect(CurrencyFormatter.formatWithDecimals(158.20), '\$158.20');
    });

    test('Booking fee and tax computation edge cases with odd values', () {
      const basePrice = 73.33;
      final serviceFee = double.parse((basePrice * 0.05).toStringAsFixed(2));
      final tax = double.parse(((basePrice + serviceFee) * 0.08).toStringAsFixed(2));
      final total = double.parse((basePrice + serviceFee + tax).toStringAsFixed(2));

      expect(serviceFee, 3.67);
      expect(tax, 6.16);
      expect(total, 83.16);
    });
  });

  group('Edge Case Tests — Profile Initials Generator', () {
    test('handles single name, standard two names, multi-part names, and empty strings', () {
      const pSingle = UserProfile(id: '1', fullName: 'Madonna', email: '', phoneNumber: '', address: '');
      expect(pSingle.initials, 'M');

      const pDouble = UserProfile(id: '2', fullName: 'Alex Vance', email: '', phoneNumber: '', address: '');
      expect(pDouble.initials, 'AV');

      const pMulti = UserProfile(id: '3', fullName: 'Dr. Jane Mary Watson', email: '', phoneNumber: '', address: '');
      expect(pMulti.initials, 'DW');

      const pEmpty = UserProfile(id: '4', fullName: '   ', email: '', phoneNumber: '', address: '');
      expect(pEmpty.initials, 'SM');
    });
  });

  group('Edge Case Tests — Re-booking Cancelled Appointments', () {
    test('allows re-booking the exact same slot after previous booking was cancelled', () async {
      final dataSource = InMemoryBookingDataSource();
      final repository = BookingRepository(dataSource);
      final bookingDate = DateTime.now().add(const Duration(days: 5));

      final firstBooking = await repository.createBooking(
        serviceId: 'clean_01',
        serviceName: 'Deep Sanitization',
        serviceCategory: 'Home Cleaning',
        providerName: 'CleanNest Pro',
        date: bookingDate,
        timeSlot: '10:30 AM',
        customerName: 'Alex Vance',
        customerEmail: 'alex@example.com',
        customerPhone: '+15552345678',
        customerAddress: '123 Market St',
        basePrice: 140.0,
      );

      // Cancel it
      await repository.cancelBooking(firstBooking.id, reason: 'Customer changed mind');

      // Now booking the exact same date & slot should succeed without collision error!
      final secondBooking = await repository.createBooking(
        serviceId: 'clean_01',
        serviceName: 'Deep Sanitization',
        serviceCategory: 'Home Cleaning',
        providerName: 'CleanNest Pro',
        date: bookingDate,
        timeSlot: '10:30 AM',
        customerName: 'Alex Vance',
        customerEmail: 'alex@example.com',
        customerPhone: '+15552345678',
        customerAddress: '123 Market St',
        basePrice: 140.0,
      );

      expect(secondBooking.id, isNot(firstBooking.id));
      expect(secondBooking.status, BookingStatus.confirmed);
    });
  });

  group('Edge Case Tests — Search Queries & Whitespace Handling', () {
    test('handles whitespace-padded search queries and empty strings gracefully', () async {
      final client = MockServiceApiClient(simulatedDelay: Duration.zero);

      final trimmed = await client.fetchServices(searchQuery: '   electrical   ');
      expect(trimmed.isNotEmpty, isTrue);

      final empty = await client.fetchServices(searchQuery: '      ');
      expect(empty.length, ServiceMockData.services.length);

      final notFound = await client.fetchServices(searchQuery: 'xyznonexistentservice123');
      expect(notFound, isEmpty);
    });
  });

  group('Edge Case Tests — Validation Boundary Conditions', () {
    test('address validation enforces min 5 chars', () {
      expect(InputValidators.validateAddress(''), isNotNull);
      expect(InputValidators.validateAddress('123'), contains('at least 5 characters'));
      expect(InputValidators.validateAddress('123 Main St, Suite 400'), isNull);
    });

    test('phone validation detects too short and excessively long inputs', () {
      expect(InputValidators.validatePhone('123456789'), contains('at least 10 digits'));
      expect(InputValidators.validatePhone('12345678901234567'), contains('too long'));
    });

    test('date parsing handles null and corrupted ISO strings safely', () {
      expect(DateFormatter.parseIsoDate(null), isNull);
      expect(DateFormatter.parseIsoDate(''), isNull);
      expect(DateFormatter.parseIsoDate('not-a-date'), isNull);
      expect(DateFormatter.parseIsoDate('2026-11-16'), DateTime(2026, 11, 16));
    });
  });
}
