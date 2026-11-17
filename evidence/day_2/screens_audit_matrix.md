# Screen & Functional Audit Matrix — Day 2

This document records the runtime verification of every interactive screen, widget flow, and edge case in the ServiceMate application.

---

## 1. Screen-by-Screen Functional Audit

### 1.1 Home Dashboard (`HomeScreen`)
- **Header:** Displays personalized greeting (`Hello, Alex 👋`), user initials badge (`AV`), and demonstration location pill (`San Francisco, Bay Area (Demo)`).
- **Search Pill:** Tap opens the `/services` catalog with the search input active.
- **Category Navigation:** 6 distinct category items (Cleaning, Beauty, Repair, Fitness, Photography, Tutoring). Tapping any category sets the filter and navigates directly to the filtered catalog.
- **Upcoming Booking Banner:** Dynamically renders the next scheduled appointment. Tapping **Details** triggers `BookingDetailsDialog` with direct cancellation capability.
- **Featured & Popular Carousels:** Responsive horizontal scroll and vertical cards with price, duration, rating, and direct "Book Now" CTA.
- **Pull-to-Refresh:** Refreshes categories, featured items, popular items, and active bookings.

### 1.2 Service Catalog (`ServiceCatalogScreen`)
- **Search Bar:** Real-time text filtering across title, description, category, and provider. Clear icon (`X`) clears query and restores list.
- **Category Chips:** Horizontal pills with icons and counts. `All Services` pill resets category filtering.
- **Empty Search Results:** Displays `EmptyStateView` with search-off illustration and a working **Reset Filters** button.
- **Service Cards:** Render category icon banner, provider verification badge, rating stars, review count, price per session, duration, and tap-through to details or booking wizard.

### 1.3 Service Details (`ServiceDetailsScreen`)
- **Hero App Bar:** Category theme gradient, category tag, and back button.
- **Provider Card:** Avatar initial, verified status pill, and rating.
- **Pricing & Duration:** Clean pill widgets displaying session time and cost.
- **Deliverables Checklist:** Itemized list of included services with emerald checkmarks.
- **Guarantee Policy:** 24h free cancellation trust notice.
- **Sticky Bottom Action Bar:** Displays total price and a full-width **Book Appointment** button.

### 1.4 Booking Wizard (`BookingWizardScreen`)
- **Progress Stepper:** 3 numbered steps with active/completed indicators (Date & Time → Your Details → Confirm).
- **Step 1 (Date & Time):** Horizontal 14-day date strip (past dates are impossible to select); Time slot selector partitioned into Morning, Afternoon, and Evening. Booked slots are disabled with strikethrough styling. Requires time slot selection to advance.
- **Step 2 (Details):** Auto pre-filled from user profile (`Alex Vance`, `alex.vance@example.com`, `+1 (555) 234-5678`, `742 Evergreen Terrace`). Validates name, phone, email, and address.
- **Step 3 (Review & Confirm):** Detailed appointment recap, customer details summary, itemized price calculation (Base + 5% platform fee + 8% estimated tax), and demo disclaimer.
- **Collision Protection:** Checks for duplicate active bookings. If collision occurs, displays an inline red error banner and keeps form state intact for correction.

### 1.5 Booking Confirmation (`BookingConfirmationScreen`)
- **Celebration Icon:** Teal circular checkmark.
- **Reference Code Pill:** Formatted as `SM-XXXXXX` with a working tap-to-copy clipboard action.
- **Summary Receipt:** Itemized appointment and pricing summary.
- **Actions:** **View My Bookings** navigates to `/bookings`; **Return to Home** navigates to `/`.

### 1.6 My Bookings (`BookingHistoryScreen`)
- **Tabs:** TabBar with **Upcoming**, **Completed**, and **Cancelled**.
- **Cards:** Reference badge, status pill (`Confirmed`, `In Progress`, `Completed`, `Cancelled`), date/time chip, provider name, and price.
- **Receipt Modal:** Tap **Details** to open bottom sheet with full receipt.
- **Cancellation Flow:** Tap **Cancel** to open `BookingCancelDialog`. Select cancellation reason from dropdown and confirm. Updates status to `cancelled`, adds reason and timestamp, and moves item to Cancelled tab immediately.

### 1.7 User Profile (`ProfileScreen`)
- **Avatar:** Circle avatar with dynamic uppercase initials.
- **Edit Form:** Edit Display Name, Email Address, Phone Number, and Default Service Address.
- **Validation & Persistence:** Validates fields before saving to `SharedPreferences`. Pre-populates all subsequent bookings.

