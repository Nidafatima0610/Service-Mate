# ServiceMate — Service Booking App: Requirements Specification

**Arrowstack Flutter App Development Internship Evaluation**  
**Project:** ServiceMate — Service Booking App  
**Document:** Requirements Specification (`requirements.md`)  
**Date:** November 17, 2026  
**Status:** Implemented, Fully Tested (39/39 Passing) & Verified  
**Platforms:** Android (Production APK Verified), Web (Production Web Verified), Windows Desktop  

---

## 1. Project Background

ServiceMate was developed as a flagship mobile project for the Arrowstack Flutter App Development Internship. The platform addresses the need for a modern, frictionless service-booking application that allows customers to discover, evaluate, and schedule on-demand home, personal, and wellness services. 

The application is engineered with high architectural standards, adhering to Clean Architecture principles, reactive state management using Flutter Riverpod, robust offline capabilities with `SharedPreferences`, strict dual-layer input and business logic validation, and a cohesive design language.

---

## 2. Target Users

ServiceMate caters to two primary audience segments:

1. **Busy Urban Homeowners & Renters:**
   - Individuals seeking reliable, vetted professionals for routine home maintenance, recurring deep cleaning, emergency repairs, and seasonal maintenance.
   - Values: Speed, transparent pricing, guaranteed arrival time slots, and effortless cancellation or rescheduling.
2. **Personal Wellness & Lifestyle Clients:**
   - Clients booking personal training sessions, tutoring, photography sessions, or beauty/salon treatments.
   - Values: Verified provider credentials, transparent service breakdowns, rating reviews, and immediate booking confirmation with unique reference codes.

---

## 3. User Problem Statement

In conventional on-demand service ecosystems, consumers experience significant friction:
- **Opaque Pricing:** Hidden platform fees, unexpected travel charges, and ambiguous base rates.
- **Unreliable Scheduling:** Manual telephone confirmation, scheduling conflicts, double-bookings, and inability to view confirmed appointments offline.
- **Disjointed Booking Experience:** Rigid forms that lose input on navigation, lack of real-time validation, and clunky cancellation workflows.

**ServiceMate solves these issues** by providing an intuitive 3-step booking wizard, dynamic 14-day date strip scheduling, real-time slot conflict detection, itemized cost receipts (Base + 5% Platform Fee + 8% Tax), instant cryptographic reference generation (`SM-YYYYMMDD-XXXX`), offline-first appointment persistence, and a frictionless self-service cancellation flow.

---

## 4. Scope & Boundaries

### 4.1 In-Scope Capabilities
- Multi-category service catalog with 6 distinct service categories.
- Real-time case-insensitive keyword search and category filtering with instant empty-state feedback.
- Rich service detail view featuring provider profiles, customer satisfaction guarantees, deliverables checklists, and ratings.
- 3-step interactive booking wizard:
  1. *Step 1: Date & Time Selection* (14-day rolling window, past-date prohibition, dynamic morning/afternoon/evening slots).
  2. *Step 2: Customer Contact & Location* (Auto-populated from profile, validated contact details).
  3. *Step 3: Review & Confirmation* (Full itemized financial breakdown, duplicate booking guard).
- Unique booking reference generation (`SM-YYYYMMDD-XXXX`) and instant clipboard copy.
- Persistent local storage (`SharedPreferences`) ensuring appointments and profiles survive app restarts.
- Tabbed booking history (Upcoming, Completed, Cancelled) with full receipt inspection.
- Booking cancellation workflow with reason capture and automatic slot release for re-booking.
- User profile management with input validation and local synchronization.
- Comprehensive automated test suite (39 unit, repository, model, and widget tests).
- Multi-platform production builds (Verified Android Release APK & Verified Web Release Bundle).

### 4.2 Out-of-Scope / Demo Boundaries
- **Simulated Availability:** Provider slot availability is simulated through an algorithmic mock data layer (`MockServiceApiClient`), avoiding dependencies on external third-party calendars.
- **Simulated Payment Gateway:** Transactions compute real financial mathematics (Base, 5% Fee, 8% Tax) but simulate payment confirmation without live card processors (Stripe/PayPal) for evaluation safety.
- **No Cloud Multi-Tenancy:** Persistence is local to the device via `SharedPreferences`; multi-user cloud synchronization (Firebase/Supabase) is intentionally excluded per internship scope.
- **No External GPS Hardware:** Service addresses use validated street text rather than live GPS turn-by-turn navigation.

---

## 5. Functional Requirements

### 5.1 Home Screen
- **FR-HOM-01:** Welcome header displaying user's name (reactive to profile changes) and quick action avatar.
- **FR-HOM-02:** Search input field offering instant search filtering across all catalog items.
- **FR-HOM-03:** Horizontal scrollable category navigation bar representing the 6 primary categories.
- **FR-HOM-04:** Featured Services carousel highlighting top-rated services with rating badges and prices.
- **FR-HOM-05:** Popular Services listing showing high-demand offerings.
- **FR-HOM-06:** Upcoming Booking Banner dynamically displaying the user's next chronological confirmed appointment with one-tap view details.
- **FR-HOM-07:** Bottom Navigation Bar allowing fluid tab switching between Home, Catalog, Bookings, and Profile with state preservation.

