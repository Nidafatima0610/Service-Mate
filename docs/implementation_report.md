# ServiceMate — Implementation Report

**Arrowstack Flutter App Development Internship Evaluation**  
**Project:** ServiceMate — Service Booking App  
**Document:** Implementation Report (`implementation_report.md`)  
**Date:** November 17, 2026  
**Status:** Complete & Verified  

---

## 1. Features Implemented

The full feature scope specified in the internship guidelines was systematically implemented:

1. **Multi-Category Service Catalog:** 15 distinct, realistic services distributed across 6 core categories (Home Cleaning, Beauty & Salon, Home Repair, Personal Training, Photography, Tutoring).
2. **Search & Interactive Filtering:** Real-time search query filtering and interactive horizontal category chips with instant results and an empty-state reset.
3. **Service Details Screen:** Comprehensive service descriptions, provider credential card, verified badge, ratings, reviews, "What's Included" deliverable checklist, and service guarantee.
4. **Interactive 3-Step Booking Wizard:**
   - *Step 1: Date & Time Slot Selection* (14-day rolling horizontal date strip, past-date prohibition, morning/afternoon/evening slot groupings, real-time slot conflict detection).
   - *Step 2: Customer Contact & Location* (Auto-populated from local profile, validated inputs for name, email, phone, and address).
   - *Step 3: Summary & Review* (Transparent itemized calculation of base price, 5% platform fee, and 8% estimated tax).
5. **Cryptographic Reference & Confirmation:** Generation of unique human-readable booking references (`SM-YYYYMMDD-XXXX`), with celebration view and one-tap clipboard copy.
6. **Local Persistence Across Restarts:** Full JSON serialization to `SharedPreferences` for both bookings and user profiles.
7. **Tabbed Booking History:** Categorized views for Upcoming, Completed, and Cancelled appointments with itemized receipt modal dialogs.
8. **Self-Service Cancellation Workflow:** Modal cancellation dialog capturing user reason, updating booking status to `cancelled`, recording cancellation timestamp, and freeing the time slot for future re-booking.
9. **User Profile Management:** Editable name, email, phone number, and default address with live validation and "Reset to Demo Defaults" feature.
10. **Resilient Error & Fallback UI:** Reusable empty-state and error-state widgets with retry mechanisms and latency simulation.

---

## 2. Screen Descriptions

### 2.1 Home Screen (`home_screen.dart`)
- **Header:** Features a personalized greeting ("Hello, Sarah 👋"), location indicator, and quick profile avatar displaying user initials.
- **Search Bar:** Prominent search input navigating or filtering catalog items with instant feedback.
- **Category Strip:** Horizontal list of category pills with custom vector icons and distinct color accents.
- **Upcoming Booking Banner:** High-priority card rendering the user's nearest upcoming appointment with service name, provider, date/time, and one-tap receipt modal.
- **Featured & Popular Lists:** Vertically stacked carousels highlighting top-rated services with rating badges and session prices.

### 2.2 Service Catalog Screen (`service_catalog_screen.dart`)
- Search input with clear button and real-time query listener.
- Category filter chips row with horizontal scrolling.
- Responsive grid/list rendering `ServiceCard` widgets with title, provider, duration, rating, and price.
- `EmptyStateView` triggered when search query or filter returns zero matches, offering a "Reset Filters" CTA.

### 2.3 Service Details Screen (`service_details_screen.dart`)
- Visual hero banner with category icon badge and color identity.
- Service title, category chip, duration, and rating badge.
- Provider credential card with verification badge and experience rating.
- Expandable service description.
- "What's Included" structured checklist with custom checkmark bullets.
- ServiceMate customer satisfaction guarantee & 24h free cancellation policy note.
- Sticky bottom action bar with price display and "Book This Service" primary button.

### 2.4 Booking Wizard Screen (`booking_wizard_screen.dart`)
- **Top Step Indicator:** Animated 3-step progress bar (Date & Time → Contact Info → Review).
- **Step 1:** 14-day horizontal date selector with day-of-week and month indicators. Period-grouped time slots (Morning, Afternoon, Evening) with disabled states for booked slots.
- **Step 2:** Profile-synced input fields for Full Name, Email, Phone Number, Service Address, and optional Special Instructions.
- **Step 3:** Detailed appointment review card, provider info, date/time chips, and itemized financial breakdown table.
- **Bottom Navigation Bar:** "Back" and "Continue / Confirm Booking" buttons with inline loading spinners.

### 2.5 Booking Confirmation Screen (`booking_confirmation_screen.dart`)
- Animated success illustration with celebratory teal badge.
- Prominent unique booking reference code with one-tap clipboard copy button.
- Appointment summary card with service, provider, date, time slot, and total paid.
- Dual navigation actions: "View in My Bookings" and "Back to Home".

