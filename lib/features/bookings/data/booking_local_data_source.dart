import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../models/booking_model.dart';

abstract class IBookingLocalDataSource {
  Future<List<BookingModel>> getBookings();
  Future<void> saveBooking(BookingModel booking);
  Future<void> updateBooking(BookingModel booking);
  Future<void> deleteBooking(String id);
  Future<void> clearBookings();
}

class BookingLocalDataSource implements IBookingLocalDataSource {
  final SharedPreferences _prefs;

  BookingLocalDataSource(this._prefs);

  @override
  Future<List<BookingModel>> getBookings() async {
    try {
      final rawList = _prefs.getStringList(AppConstants.keyBookings);
      if (rawList == null) {
        // Seed default demo bookings if first time
        final seeded = _createInitialDemoBookings();
        await _persistBookings(seeded);
        return seeded;
      }
      return rawList.map((str) {
        final map = jsonDecode(str) as Map<String, dynamic>;
        return BookingModel.fromJson(map);
      }).toList();
    } catch (e) {
      throw StorageException('Failed to read bookings from local storage: $e');
    }
  }

  @override
  Future<void> saveBooking(BookingModel booking) async {
    try {
      final bookings = await getBookings();
      // Add new booking to top
      bookings.insert(0, booking);
      await _persistBookings(bookings);
    } catch (e) {
      throw StorageException('Failed to save booking locally: $e');
    }
  }

  @override
  Future<void> updateBooking(BookingModel booking) async {
    try {
      final bookings = await getBookings();
      final index = bookings.indexWhere((b) => b.id == booking.id);
      if (index != -1) {
        bookings[index] = booking;
        await _persistBookings(bookings);
      } else {
        throw const ResourceNotFoundException('Booking to update was not found.');
      }
    } catch (e) {
      if (e is AppException) rethrow;
      throw StorageException('Failed to update booking: $e');
    }
  }

  @override
  Future<void> deleteBooking(String id) async {
    try {
      final bookings = await getBookings();
      bookings.removeWhere((b) => b.id == id);
      await _persistBookings(bookings);
    } catch (e) {
      throw StorageException('Failed to delete booking: $e');
    }
  }

  @override
  Future<void> clearBookings() async {
    await _prefs.remove(AppConstants.keyBookings);
  }

  Future<void> _persistBookings(List<BookingModel> bookings) async {
    final strList = bookings.map((b) => jsonEncode(b.toJson())).toList();
    await _prefs.setStringList(AppConstants.keyBookings, strList);
  }

  List<BookingModel> _createInitialDemoBookings() {
    final now = DateTime.now();
    return [
      BookingModel(
        id: 'demo_book_01',
        referenceCode: 'SM-849201',
        serviceId: 'clean_01',
        serviceName: 'Deep Home Sanitization & Cleaning',
        serviceCategory: 'Home Cleaning',
        providerName: 'CleanNest Pro Living',
        date: DateTime(now.year, now.month, now.day + 2),
        timeSlot: '10:30 AM',
        customerName: 'Alex Vance',
        customerEmail: 'alex.vance@example.com',
        customerPhone: '+1 (555) 234-5678',
        customerAddress: '742 Evergreen Terrace, San Francisco, CA',
        specialInstructions: 'Please focus on kitchen cupboards and bathroom tiles.',
        basePrice: 140.0,
        serviceFee: 7.0,
        tax: 11.2,
        totalPrice: 158.2,
        status: BookingStatus.confirmed,
        createdAt: now.subtract(const Duration(hours: 18)),
      ),
      BookingModel(
        id: 'demo_book_02',
        referenceCode: 'SM-551029',
        serviceId: 'repair_01',
        serviceName: 'Certified Electrical Inspection & Fixes',
        serviceCategory: 'Home Repair',
        providerName: 'Apex Electrical Solutions',
        date: DateTime(now.year, now.month, now.day - 5),
        timeSlot: '01:30 PM',
        customerName: 'Alex Vance',
        customerEmail: 'alex.vance@example.com',
        customerPhone: '+1 (555) 234-5678',
        customerAddress: '742 Evergreen Terrace, San Francisco, CA',
        specialInstructions: 'Replaced living room ceiling light fixture.',
        basePrice: 120.0,
        serviceFee: 6.0,
        tax: 9.6,
        totalPrice: 135.6,
        status: BookingStatus.completed,
        createdAt: now.subtract(const Duration(days: 7)),
      ),
    ];
  }
}

