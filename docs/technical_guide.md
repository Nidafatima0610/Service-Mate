# ServiceMate — Technical Architecture & Developer Guide

## 1. System Overview

ServiceMate is built with Flutter 3.47.1 and Dart 3.13.1, adhering to feature-first architecture, clean separation of concerns, and dependency injection through Riverpod.

---

## 2. State Management Architecture

```dart
// Bookings Notifier
class BookingsNotifier extends AsyncNotifier<List<BookingModel>> {
  @override
  FutureOr<List<BookingModel>> build() async {
    final repository = ref.watch(bookingRepositoryProvider);
    return repository.getAllBookings();
  }

  Future<BookingModel> createBooking({...}) async { ... }
  Future<void> cancelBooking(String id, {String? reason}) async { ... }
}
```

### Provider Matrix

| Provider | Type | Responsibility |
|---|---|---|
| `categoriesProvider` | `FutureProvider<List<ServiceCategory>>` | Loads category list from repository |
| `selectedCategoryFilterProvider` | `NotifierProvider<SelectedCategoryNotifier, String>` | Tracks current category filter ('all' or ID) |
| `searchQueryFilterProvider` | `NotifierProvider<SearchQueryNotifier, String>` | Tracks text search filter |
| `catalogServicesProvider` | `FutureProvider<List<ServiceModel>>` | Reacts to category & query changes |
| `featuredServicesProvider` | `FutureProvider<List<ServiceModel>>` | Filters featured services for Home |
| `popularServicesProvider` | `FutureProvider<List<ServiceModel>>` | Filters popular services for Home |
| `serviceDetailProvider(id)` | `FutureProvider.family<ServiceModel, String>` | Fetches single service by ID |
| `availableSlotsProvider(req)` | `FutureProvider.family<List<TimeSlot>, SlotRequest>` | Resolves slots for service & date |
| `bookingsNotifierProvider` | `AsyncNotifierProvider<BookingsNotifier, List<BookingModel>>` | Manages active and past bookings |
| `upcomingBookingsProvider` | `Provider<List<BookingModel>>` | Filtered list of upcoming bookings |
| `profileNotifierProvider` | `AsyncNotifierProvider<ProfileNotifier, UserProfile>` | User profile state and persistence |

---

## 3. Data & Storage Layer

- **`MockServiceApiClient`:** Implements `IServiceApiClient`. Introduces simulated network latency (350ms) and supports error simulation (`shouldSimulateError = true`) to test retry patterns without network dependencies.
- **`BookingLocalDataSource`:** Interacts with `SharedPreferences`. Automatically seeds two realistic demo bookings upon first launch.
- **`BookingRepository`:** Handles:
  1. Past date verification using `DateFormatter.isPastDate`.
  2. Duplicate booking detection: compares `serviceId`, calendar day (`year, month, day`), and `timeSlot` across active bookings.
  3. Price, fee, and tax calculations.
  4. Unique reference code generation (`SM-XXXXXX`).

---

## 4. Running and Testing the Application

### 4.1 Running the App Locally
```bash
# Web execution
flutter run -d chrome

# Windows desktop execution
flutter run -d windows
```

### 4.2 Running Automated Tests
```bash
flutter test
```

### 4.3 Running Static Analysis
```bash
flutter analyze
```

### 4.4 Building Production Release
```bash
flutter build web --release
```
Output directory: `build/web/`

