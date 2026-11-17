import 'dart:async';
import '../../../core/errors/app_exception.dart';
import '../../bookings/models/time_slot_model.dart';
import '../models/category_model.dart';
import '../models/service_model.dart';
import 'service_mock_data.dart';

/// Abstract API client interface defining data contracts for services
abstract class IServiceApiClient {
  Future<List<ServiceCategory>> fetchCategories();
  Future<List<ServiceModel>> fetchServices({String? categoryId, String? searchQuery});
  Future<ServiceModel> getServiceById(String id);
  Future<List<TimeSlot>> fetchAvailableSlots(String serviceId, DateTime date);
}

/// Simulated API Client with latency, offline fallback, and error injection for testing
class MockServiceApiClient implements IServiceApiClient {
  final Duration simulatedDelay;
  bool shouldSimulateError;

  MockServiceApiClient({
    this.simulatedDelay = const Duration(milliseconds: 350),
    this.shouldSimulateError = false,
  });

  @override
  Future<List<ServiceCategory>> fetchCategories() async {
    await Future.delayed(simulatedDelay);
    if (shouldSimulateError) {
      throw const NetworkException('Unable to reach ServiceMate API server. Check your connection.');
    }
    return ServiceMockData.categories;
  }

  @override
  Future<List<ServiceModel>> fetchServices({
    String? categoryId,
    String? searchQuery,
  }) async {
    await Future.delayed(simulatedDelay);
    if (shouldSimulateError) {
      throw const NetworkException('Failed to fetch catalog from server. Tap retry.');
    }

    var list = List<ServiceModel>.from(ServiceMockData.services);

    if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') {
      list = list.where((s) => s.categoryId == categoryId).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final query = searchQuery.toLowerCase().trim();
      list = list.where((s) {
        return s.name.toLowerCase().contains(query) ||
            s.description.toLowerCase().contains(query) ||
            s.providerName.toLowerCase().contains(query) ||
            s.categoryName.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }

  @override
  Future<ServiceModel> getServiceById(String id) async {
    await Future.delayed(simulatedDelay);
    if (shouldSimulateError) {
      throw const NetworkException('Failed to load service details.');
    }

    final found = ServiceMockData.services.where((s) => s.id == id);
    if (found.isEmpty) {
      throw ResourceNotFoundException('Service with ID $id not found.');
    }
    return found.first;
  }

  @override
  Future<List<TimeSlot>> fetchAvailableSlots(String serviceId, DateTime date) async {
    await Future.delayed(simulatedDelay);
    if (shouldSimulateError) {
      throw const NetworkException('Failed to load available time slots.');
    }

    // Deterministic simulated slot availability based on date & service
    final slots = TimeSlot.standardSlots.map((slot) {
      // Simulate that a couple of slots are booked depending on the day of month
      final isSlotOccupied = (date.day + slot.id.hashCode) % 5 == 0;
      return TimeSlot(
        id: slot.id,
        label: slot.label,
        period: slot.period,
        isAvailable: !isSlotOccupied,
      );
    }).toList();

    return slots;
  }
}

