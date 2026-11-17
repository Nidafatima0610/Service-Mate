# Implementation Notes

## 1. Key Engineering Decisions

### 1.1 Local Fallback & Offline Independence
- All 15 fictional services across 6 categories include self-contained vector icons and category colors instead of remote network images. This guarantees that offline usage, plane-mode testing, or slow corporate proxies will never display broken images, distorted layouts, or placeholder errors.
- The `MockServiceApiClient` introduces realistic network latency (350ms) to demonstrate real-world loading indicators and smooth asynchronous transitions, while providing an offline fallback database that requires no external network access.

### 1.2 State Management with Riverpod
- Adopted Riverpod `AsyncNotifier` for both `BookingsNotifier` and `ProfileNotifier`. This provides built-in `AsyncValue.loading`, `AsyncValue.data`, and `AsyncValue.error` states with straightforward pull-to-refresh (`ref.invalidate`) capabilities.
- Separated search query state (`SearchQueryNotifier`) and category filter state (`SelectedCategoryNotifier`) into lightweight dedicated Notifiers, allowing the catalog provider to react dynamically without unnecessary rebuilds.

### 1.3 Booking Conflict Resolution & Duplicate Prevention
- Duplicate detection is enforced both at the UI layer (disabling booked time slots) and at the business logic layer (`BookingRepository.createBooking`).
- If a user attempts to schedule the same service on the same calendar day (year-month-day) and time slot as an active booking, the repository raises a `BookingDuplicateException`.
- Cancelled bookings do not block slots, permitting re-booking if plans change.

### 1.4 Financial Breakdown Logic
- Every booking dynamically computes:
  - Base Service Price
  - Platform Service Fee (5% of base price)
  - Estimated Taxes (8% of base + platform fee)
  - Total Price
- All values are formatted using `CurrencyFormatter` with two-decimal precision.

### 1.5 Storage Architecture
- Persistence is implemented through `SharedPreferences` with JSON serialization.
- On first application launch, the data source auto-seeds realistic demo bookings (one upcoming and one completed) to ensure mentors and reviewers immediately experience a populated app without manual setup.

