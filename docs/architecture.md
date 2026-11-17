# ServiceMate — System Architecture & Technical Design

**Arrowstack Flutter App Development Internship Evaluation**  
**Project:** ServiceMate — Service Booking App  
**Document:** System Architecture (`architecture.md`)  
**Date:** November 17, 2026  
**Status:** Implemented & Verified  

---

## 1. Architectural Overview

ServiceMate follows a **Layered, Feature-First Clean Architecture** with the **Repository Pattern** and **Flutter Riverpod**. This architectural pattern achieves a clear separation of concerns, decouples domain business logic from the user interface, facilitates unit testing without mocking external infrastructure, and provides offline resilience.

```
┌────────────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                              │
│  ┌──────────────────────┐  ┌─────────────────────┐  ┌────────────────┐ │
│  │    Screens & Views   │  │   Reusable Widgets  │  │ Shell & Router │ │
│  │ (Catalog, Wizard,...)│  │ (AppButton, Cards)  │  │   (GoRouter)   │ │
│  └──────────┬───────────┘  └──────────┬──────────┘  └───────┬────────┘ │
└─────────────┼─────────────────────────┼─────────────────────┼──────────┘
              │                         │                     │
              ▼                         ▼                     ▼
┌────────────────────────────────────────────────────────────────────────┐
│                   STATE MANAGEMENT LAYER (Riverpod)                    │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │ AsyncNotifiers: BookingsNotifier, ProfileNotifier                │  │
│  │ Synchronous Notifiers: SelectedCategoryNotifier, SearchQuery     │  │
│  │ FutureProviders: ServiceCatalogProvider, AvailableSlotsProvider  │  │
│  └──────────────────────────────────┬───────────────────────────────┘  │
└─────────────────────────────────────┼──────────────────────────────────┘
                                      │ Invokes methods / watches
                                      ▼
┌────────────────────────────────────────────────────────────────────────┐
│                         DOMAIN & REPOSITORY LAYER                      │
│  ┌───────────────────────────┐         ┌────────────────────────────┐  │
│  │     ServiceRepository     │         │     BookingRepository      │  │
│  │  (Catalog & Availability) │         │ (Fee Math, Validation,     │  │
│  └─────────────┬─────────────┘         │  Duplicate Collision Guard)│  │
│                │                       └─────────────┬──────────────┘  │
└────────────────┼─────────────────────────────────────┼─────────────────┘
                 │ Coordinates                         │ Coordinates
                 ▼                                     ▼
┌────────────────────────────────────────────────────────────────────────┐
│                         DATA SOURCES LAYER                             │
│  ┌───────────────────────────┐         ┌────────────────────────────┐  │
│  │   MockServiceApiClient    │         │  BookingLocalDataSource    │  │
│  │  (Simulated Latency 350ms,│         │  ProfileLocalDataSource    │  │
│  │   Fallback Catalog Data)  │         │   (SharedPreferences JSON) │  │
│  └───────────────────────────┘         └────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Directory & Package Structure

The project structure is organized by feature modules, with a shared `core` folder for foundational cross-cutting concerns:

```
lib/
├── app.dart                                    # MaterialApp.router configuration, theme bindings
├── main.dart                                   # SharedPreferences pre-warming & ProviderScope setup
├── core/
│   ├── constants/
│   │   ├── app_colors.dart                     # Midnight Navy, Teal accent, Ivory canvas palette
│   │   ├── app_constants.dart                  # Global fee constants (5% fee, 8% tax), keys
│   │   └── app_typography.dart                 # Scalable font sizing, weights, line heights
│   ├── errors/
│   │   └── app_exception.dart                  # Domain exceptions: Validation, Duplicate, Network
│   ├── router/
│   │   └── app_router.dart                     # GoRouter configuration with StatefulShellRoute
│   ├── theme/
│   │   └── app_theme.dart                      # Material 3 light theme definition & widget themes
│   └── utils/
│       ├── currency_formatter.dart             # USD currency formatting ($XX.XX)
│       ├── date_formatter.dart                 # Formats ISO dates, 14-day strip, past-date checks
│       └── input_validators.dart               # Name, email, phone, and address validation rules
├── features/
│   ├── home/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── home_screen.dart            # Header, search, categories, featured, banner
│   │       │   └── main_navigation_shell.dart  # Indexed BottomNavigationBar shell
│   │       └── widgets/
│   │           ├── home_header.dart            # Greeting & quick profile avatar
│   │           └── upcoming_booking_banner.dart# Live preview of next upcoming booking
│   ├── services/
│   │   ├── data/
│   │   │   ├── service_api_client.dart         # IServiceApiClient & MockServiceApiClient
│   │   │   ├── service_mock_data.dart          # 15 realistic services across 6 categories
│   │   │   └── service_repository.dart         # Query filters, category search, slot queries
│   │   ├── models/
│   │   │   ├── category_model.dart             # Category entity with icon and color bindings
│   │   │   └── service_model.dart              # Service entity with price, duration, rating
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── service_providers.dart      # CategoryNotifier, SearchQueryNotifier, Catalog
│   │       ├── screens/
│   │       │   ├── service_catalog_screen.dart # Searchable catalog with active chip filters
│   │       │   └── service_details_screen.dart # Full service details, provider card, checklist
│   │       └── widgets/
│   │           ├── category_chip.dart          # Interactive category filter chip
│   │           ├── service_card.dart           # Reusable service list/grid card
│   │           └── service_rating_badge.dart   # Star rating and review count badge
│   ├── bookings/
│   │   ├── data/
│   │   │   ├── booking_local_data_source.dart  # SharedPreferences JSON persistence engine
│   │   │   └── booking_repository.dart         # Duplicate detection, fee math, cancellation
│   │   ├── models/
│   │   │   ├── booking_model.dart              # Booking domain model & BookingStatus enum
│   │   │   └── time_slot_model.dart            # TimeSlot entity with SlotPeriod enum
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── booking_providers.dart      # BookingsNotifier AsyncNotifier
│   │       ├── screens/
│   │       │   ├── booking_cancel_dialog.dart  # Reason-based cancellation modal dialog
│   │       │   ├── booking_confirmation_screen.dart # Celebration screen with ref code copy
│   │       │   ├── booking_details_dialog.dart # Itemized receipt modal bottom sheet
│   │       │   ├── booking_history_screen.dart # Tabbed history (Upcoming, Completed, Cancelled)
│   │       │   └── booking_wizard_screen.dart  # 3-step interactive booking wizard
│   │       └── widgets/
│   │           ├── booking_card.dart           # History card with status chip and details CTA
│   │           ├── booking_status_badge.dart   # Color-coded badge (Confirmed, Cancelled, Done)
│   │           ├── date_selector_strip.dart    # 14-day horizontal rolling date strip
│   │           └── time_slot_selector.dart     # Period-grouped time slot chips
│   └── profile/
│       ├── data/
│       │   ├── profile_local_data_source.dart  # SharedPreferences user profile storage
│       │   └── profile_repository.dart         # Profile update validation & persistence
│       ├── models/
│       │   └── user_profile_model.dart         # UserProfile domain model with initials helper
│       └── presentation/
│           ├── providers/
│           │   └── profile_providers.dart      # ProfileNotifier AsyncNotifier
│           └── screens/
│               └── profile_screen.dart         # Profile editor with live validation & reset
└── shared/
    └── widgets/
        ├── app_button.dart                     # Custom button with loading spinner state
        ├── app_text_field.dart                 # Custom styled input with validation feedback
        ├── demo_banner.dart                    # Non-intrusive demo mode pill banner
        ├── empty_state_view.dart               # Empty data illustration & action trigger
        └── error_state_view.dart               # Error message illustration & retry button
