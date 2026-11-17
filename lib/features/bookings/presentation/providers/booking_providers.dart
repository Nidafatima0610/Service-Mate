import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_mate/core/errors/app_exception.dart';
import 'package:service_mate/features/shared/providers/storage_providers.dart';
import 'package:service_mate/features/bookings/models/booking_model.dart';

class BookingsNotifier extends AsyncNotifier<List<BookingModel>> {
  @override
  FutureOr<List<BookingModel>> build() async {
    final repository = ref.watch(bookingRepositoryProvider);
    return repository.getAllBookings();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(bookingRepositoryProvider);
      return repository.getAllBookings();
    });
  }

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
    final repository = ref.read(bookingRepositoryProvider);

    try {
      final created = await repository.createBooking(
        serviceId: serviceId,
        serviceName: serviceName,
        serviceCategory: serviceCategory,
        providerName: providerName,
        date: date,
        timeSlot: timeSlot,
        customerName: customerName,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
        specialInstructions: specialInstructions,
        basePrice: basePrice,
      );

      // Update state locally with new booking
      final currentList = state.value ?? [];
      state = AsyncValue.data([created, ...currentList]);
      return created;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw AppException('Failed to complete booking: $e');
    }
  }

  Future<void> cancelBooking(String bookingId, {String? reason}) async {
    final repository = ref.read(bookingRepositoryProvider);
    await repository.cancelBooking(bookingId, reason: reason);

    // Refresh state
    final currentList = state.value ?? [];
    final updatedList = currentList.map((b) {
      if (b.id == bookingId) {
        return b.copyWith(
          status: BookingStatus.cancelled,
          cancellationReason: reason ?? 'Cancelled by customer',
          cancelledAt: DateTime.now(),
        );
      }
      return b;
    }).toList();

    state = AsyncValue.data(updatedList);
  }
}

final bookingsNotifierProvider =
    AsyncNotifierProvider<BookingsNotifier, List<BookingModel>>(() {
  return BookingsNotifier();
});

/// Upcoming Bookings Filter Provider
final upcomingBookingsProvider = Provider<List<BookingModel>>((ref) {
  final asyncBookings = ref.watch(bookingsNotifierProvider);
  return asyncBookings.maybeWhen(
    data: (bookings) => bookings.where((b) => b.isUpcoming).toList(),
    orElse: () => [],
  );
});

/// Past / Completed Bookings Filter Provider
final pastBookingsProvider = Provider<List<BookingModel>>((ref) {
  final asyncBookings = ref.watch(bookingsNotifierProvider);
  return asyncBookings.maybeWhen(
    data: (bookings) => bookings.where((b) => b.isCompleted).toList(),
    orElse: () => [],
  );
});

/// Cancelled Bookings Filter Provider
final cancelledBookingsProvider = Provider<List<BookingModel>>((ref) {
  final asyncBookings = ref.watch(bookingsNotifierProvider);
  return asyncBookings.maybeWhen(
    data: (bookings) => bookings.where((b) => b.isCancelled).toList(),
    orElse: () => [],
  );
});

/// Earliest upcoming booking for Home screen preview banner
final nextUpcomingBookingProvider = Provider<BookingModel?>((ref) {
  final upcoming = ref.watch(upcomingBookingsProvider);
  if (upcoming.isEmpty) return null;
  final sorted = List<BookingModel>.from(upcoming)
    ..sort((a, b) => a.date.compareTo(b.date));
  return sorted.first;
});
