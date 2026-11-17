# ServiceMate — Limitations & Future Scope

**Arrowstack Flutter App Development Internship Evaluation**  
**Project:** ServiceMate — Service Booking App  
**Document:** Limitations & Future Scope (`limitations_and_future_scope.md`)  
**Date:** November 17, 2026  
**Status:** Complete & Disclosed  

---

## 1. Mock API Limitations

In strict compliance with internship requirements, ServiceMate currently utilizes a simulated data architecture (`MockServiceApiClient`) rather than a live remote server:

- **Static Catalog Data:** 15 services across 6 categories are stored in mock client assets. While changes to bookings and profile persist locally in `SharedPreferences`, adding new service catalog categories dynamically requires code changes or database configuration.
- **Artificial Latency:** The client introduces a 350ms delay to exercise UI loading indicators and spinner states. In a real-world environment, network latency varies according to cellular conditions and CDN routing.
- **Single-Client Scope:** Because the mock API runs in-process on the client device, changes made on one phone (e.g. occupying a time slot) do not propagate to other physical devices without a shared central cloud server.

---

## 2. Simulated Availability Limitations

- **Heuristic Slot Occupancy:** Provider availability is generated algorithmically for a 14-day rolling window rather than querying live calendars (such as Google Calendar API, Microsoft Graph, or Calendly).
- **Time Zone Assumptions:** Availability currently assumes the client device's local system timezone. Cross-timezone scheduling (e.g., booking an online tutor across timezones) is not explicitly calculated.
- **Concurrent Double-Booking Race Condition:** On a multi-user system, two clients attempting to confirm the exact same slot simultaneously requires backend database transactions or optimistic locking. On the local mock architecture, slot locking is evaluated synchronously in `BookingRepository`.

---

## 3. Security & Production-Readiness Gaps

Before deploying ServiceMate into a live commercial enterprise environment, the following security and infrastructure components should be implemented:

1. **Authentication & Identity Provider (OAuth2 / JWT):**
   - Currently, user profile management runs in demo guest mode with local persistence. Production deployment requires integration with Firebase Auth, Auth0, or Supabase Auth with SMS OTP or biometric login.
2. **Payment Gateway Integration:**
   - The application computes real mathematical formulas for base prices, 5% platform fees, and 8% taxes, but confirms bookings without card tokenization. Production deployment will require Stripe SDK, Apple Pay, or Google Pay with PCI-DSS compliance.
3. **Encrypted Local Storage:**
   - Bookings and user profile details are stored in standard `SharedPreferences` as plain JSON strings. In production, sensitive client contact details and payment tokens must be stored in `flutter_secure_storage` (backed by iOS Keychain and Android KeyStore).
4. **Content Security & SSL Pinning:**
   - Production API clients should enforce SSL/TLS certificate pinning and HTTPS strict transport security to protect customer addresses from man-in-the-middle attacks.

---

## 4. Realistic Future Improvements

The modular, feature-first Clean Architecture makes extending ServiceMate straightforward. Recommended roadmap phases include:

### Phase 1: Real-Time Communication & Cloud Backend
- Connect `IServiceApiClient` to a PostgreSQL / Supabase or Firebase backend.
- Implement real-time WebSocket notifications for appointment reminders (e.g., "Your cleaner is on the way").
- In-app chat messaging between client and assigned service provider.

### Phase 2: Live Geolocation & Provider Tracking
- Google Maps / Mapbox Flutter SDK integration to display the service provider's live en-route location.
- Reverse geocoding for automated address autofill via Google Places API.

### Phase 3: Provider Self-Service Portal
- Separate authentication role for service providers to manage their calendar availability, accept or decline incoming bookings, upload certifications, and view payout analytics.

### Phase 4: Multi-Language & Dark Theme
- Localization (`flutter_localizations` with `.arb` files) supporting English, Spanish, French, and Arabic (RTL layout support).
- Dark Mode theme matching the midnight navy aesthetic with high-contrast accessibility tokens.