```

---

## 3. State Management (Riverpod 3.0 Architecture)

ServiceMate implements Flutter Riverpod 3.5.0 using the modern `Notifier` and `AsyncNotifier` patterns:

1. **`BookingsNotifier` (`AsyncNotifier<List<BookingModel>>`):**
   - Manages the primary list of active and historical user bookings.
   - Automatically initializes by loading persisted records from `BookingRepository` upon first read.
   - Exposes clean action methods: `createBooking(...)` and `cancelBooking(...)`.
   - Maintains `AsyncValue` lifecycle (`data`, `loading`, `error`), enabling automatic UI updates without `setState`.
2. **`ProfileNotifier` (`AsyncNotifier<UserProfileModel>`):**
   - Manages user identity and contact preferences.
   - Exposes `updateProfile(...)` and `resetToDemoDefaults()`.
   - Persists changes immediately to local storage and notifies listeners (such as the Home header greeting).
3. **`SelectedCategoryNotifier` & `SearchQueryNotifier` (`Notifier<T>`):**
   - Specialized lightweight synchronous notifiers controlling filter state.
   - Prevents unnecessary full-screen re-renders by allowing consumers to watch only the specific slice of state they depend upon.
4. **`filteredServicesProvider` (`FutureProvider<List<ServiceModel>>`):**
   - Reactive provider that computes the filtered service catalog by listening to `selectedCategoryFilterProvider` and `searchQueryFilterProvider`.

---

## 4. Navigation & Routing (GoRouter)

Routing is configured via **GoRouter 14.8.1** in [`app_router.dart`](file:///c:/Users/umair/Desktop/service_mate/lib/core/router/app_router.dart):

- **`StatefulShellRoute.indexedStack`:** Maintains state for the 4 primary tabs (Home, Catalog, Bookings, Profile). When switching tabs, scroll positions, form inputs, and tab states are preserved without recreating widget subtrees.
- **Parametric Routing:**
  - `/catalog/details/:serviceId`: Navigates to the service details screen with dynamic ID resolution.
  - `/book/:serviceId`: Navigates to the booking wizard with service context pre-fetched.
  - `/book/confirmation`: Navigates to the celebration screen passing `BookingModel` via GoRouter `extra`.
- **Deep Linking Ready:** Uses standard URI paths allowing seamless web URL navigation and mobile intent handling.

---

## 5. API / Data-Source Approach

ServiceMate utilizes an interface-driven approach for data access:

1. **Contract Definition (`IServiceApiClient`):**
   - Defines asynchronous methods: `fetchCategories()`, `fetchServices()`, `fetchServiceById(id)`, `fetchAvailableSlots(serviceId, date)`.
2. **Implementation (`MockServiceApiClient`):**
   - Simulates realistic asynchronous network latency using `Future.delayed(const Duration(milliseconds: 350))` to exercise loading spinners.
   - Provides a resilient offline-first dataset with 15 fictional services across 6 categories.
   - Includes error simulation capability to verify network error recovery in automated tests.
3. **Transition to Production Cloud API:**
   - Replacing the mock source with a live REST or GraphQL backend requires only creating a `RemoteServiceApiClient implements IServiceApiClient` using `http` or `dio`, with zero changes required in repositories, providers, or presentation widgets.

---

## 6. Local Storage Architecture

Local storage is handled by `SharedPreferences` with custom JSON serialization:

- **`BookingLocalDataSource`:**
  - Storage key: `servicemate_bookings_v1`.
  - Serializes a `List<BookingModel>` to a JSON string array.
  - Seeds two realistic demonstration bookings upon first run so mentors and evaluators immediately experience a populated application.
- **`ProfileLocalDataSource`:**
  - Storage key: `servicemate_user_profile_v1`.
  - Serializes `UserProfileModel` to JSON.
  - Seeds a default demo profile ("Sarah Jenkins", "sarah.jenkins@example.com", "+1 (555) 234-5678", "742 Evergreen Terrace, San Francisco, CA").

---

## 7. Data Models

```
┌─────────────────────────────────┐       ┌─────────────────────────────────┐
│          ServiceModel           │       │          BookingModel           │
├─────────────────────────────────┤       ├─────────────────────────────────┤
│ String id                       │       │ String id                       │
│ String title                    │       │ String referenceCode            │
│ String categoryId               │       │ String serviceId                │
│ String categoryName             │       │ String serviceTitle             │
│ String description              │       │ String categoryName             │
│ double price                    │       │ String providerName             │
│ int durationMinutes             │       │ DateTime appointmentDate        │
│ String providerName             │       │ String timeSlot                 │
│ double rating                   │       │ String customerName             │
│ int reviewCount                 │       │ String customerEmail            │
│ List<String> includedFeatures   │       │ String customerPhone            │
│ bool isPopular                  │       │ String customerAddress          │
│ bool isFeatured                 │       │ String? notes                   │
└─────────────────────────────────┘       │ double basePrice                │
                                          │ double platformFee              │
