# Evidence — Day 2: Features & Booking Flow Implementation

**Date:** 15 November 2026 (Day 2 of Sprint)  
**Milestone:** End-to-End User Journey & Presentation Layer

## Summary of Accomplishments
1. **API Client & Repository Pattern:**
   - Implemented `IServiceApiClient` abstraction and `MockServiceApiClient` with 350ms latency simulation and error simulation capabilities.
   - Built `ServiceRepository` handling service retrieval, category queries, and slot availability.
2. **Service Catalog & Details Screens:**
   - Built `HomeScreen` with greeting, search pill, category chips, upcoming appointment banner, and featured/popular carousels.
   - Built `ServiceCatalogScreen` supporting real-time text search and horizontal category tabs.
   - Built `ServiceDetailsScreen` featuring category hero imagery, verified provider badges, "What's Included" checklist, and floating bottom action bar.
3. **Interactive 3-Step Booking Wizard:**
   - **Step 1 (Date & Time):** `DateSelectorStrip` ensuring no past dates can ever be picked; `TimeSlotSelector` with morning, afternoon, and evening slots.
   - **Step 2 (Details):** `AppTextField` with pre-filled profile information, comprehensive regex validators for phone, email, name, and address.
   - **Step 3 (Review & Summary):** Transparent cost breakdown (Base + 5% platform fee + 8% tax), demo disclaimer, and submission button.
4. **Booking Confirmation & History:**
   - `BookingConfirmationScreen` with celebration visual and clipboard copy for reference code (`SM-XXXXXX`).
   - `BookingHistoryScreen` with tabbed views (Upcoming, Completed, Cancelled) and modal receipt dialog.
   - Cancellation flow with dropdown reason picker and status updates.
5. **Profile Screen:**
   - View/edit display name, phone, email, and address, persisting data to `SharedPreferences`.

