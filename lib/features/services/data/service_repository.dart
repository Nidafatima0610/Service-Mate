import '../models/category_model.dart';
import '../models/service_model.dart';
import '../../bookings/models/time_slot_model.dart';
import 'service_api_client.dart';

class ServiceRepository {
  final IServiceApiClient _apiClient;
  List<ServiceModel>? _cachedServices;
  List<ServiceCategory>? _cachedCategories;

  ServiceRepository({IServiceApiClient? apiClient})
      : _apiClient = apiClient ?? MockServiceApiClient();

  Future<List<ServiceCategory>> getCategories({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedCategories != null) {
      return _cachedCategories!;
    }
    final categories = await _apiClient.fetchCategories();
    _cachedCategories = categories;
    return categories;
  }

  Future<List<ServiceModel>> getServices({
    String? categoryId,
    String? searchQuery,
    bool forceRefresh = false,
  }) async {
    final services = await _apiClient.fetchServices(
      categoryId: categoryId,
      searchQuery: searchQuery,
    );
    if (categoryId == null && searchQuery == null) {
      _cachedServices = services;
    }
    return services;
  }

  Future<List<ServiceModel>> getFeaturedServices() async {
    final all = await getServices();
    return all.where((s) => s.isFeatured).toList();
  }

  Future<List<ServiceModel>> getPopularServices() async {
    final all = await getServices();
    return all.where((s) => s.isPopular).toList();
  }

  Future<ServiceModel> getServiceById(String id) async {
    // If cached, return from cache if present
    if (_cachedServices != null) {
      try {
        return _cachedServices!.firstWhere((s) => s.id == id);
      } catch (_) {}
    }
    return _apiClient.getServiceById(id);
  }

  Future<List<TimeSlot>> getAvailableSlots(String serviceId, DateTime date) {
    return _apiClient.fetchAvailableSlots(serviceId, date);
  }
}