┌─────────────────────────────────┐       │ double taxAmount                │
│         TimeSlotModel           │       │ double totalPrice               │
├─────────────────────────────────┤       │ BookingStatus status            │
│ String id                       │       │ DateTime createdAt              │
│ String time                     │       │ DateTime? cancelledAt           │
│ SlotPeriod period               │       │ String? cancellationReason      │
│ bool isAvailable                │       └─────────────────────────────────┘
└─────────────────────────────────┘
```

---

## 8. Important Technical Decisions & Trade-Offs

| Decision | Rationale | Trade-Off |
|---|---|---|
| **Local Vector Graphics over Network URLs** | Guarantees 100% offline uptime; zero layout shifts; no broken image icons during evaluation. | Requires vector icon mapping instead of dynamic multi-megabyte photography. |
| **Dual-Layer Validation** | Validates forms at UI touchpoints (`InputValidators`) AND business layers (`BookingRepository`). | Slight redundancy in checks, but guarantees data integrity even if UI state is bypassed. |
| **Synchronous `SharedPreferences` Pre-Warming** | `SharedPreferences.getInstance()` is resolved in `main()` before calling `runApp()`. | Slight 50ms startup delay, but eliminates all asynchronous loading jank when reading cached data. |
| **StatefulShellRoute over TabBar** | Preserves state, scroll position, and text inputs across tab switching. | Requires deeper routing tree configuration compared to a simple `IndexedStack`. |