### 2.6 Booking History Screen (`booking_history_screen.dart`)
- 3 filterable tabs: Upcoming, Completed, and Cancelled.
- Status badges: Teal for Confirmed, Amber for Completed, and Crimson for Cancelled.
- Cards display reference code, service title, provider, date, time, and fee.
- Tapping a card opens the `BookingDetailsDialog` modal receipt.
- "Cancel Booking" action initiates the `BookingCancelDialog`.

### 2.7 Profile Screen (`profile_screen.dart`)
- Profile avatar with dynamically generated initials.
- Form fields for Display Name, Email Address, Phone Number, and Default Street Address.
- "Save Changes" button persisting modifications to `SharedPreferences` with toast confirmation.
- "Reset Demo Profile" button allowing reviewers to restore default state.

---

## 3. Main Workflows

### 3.1 The End-to-End Booking Workflow
```
[Home Screen / Catalog]
       │
       ▼ (Tap "Book Now")
[Booking Wizard: Step 1] ── Select Date (Future date only) & Time Slot
       │
       ▼ (Tap "Continue")
[Booking Wizard: Step 2] ── Enter / Review Contact & Service Location
       │
       ▼ (Tap "Continue")
[Booking Wizard: Step 3] ── Review Itemized Summary & Guard Duplicate Booking
       │
       ▼ (Tap "Confirm Booking")
[Booking Confirmation]   ── Generate Reference (SM-YYYYMMDD-XXXX) & Persist to Storage
       │
       ▼ (Tap "View in My Bookings")
[My Bookings History]    ── Appointment appears under "Upcoming" Tab
```

### 3.2 The Cancellation & Slot Release Workflow
```
[My Bookings History]
       │
       ▼ (Tap "Cancel Booking" on an Upcoming card)
[Cancellation Dialog]    ── Select Reason ("Schedule Conflict", "Other") & Confirm
       │
       ▼
[Repository Update]      ── Status set to "cancelled", timestamp recorded, slot unlocked
       │
       ▼
[My Bookings History]    ── Appointment moves to "Cancelled" Tab; slot freed for booking
```

---

## 4. Challenges & Engineering Solutions

1. **Gradle Out-of-Memory / Low-Disk Failure during APK Release:**
   - *Challenge:* Host drive C: had only ~1.2 GB of free space, causing Android Gradle's multi-dexing task `assembleRelease` to throw `java.io.IOException: There is not enough space on the disk`.
   - *Solution:* Systematically purged orphaned temporary build caches from `$env:TEMP` to reclaim 2.48 GB, configured Gradle JVM arguments, and executed `flutter build apk --release`. The build completed cleanly in 379s, yielding a verified 51.2 MB release APK.

2. **Deprecation of `StateProvider` in Riverpod 3.0:**
   - *Challenge:* Flutter 3.47 bundles Riverpod 3.5.0 where `StateProvider` is formally deprecated in favor of explicit `Notifier` classes.
   - *Solution:* Refactored all filter states into dedicated `SelectedCategoryNotifier` and `SearchQueryNotifier` classes extending `Notifier<T>`, guaranteeing long-term API stability and strict null safety.

3. **Relative Import URI Resolution Issues:**
   - *Challenge:* Deep relative imports across feature modules (`../../features/...`) caused analyzer warnings and broken references.
   - *Solution:* Refactored all internal imports across `lib/` and `test/` to package URI format (`package:service_mate/...`), resolving all compiler ambiguities.

4. **Widget RenderFlex Overflow in `ErrorStateView` & Buttons:**
   - *Challenge:* On narrow device screens (360px width), long error messages and button labels caused RenderFlex row overflows by 35 pixels.
   - *Solution:* Refactored `AppButton` label to wrap in `Flexible(child: Text(label, overflow: TextOverflow.ellipsis))` and expanded touch target paddings to maintain responsive fluid layout.

---

## 5. Decisions & Architectural Trade-Offs

- **Interface-Driven API Client (`IServiceApiClient`):** Implemented `MockServiceApiClient` with 350ms artificial latency. Trade-off: Development requires mock data maintenance, but provides 100% test reproducibility, eliminates external network dependencies, and enables effortless migration to production REST/GraphQL.
- **Local Vectors vs. Remote Photos:** Used curated Flutter vector icons and color badges instead of external Unsplash/Pexels image URLs. Trade-off: Less photorealistic imagery, but guarantees zero layout shift, zero broken images in offline environments, and instant loading speeds.
- **Dual-Layer Validation:** Enforced validation at both UI text fields (`InputValidators`) and repository business logic (`BookingRepository.createBooking`). Trade-off: Minimal code duplication, but ensures business invariants (such as duplicate slot prevention and past-date rejection) cannot be violated under any condition.
