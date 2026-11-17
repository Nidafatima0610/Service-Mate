# ServiceMate — Automated & Quality Test Report

**Arrowstack Flutter App Development Internship Evaluation**  
**Project:** ServiceMate — Service Booking App  
**Document:** Test Report (`test_report.md`)  
**Date:** November 17, 2026  
**Status:** 100% Passed (39 / 39 Tests)  

---

## 1. Test Environment

- **Operating System:** Windows 11 Pro Education 64-bit (Build 22000.2538)
- **Flutter Framework:** Flutter 3.47.1 (Channel stable, revision `6655482ec0`)
- **Dart SDK:** Dart 3.13.1
- **State Management:** Flutter Riverpod 3.5.0
- **Test Runner:** Flutter Test Framework (`flutter test`)
- **Static Analyzer:** Flutter Dart Analyzer (`flutter analyze`)
- **Compilation Toolchain:** Android SDK 37.0.0, OpenJDK 21.0.8, Java 17 target compatibility

---

## 2. Automated Test Suite Breakdown (39 Tests)

The test suite is partitioned into unit, repository, edge-case, and widget layers. All 39 tests pass without failure:

```
$ flutter test
00:05 +39: All tests passed!
```

### 2.1 Input Validators Suite (`test/unit/input_validators_test.dart` — 9 Tests)
- `T01`: Name validation returns error when name is empty or whitespace.
- `T02`: Name validation returns error when name is shorter than 2 characters.
- `T03`: Name validation accepts valid single and multi-word names.
- `T04`: Email validation rejects invalid email formats (missing @, invalid domain).
- `T05`: Email validation accepts valid RFC-compliant email addresses.
- `T06`: Phone number validation rejects empty, short (<10 digits), or non-digit input.
- `T07`: Phone number validation accepts valid formatted international/US phone numbers.
- `T08`: DateFormatter correctly rejects past dates and identifies today vs. future dates.
- `T09`: DateFormatter dynamically generates selectable future date windows.

### 2.2 Booking Repository Logic Suite (`test/unit/booking_repository_test.dart` — 4 Tests)
- `T10`: Successfully creates a booking with reference code and itemized fee breakdown (Base + 5% Fee + 8% Tax).
- `T11`: Prevents duplicate bookings for the identical service, date, and time slot by throwing `BookingDuplicateException`.
- `T12`: Correctly detects occupied time slots when checking slot availability.
- `T13`: Cancels an active booking, updates status to `cancelled`, and records cancellation timestamp.

### 2.3 Service Model & API Suite (`test/unit/service_model_and_api_test.dart` — 7 Tests)
- `T14`: ServiceModel duration formatting handles exact hours (e.g. 120m $\rightarrow$ "2 hrs") and combined hours/minutes (e.g. 90m $\rightarrow$ "1h 30m").
- `T15`: ServiceModel JSON serialization and deserialization round-trip integrity.
- `T16`: Loads 6 distinct categories and verifies category models.
- `T17`: Filters services by category ID.
- `T18`: Filters services by search query case-insensitively.
- `T19`: Fetches available time slots for a given service and date.
- `T20`: Handles API client error simulation gracefully with `NetworkException`.

### 2.4 Profile Repository Suite (`test/unit/profile_repository_test.dart` — 3 Tests)
- `T21`: Initializes with default demonstration user profile ("Sarah Jenkins").
- `T22`: Updates profile information and persists changes to local storage.
- `T23`: Enforces validation rules before accepting profile updates.

### 2.5 Edge Cases Suite (`test/unit/edge_cases_test.dart` — 8 Tests)
- `T24`: CurrencyFormatter formats whole integers and fractional decimals accurately without rounding drift.
- `T25`: Mathematical precision of platform fee (5%) and estimated tax (8%) with odd/fractional amounts.
- `T26`: Profile initials generator correctly handles single names ("Sarah" $\rightarrow$ "S"), two names ("Sarah Jenkins" $\rightarrow$ "SJ"), multi-part names ("Sarah Jane Jenkins" $\rightarrow$ "SJ"), and empty strings ("SM").
- `T27`: Allows re-booking the exact same date and time slot after a prior booking on that slot was cancelled.
- `T28`: Handles whitespace-padded search queries and empty strings gracefully without crash.
- `T29`: Address validation enforces minimum 5 characters.
- `T30`: Phone number validation detects excessively short and overly long inputs.
- `T31`: Date parsing handles null and corrupted ISO strings safely by falling back to `DateTime.now()`.

### 2.6 Widget Component & Flow Suite (`test/widget/app_widget_flow_test.dart` — 8 Tests)
- `T32`: `AppButton` renders label and triggers `onPressed` callback.
- `T33`: `AppButton` renders `CircularProgressIndicator` when `isLoading: true` and disables tap interaction.
- `T34`: `BookingStatusBadge` renders appropriate color and text for `confirmed`, `completed`, and `cancelled` statuses.
- `T35`: `CategoryFilterChipWidget` toggles selection state and triggers callback.
- `T36`: `ServiceCard` renders title, provider, duration, rating, and price, firing tap events.
- `T37`: `DateSelectorStrip` renders horizontal selectable dates and updates selected date.
- `T38`: `EmptyStateView` renders custom illustration, title, description, and action button.
- `T39`: `ErrorStateView` renders error message and retry button, invoking retry callback on tap.

---

## 3. Failed Tests and Fixes Applied

During continuous integration and audit verification, 3 issues were encountered and resolved:

1. **`AppButton` RenderFlex Overflow on Narrow Screen Viewports:**
   - *Failure:* Widget test failed with RenderFlex overflow when button label exceeded text bounds in a Row.
   - *Fix:* Wrapped button text in `Flexible` with `TextOverflow.ellipsis` and adjusted container padding.
2. **Re-booking Cancelled Slot Rejection:**
   - *Failure:* Re-booking test threw `BookingDuplicateException` even when the prior conflicting booking had been cancelled.
   - *Fix:* Updated `BookingRepository.hasDuplicateBooking` logic:
     ```dart
     final hasActiveDuplicate = activeBookings.any((b) =>
         b.serviceId == serviceId &&
         b.appointmentDate.year == appointmentDate.year &&
         b.appointmentDate.month == appointmentDate.month &&
         b.appointmentDate.day == appointmentDate.day &&
         b.timeSlot == timeSlot &&
         b.status != BookingStatus.cancelled); // Filter out cancelled
     ```
3. **Corrupted Date Parsing Crash:**
   - *Failure:* Deserializing corrupted date strings in `BookingModel.fromJson` threw `FormatException`.
   - *Fix:* Added `DateFormatter.safeParseIso` with try-catch fallback to system time.

---

## 4. Manual UI & Device Validation

Manual validation was executed across 3 device resolutions:
- **Mobile Compact (360×640):** Verified zero overflow in booking wizard and dialogs; text properly wraps; scroll views are fluid.
- **Standard Phone (393×852):** Tested smooth 60fps scrolling, sticky bottom action bar alignment, and bottom navigation bar transitions.
- **Web Desktop (1920×1080):** Verified responsive CanvasKit web execution at `build/web/`, card grid layouts, and keyboard focus traversal.

---

## 5. Static Analysis Result

```bash
$ flutter analyze
Analyzing service_mate...
No issues found! (ran in 6.4s)
```
- **Total Analyzer Errors:** 0
- **Total Warnings:** 0
- **Total Lints:** 0
