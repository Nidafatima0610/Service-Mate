# Acceptance Criteria & Verification Matrix

This matrix verifies that all functional, UI/UX, and quality acceptance criteria specified for the Arrowstack Flutter Internship have been fulfilled.

---

## 1. User Journey Acceptance

| Step | Journey Stage | Acceptance Criteria | Verified Status |
|---|---|---|---|
| 1 | **Home** | Premium welcome banner, search trigger, 6 category quick links, upcoming booking preview, featured & popular carousels. | ✅ Passed |
| 2 | **Browse Categories** | User taps category (e.g. "Home Cleaning"), filters catalog instantly to category items. | ✅ Passed |
| 3 | **Service Listing** | Displays image/icon banner, service title, category, provider, rating, duration, price, and "Book Now" CTA. | ✅ Passed |
| 4 | **Service Details** | Hero banner, provider card, description, "What's Included" checklist, policy banner, sticky bottom action bar. | ✅ Passed |
| 5 | **Select Date** | 14-day horizontal date selector. Current date highlighted. Past dates cannot be selected. | ✅ Passed |
| 6 | **Select Time Slot** | Morning, afternoon, and evening slots. Disabled state for booked slots. Requires slot selection to proceed. | ✅ Passed |
| 7 | **Customer Details** | Pre-fills from saved profile. Validates full name, email, phone, and address before allowing progression. | ✅ Passed |
| 8 | **Review & Summary** | Shows itemized pricing (Base + 5% Fee + 8% Tax), customer details, appointment schedule, demo disclaimer. | ✅ Passed |
| 9 | **Confirm Booking** | Validates against duplicate slot bookings. Shows progress spinner. Generates unique reference code (`SM-XXXXXX`). | ✅ Passed |
| 10 | **Booking Success** | Success checkmark, reference code with one-tap copy, details summary, navigation to "My Bookings" or "Home". | ✅ Passed |
| 11 | **My Bookings** | Tabbed into Upcoming, Completed, and Cancelled. Shows cards with status pills. Cancellation dialog with reason selection. | ✅ Passed |
| 12 | **Profile Management** | Edit display name, email, phone, and address. Validates inputs, saves to `SharedPreferences`, reflects on future bookings. | ✅ Passed |

---

## 2. Technical & QA Criteria

| Requirement | Acceptance Threshold | Verified Result |
|---|---|---|
| **Null Safety** | 100% sound null safety across entire codebase. | ✅ Sound null safety compliant |
| **Code Analyzer** | `flutter analyze` must exit with 0 errors and 0 warnings. | ✅ 0 issues found |
| **Automated Tests** | Unit tests for models, validation, repositories, and widget tests for key components. | ✅ 31 / 31 tests passing |
| **Duplicate Prevention** | Attempting to book the same service, date, and time slot must throw `BookingDuplicateException` and display user-friendly error. | ✅ Tested and verified in unit tests & UI wizard |
| **Past Date Rejection** | Booking on a past date must throw `ValidationException`. | ✅ Tested and verified in unit tests & UI wizard |
| **Persistence Across Restarts** | Bookings and profile updates survive application shutdown via `SharedPreferences`. | ✅ Tested with `SharedPreferences` serialization |
| **Production Build** | Successful release build without compilation errors. | ✅ `build/web` release artifact generated |

