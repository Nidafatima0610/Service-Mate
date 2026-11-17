import 'package:flutter_test/flutter_test.dart';
import 'package:service_mate/core/errors/app_exception.dart';
import 'package:service_mate/features/bookings/data/booking_local_data_source.dart';
import 'package:service_mate/features/bookings/data/booking_repository.dart';
import 'package:service_mate/features/bookings/models/booking_model.dart';

class InMemoryBookingDataSource implements IBookingLocalDataSource {
  final List<BookingModel> _bookings = [];

  @override
  Future<List<BookingModel>> getBookings() async => List.from(_bookings);

  @override
  Future<void> saveBooking(BookingModel booking) async {
    _bookings.insert(0, booking);
  }

  @override
  Future<void> updateBooking(BookingModel booking) async {
    final idx = _bookings.indexWhere((b) => b.id == booking.id);
    if (idx != -1) {
      _bookings[idx] = booking;
    } else {
      throw const ResourceNotFoundException();
    }
  }

  @override
  Future<void> deleteBooking(String id) async {
    _bookings.removeWhere((b) => b.id == id);
  }

  @override
  Future<void> clearBookings() async {
    _bookings.clear();
  }
}

void main() {
  group('BookingRepository - Core Business Logic & Validation', () {
    late InMemoryBookingDataSource dataSource;
    late BookingRepository repository;

    setUp(() {
      dataSource = InMemoryBookingDataSource();
      repository = BookingRepository(dataSource);
    });

    test('successfully creates a booking with reference code and fee breakdown', () async {
      final futureDate = DateTime.now().add(const Duration(days: 3));

      final booking = await repository.createBooking(
        serviceId: 'clean_01',
        serviceName: 'Deep Sanitization',
        serviceCategory: 'Home Cleaning',
        providerName: 'CleanNest Pro',
        date: futureDate,
        timeSlot: '10:30 AM',
        customerName: 'Alex Vance',
        customerEmail: 'alex@example.com',
        customerPhone: '+15552345678',
        customerAddress: '123 Market St, San Francisco, CA',
        basePrice: 100.0,
      );

      expect(booking.id, isNotEmpty);
      expect(booking.referenceCode.startsWith('SM-'), isTrue);
      expect(booking.basePrice, 100.0);
      expect(booking.serviceFee, 5.0); // 5%
      expect(booking.tax, 8.4); // 8% of 105
      expect(booking.totalPrice, 113.4);
      expect(booking.status, BookingStatus.confirmed);
      expect(booking.isUpcoming, isTrue);

      final stored = await repository.getAllBookings();
      expect(stored.length, 1);
      expect(stored.first.id, booking.id);
    });

    test('rejects booking with past date', () async {
      final pastDate = DateTime.now().subtract(const Duration(days: 2));

      expect(
        () => repository.createBooking(
          serviceId: 'clean_01',
          serviceName: 'Deep Sanitization',
          serviceCategory: 'Home Cleaning',
          providerName: 'CleanNest Pro',
          date: pastDate,
          timeSlot: '10:30 AM',
          customerName: 'Alex Vance',
          customerEmail: 'alex@example.com',
          customerPhone: '+15552345678',
          customerAddress: '123 Market St',
          basePrice: 100.0,
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('prevents duplicate booking for the same service, date, and slot', () async {
      final targetDate = DateTime.now().add(const Duration(days: 2));

      await repository.createBooking(
        serviceId: 'clean_01',
        serviceName: 'Deep Sanitization',
        serviceCategory: 'Home Cleaning',
        providerName: 'CleanNest Pro',
        date: targetDate,
        timeSlot: '01:30 PM',
        customerName: 'Alex Vance',
        customerEmail: 'alex@example.com',
        customerPhone: '+15552345678',
        customerAddress: '123 Market St',
        basePrice: 100.0,
      );

      // Attempt second identical slot
      expect(
        () => repository.createBooking(
          serviceId: 'clean_01',
          serviceName: 'Deep Sanitization',
          serviceCategory: 'Home Cleaning',
          providerName: 'CleanNest Pro',
          date: targetDate,
          timeSlot: '01:30 PM',
          customerName: 'John Doe',
          customerEmail: 'john@example.com',
          customerPhone: '+15559998877',
          customerAddress: '456 Mission St',
          basePrice: 100.0,
        ),
        throwsA(isA<BookingDuplicateException>()),
      );
    });

    test('allows booking cancellation and updates status', () async {
      final futureDate = DateTime.now().add(const Duration(days: 4));

      final booking = await repository.createBooking(
        serviceId: 'photo_01',
        serviceName: 'Portrait Session',
        serviceCategory: 'Photography',
        providerName: 'Golden Hour Studios',
        date: futureDate,
        timeSlot: '03:00 PM',
        customerName: 'Alex Vance',
        customerEmail: 'alex@example.com',
        customerPhone: '+15552345678',
        customerAddress: 'Golden Gate Park',
        basePrice: 200.0,
      );

      await repository.cancelBooking(booking.id, reason: 'Bad weather forecasted');

      final cancelledList = await repository.getCancelledBookings();
      expect(cancelledList.length, 1);
      expect(cancelledList.first.id, booking.id);
      expect(cancelledList.first.status, BookingStatus.cancelled);
      expect(cancelledList.first.cancellationReason, 'Bad weather forecasted');
      expect(cancelledList.first.cancelledAt, isNotNull);
    });
  });
}

