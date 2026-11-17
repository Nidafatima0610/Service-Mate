# Technical Decision Log

## ADR 001: Riverpod as State Management Framework
- **Context:** The application requires responsive UI updates, asynchronous data fetching with loading/error handling, and dependency injection across repositories.
- **Decision:** Selected `flutter_riverpod` (v3.5.0) utilizing `AsyncNotifier` and `NotifierProvider`.
- **Consequences:** Eliminates boilerplate, provides compile-time safety, facilitates testing via overrides, and avoids coupling to BuildContext.

## ADR 002: GoRouter with StatefulShellRoute
- **Context:** The application requires a persistent 4-tab bottom navigation shell (Home, Services, Bookings, Profile) while preserving scroll and state across tabs, with external routes for booking wizard and details.
- **Decision:** Adopted `go_router` (v18.1.4) with `StatefulShellRoute.indexedStack`.
- **Consequences:** Preserves tab stack state, provides URL synchronization for web, and enables deep-linking.

## ADR 003: SharedPreferences for Local Storage
- **Context:** The internship requires persisting bookings and profile data across app restarts with zero external native compilation friction.
- **Decision:** Selected `shared_preferences` with JSON encoding/decoding.
- **Consequences:** Lightweight, reliable across all platforms (Web, Mobile, Desktop), zero native build complexity, easily testable with in-memory mocks.

## ADR 004: Self-Contained Vector Iconography
- **Context:** External image URLs are susceptible to network drops, corporate firewalls, and broken CDNs.
- **Decision:** Created self-contained vector-based visual cards with category theme gradients and Material Icons.
- **Consequences:** 100% offline resilient, zero image flicker or broken image placeholders, ultra-crisp display at all pixel densities.

## ADR 005: Dual-Layer Duplicate Booking Protection
- **Context:** Users must be prevented from double-booking slots.
- **Decision:** Implemented conflict checks at both the UI layer (disabling booked time slot chips) and repository layer (`BookingRepository.hasDuplicateBooking`).
- **Consequences:** Prevents race conditions and guarantees data integrity even if the UI layer was bypassed.

