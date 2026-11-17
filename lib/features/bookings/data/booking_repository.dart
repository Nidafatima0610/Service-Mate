import 'dart:math';
import '../../../core/errors/app_exception.dart';
import '../../../core/utils/date_formatter.dart';
import '../models/booking_model.dart';
import 'booking_local_data_source.dart';

class BookingRepository {
  final IBookingLocalDataSource _localDataSource;

  BookingRepository(this._localDataSource);

  Future<List<BookingModel>> getAllBookings() async {
    return _localDataSource.getBookings();
  }

  Future<List<BookingModel>> getUpcomingBookings() async {
    final list = await getAllBookings();
    return list.where((b) => b.isUpcoming).toList();
  }

  Future<List<BookingModel>> getPastBookings() async {
    final list = await getAllBookings();
    return list.where((b) => b.isCompleted).toList();
  }

  Future<List<BookingModel>> getCancelledBookings() async {
    final list = await getAllBookings();
    return list.where((b) => b.isCancelled).toList();
  }

  /// Verifies duplicate slot collision across active (non-cancelled) bookings
  Future<bool> hasDuplicateBooking({
    required String serviceId,
    required DateTime date,
    required String timeSlot,
  }) async {
    final bookings = await getAllBookings();
    return bookings.any((b) =>
        b.serviceId == serviceId &&
        b.date.year == date.year &&
        b.date.month == date.month &&
        b.date.day == date.day &&
        b.timeSlot.trim().toLowerCase() == timeSlot.trim().toLowerCase() &&
        b.status != BookingStatus.cancelled);
  }

  /// Creates and persists a new booking with validation & unique reference generation
  Future<BookingModel> createBooking({
    required String serviceId,
    required String serviceName,
    required String serviceCategory,
    required String providerName,
    required DateTime date,
    required String timeSlot,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required String customerAddress,
    String? specialInstructions,
    required double basePrice,
  }) async {
    // 1. Validate past date
    if (DateFormatter.isPastDate(date)) {
      throw const ValidationException('Cannot book an appointment for a past date.');
    }

    // 2. Validate duplicate booking
    final isDuplicate = await hasDuplicateBooking(
      serviceId: serviceId,
      date: date,
      timeSlot: timeSlot,
    );
    if (isDuplicate) {
      throw const BookingDuplicateException(
        'An active booking already exists for this service on the chosen date and time slot.',
      );
    }

    // 3. Calculate fees
    final serviceFee = double.parse((basePrice * 0.05).toStringAsFixed(2));
    final tax = double.parse(((basePrice + serviceFee) * 0.08).toStringAsFixed(2));
    final total = double.parse((basePrice + serviceFee + tax).toStringAsFixed(2));

    // 4. Generate reference code
    final referenceCode = _generateReferenceCode();
    final bookingId = 'book_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';

    final booking = BookingModel(
      id: bookingId,
      referenceCode: referenceCode,
      serviceId: serviceId,
      serviceName: serviceName,
      serviceCategory: serviceCategory,
      providerName: providerName,
      date: DateTime(date.year, date.month, date.day),
      timeSlot: timeSlot,
      customerName: customerName.trim(),
      customerEmail: customerEmail.trim(),
      customerPhone: customerPhone.trim(),
      customerAddress: customerAddress.trim(),
      specialInstructions: specialInstructions?.trim(),
      basePrice: basePrice,
      serviceFee: serviceFee,
      tax: tax,
      totalPrice: total,
      status: BookingStatus.confirmed,
      createdAt: DateTime.now(),
    );

    await _localDataSource.saveBooking(booking);
    return booking;
  }

  Future<void> cancelBooking(String bookingId, {String? reason}) async {
    final bookings = await getAllBookings();
    final target = bookings.firstWhere(
      (b) => b.id == bookingId,
      orElse: () => throw const ResourceNotFoundException('Booking not found.'),
    );

    if (target.isCancelled) {
      return; // Already cancelled
    }

    final updated = target.copyWith(
      status: BookingStatus.cancelled,
      cancellationReason: reason ?? 'Cancelled by customer',
      cancelledAt: DateTime.now(),
    );

    await _localDataSource.updateBooking(updated);
  }

  String _generateReferenceCode() {
    final randomDigits = 100000 + Random().nextInt(900000);
    return 'SM-$randomDigits';
  }
}

