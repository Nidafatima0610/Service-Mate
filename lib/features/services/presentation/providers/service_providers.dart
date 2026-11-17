import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_mate/features/bookings/models/time_slot_model.dart';
import 'package:service_mate/features/services/models/category_model.dart';
import 'package:service_mate/features/services/models/service_model.dart';
import 'package:service_mate/features/shared/providers/storage_providers.dart';

/// Categories Provider
final categoriesProvider = FutureProvider<List<ServiceCategory>>((ref) async {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getCategories();
});

/// Category Filter Notifier ('all' or specific category id)
class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'all';

  void setCategory(String categoryId) {
    state = categoryId;
  }
}

final selectedCategoryFilterProvider =
    NotifierProvider<SelectedCategoryNotifier, String>(SelectedCategoryNotifier.new);

/// Search Query Notifier
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}

final searchQueryFilterProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

/// Catalog Services Provider reacts to category & search filters
final catalogServicesProvider = FutureProvider<List<ServiceModel>>((ref) async {
  final repository = ref.watch(serviceRepositoryProvider);
  final category = ref.watch(selectedCategoryFilterProvider);
  final search = ref.watch(searchQueryFilterProvider);

  return repository.getServices(
    categoryId: category == 'all' ? null : category,
    searchQuery: search.isEmpty ? null : search,
  );
});

/// Featured Services for Home carousel
final featuredServicesProvider = FutureProvider<List<ServiceModel>>((ref) async {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getFeaturedServices();
});

/// Popular Services for Home list
final popularServicesProvider = FutureProvider<List<ServiceModel>>((ref) async {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getPopularServices();
});

/// Service Detail Provider by ID
final serviceDetailProvider =
    FutureProvider.family<ServiceModel, String>((ref, serviceId) async {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getServiceById(serviceId);
});

/// Available Time Slots Provider for given service and date
class SlotRequest {
  final String serviceId;
  final DateTime date;

  const SlotRequest({required this.serviceId, required this.date});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlotRequest &&
          runtimeType == other.runtimeType &&
          serviceId == other.serviceId &&
          date.year == other.date.year &&
          date.month == other.date.month &&
          date.day == other.date.day;

  @override
  int get hashCode =>
      serviceId.hashCode ^ date.year.hashCode ^ date.month.hashCode ^ date.day.hashCode;
}

final availableSlotsProvider =
    FutureProvider.family<List<TimeSlot>, SlotRequest>((ref, request) async {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getAvailableSlots(request.serviceId, request.date);
});