### 5.2 Service Catalog & Details
- **FR-CAT-01:** Catalog view displaying service cards with category tag, title, duration, starting price, provider name, and rating.
- **FR-CAT-02:** Interactive filter chips allowing filtering by specific category or "All Services".
- **FR-CAT-03:** Dynamic search filter with instant UI update and whitespace trimming.
- **FR-CAT-04:** Dedicated `EmptyStateView` when search or filter combinations yield zero results, featuring a "Reset Filters" action.
- **FR-CAT-05:** Detailed service screen presenting service description, provider profile card with verified badge, "What's Included" checklist, and service guarantee.
- **FR-CAT-06:** Sticky bottom action bar displaying service fee and "Book Now" CTA navigating to the booking wizard with context pre-loaded.

### 5.3 Booking System & Wizard
- **FR-BKG-01:** Step 1 allows date selection from a 14-day rolling window starting today. Past dates are strictly non-selectable.
- **FR-BKG-02:** Dynamic time slot selector rendering Morning (08:00–11:30), Afternoon (12:00–16:30), and Evening (17:00–19:30) slots.
- **FR-BKG-03:** Occupied or reserved slots render in disabled grey styling and prevent selection.
- **FR-BKG-04:** Step 2 validates client name ($\ge 2$ characters), email (standard RFC pattern), phone number (10–15 digits), and service address ($\ge 5$ characters).
- **FR-BKG-05:** Customer fields are automatically pre-populated from the user's stored profile to minimize typing friction.
- **FR-BKG-06:** Step 3 displays a complete booking summary with itemized receipt: Base Price, 5% Platform Fee, 8% Estimated Tax, and Final Total.
- **FR-BKG-07:** Duplicate booking guard: Prohibits booking the identical service on the same calendar day and time slot if an active booking already exists.
- **FR-BKG-08:** Booking confirmation generates a unique reference code (`SM-YYYYMMDD-XXXX`), stores the booking to local disk, and navigates to the celebration screen.
- **FR-BKG-09:** Confirmation screen offers "Copy Reference", "View in My Bookings", and "Return to Home".

### 5.4 My Bookings & Cancellation
- **FR-HIS-01:** Tabbed booking management: **Upcoming** (chronologically sorted future bookings), **Completed** (past appointments), and **Cancelled**.
- **FR-HIS-02:** Booking cards display service name, provider, reference code, formatted date/time, total price, and colored status badge.
- **FR-HIS-03:** Tapping a booking opens the full modal receipt dialog with itemized financial breakdown, contact info, and actions.
- **FR-HIS-04:** Cancellation flow prompts user with a confirmation dialog and reason selector (e.g., "Schedule Conflict", "Booked by Mistake", "Other").
- **FR-HIS-05:** Upon cancellation, status transitions to `cancelled`, the cancellation timestamp is recorded, and the time slot is freed for re-booking.

### 5.5 Profile Management
- **FR-PRF-01:** Displays user profile avatar with initials computed dynamically from full name.
- **FR-PRF-02:** Editable text fields for Full Name, Email, Phone Number, and Default Service Address.
- **FR-PRF-03:** Input validation on save; prevents empty or malformed inputs.
- **FR-PRF-04:** Immediate local persistence in `SharedPreferences`. Profile updates reflect instantly across Home header and booking forms.
- **FR-PRF-05:** "Reset to Demo Defaults" feature allowing reviewers to re-seed demo profile data with one tap.

---

## 6. Technical Requirements

| ID | Requirement | Handbook Specification | Actual Implementation |
|---|---|---|---|
| **TR-01** | **Framework & SDK** | Flutter 3.x with Dart 3 null-safety | Flutter 3.47.1 Stable, Dart 3.13.1, 100% sound null-safety |
| **TR-02** | **State Management** | Predictable, reactive architecture | Flutter Riverpod 3.5.0 (`AsyncNotifier`, `NotifierProvider`, `FutureProvider`) |
| **TR-03** | **Navigation & Routing** | Deep linking, shell routes | GoRouter 14.8.1 with `StatefulShellRoute.indexedStack` for bottom navigation |
| **TR-04** | **Local Persistence** | Retain data across app restarts | `SharedPreferences` with custom JSON model serialization |
| **TR-05** | **Architecture Pattern** | Maintainable Clean Architecture | Layered Feature-First pattern (Data, Models, Repositories, Providers, Presentation) |
| **TR-06** | **Code Quality & Lints** | Zero errors, strict analysis | `flutter analyze` reports **0 issues found** |
| **TR-07** | **Automated Testing** | Comprehensive automated test suite | **39 passing tests** across unit, repository, edge-case, and widget layers |
| **TR-08** | **Release Verification** | Production release compilation | **Verified Android Release APK (51.2 MB)** + **Verified Web Release Bundle** |

---

## 7. Success Criteria

1. **User Experience:** Flawless completion of the 8-stage booking journey:
   `Home → Category → Service Details → Select Date → Select Slot → Contact Info → Confirm Summary → Success Screen → My Bookings`.
2. **Data Integrity:** No booking collisions; cancellation immediately frees time slot; cold restart preserves all bookings and profile modifications.
3. **Robustness:** 100% test pass rate with zero analyzer warnings.
4. **Reproducibility:** A reviewer or mentor can clone the repository, run `flutter pub get`, `flutter test`, and `flutter run` without undocumented dependencies or secret keys.
