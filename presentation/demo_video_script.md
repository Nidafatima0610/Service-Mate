# ServiceMate — Concise Demo Video Script (3–5 Minutes)

**Arrowstack Flutter App Development Internship Evaluation**  
**Project:** ServiceMate — Service Booking App  
**Document:** Demonstration Video Script (`demo_video_script.md`)  
**Date:** November 17, 2026  
**Target Video Duration:** Approximately 3 minutes 30 seconds  

---

## Scene 1: App Launch & Home Screen Tour (0:00 – 0:35)

- **Visual Action:**
  - Launch ServiceMate on device or emulator.
  - The app smoothly opens to the **Home Screen**.
  - Show the top header: personalized greeting ("Hello, Sarah 👋"), location indicator, and profile initials avatar ("SJ").
  - Point out the demo pill banner at the top: *"Demo Mode — Fictional Services & Providers"*.
  - Scroll past the Category Strip, highlight the **Upcoming Booking Banner** (*"Deep Home Cleaning with SparkleClean Pro on Nov 18"*), and scroll through **Featured** and **Popular** services.
- **Narrator Voiceover:**
  > *"Welcome to ServiceMate — an on-demand service booking application built with Flutter, Riverpod, and Clean Architecture for the Arrowstack internship. Upon launch, the home dashboard welcomes the user, highlights upcoming appointments, and provides instant access to our 6 core service categories."*

---

## Scene 2: Browse Services & Category Filtering (0:35 – 1:05)

- **Visual Action:**
  - Tap on the **Catalog** tab in the bottom navigation bar.
  - Show the 15 available services with prices, durations, and ratings.
  - Tap the **Beauty & Salon** category chip — the list filters instantly.
  - Tap the **Tutoring** category chip — the list updates to academic services.
  - Type *"Yoga"* into the search bar. Observe the immediate filtered result: *"Private Yoga Instruction"*.
  - Clear the search and tap *"All"* to restore the full catalog.
- **Narrator Voiceover:**
  > *"Navigating to the catalog, users can browse services across Home Cleaning, Beauty, Repair, Fitness, Photography, and Tutoring. The search and category filtering work instantaneously with Riverpod notifiers, maintaining state across transitions."*

---

## Scene 3: Service Details Inspection (1:05 – 1:30)

- **Visual Action:**
  - Tap on **"Deep Home Cleaning"** (\$120.00 • 3 hrs • 4.9 ★).
  - The **Service Details Screen** opens.
  - Scroll through the service description, verified provider card for *"SparkleClean Pro"*, the *"What's Included"* checklist, and the customer satisfaction guarantee.
  - Tap the sticky bottom button: **"Book This Service"**.
- **Narrator Voiceover:**
  > *"Selecting a service presents a comprehensive details view, complete with verified provider credentials, a deliverables checklist, transparent pricing, and our satisfaction policy. Tapping 'Book This Service' launches our 3-step interactive booking wizard."*

---

## Scene 4: Booking Wizard — Date & Time Slot Selection (1:30 – 2:00)

- **Visual Action:**
  - The wizard opens to **Step 1: Date & Time**.
  - Highlight the 14-day rolling horizontal calendar strip. Notice that past dates are excluded.
  - Select tomorrow's date.
  - In the time slot section, show the period groupings: Morning, Afternoon, and Evening.
  - Select the **"10:00 AM"** Morning slot.
  - Tap **"Continue"**.
- **Narrator Voiceover:**
  > *"Step 1 allows clients to select an appointment date from a rolling 14-day window. Past dates are strictly disabled. The time-slot selector groups available times into Morning, Afternoon, and Evening, dynamically graying out occupied slots to prevent scheduling conflicts."*

---

## Scene 5: Booking Wizard — Contact Info & Summary (2:00 – 2:30)

- **Visual Action:**
  - The wizard transitions to **Step 2: Contact & Location**.
  - Show that fields are automatically pre-populated from the user's profile: Full Name ("Sarah Jenkins"), Email, Phone, and Address.
  - Type a quick note in Special Instructions: *"Please ring doorbell 4B"*.
  - Tap **"Continue"**.
  - The wizard transitions to **Step 3: Review & Summary**.
  - Inspect the itemized pricing table:
    - Base Service Price: \$120.00
    - Platform Service Fee (5%): \$6.00
    - Estimated Taxes (8%): \$10.08
    - Total: \$136.08
  - Tap **"Confirm Booking"**.
- **Narrator Voiceover:**
  > *"Step 2 auto-fills customer details from local storage to minimize typing friction. Step 3 provides full financial transparency with an itemized breakdown of base cost, platform fee, and estimated tax. When confirming, the repository enforces a duplicate-booking guard to ensure no double-bookings occur."*

---

## Scene 6: Booking Confirmation & Reference Code (2:30 – 2:50)

- **Visual Action:**
  - The app transitions to the **Booking Confirmation Celebration Screen**.
  - Show the celebratory teal checkmark icon.
  - Highlight the unique generated reference code: e.g. **`SM-20261117-9F2A`**.
  - Tap **"Copy Reference"** — a toast appears confirming *"Reference code copied to clipboard"*.
  - Tap **"View in My Bookings"**.
- **Narrator Voiceover:**
  > *"Upon confirmation, a unique booking reference code is generated and saved locally in SharedPreferences. Users can copy the reference with one tap or immediately inspect their scheduled appointment in the My Bookings section."*

---

## Scene 7: Booking History & Self-Service Cancellation (2:50 – 3:15)

- **Visual Action:**
  - In the **Bookings** tab, show the newly confirmed booking at the top of the **"Upcoming"** list.
  - Tap on the card to open the **Booking Details modal receipt**, showing full appointment breakdown. Dismiss the sheet.
  - Tap **"Cancel Booking"** on the card.
  - In the cancellation dialog, select the reason *"Schedule Conflict"* and tap **"Confirm Cancellation"**.
  - The booking card smoothly transitions from "Upcoming" to the **"Cancelled"** tab with a red status badge, and the time slot is immediately freed.
- **Narrator Voiceover:**
  > *"The My Bookings screen manages Upcoming, Completed, and Cancelled appointments. Tapping an appointment reveals the full digital receipt. To demonstrate our robust business logic, cancelling an appointment captures the reason, updates the status, and releases the time slot for future bookings."*

---

## Scene 8: Profile Editing & Persistence (3:15 – 3:35)

- **Visual Action:**
  - Tap on the **Profile** tab in the bottom navigation bar.
  - Show the profile avatar with initials *"SJ"*.
  - Edit the name from *"Sarah Jenkins"* to *"Sarah Connor"*.
  - Notice the avatar initials instantly change to *"SC"*.
  - Tap **"Save Changes"**.
  - Switch to the **Home** tab — the welcome header now reads: *"Hello, Sarah Connor 👋"*.
- **Narrator Voiceover:**
  > *"Finally, the profile management screen allows instant updating of customer credentials. Changes persist locally across restarts and immediately update across the entire app. With 39 passing tests and a verified production release APK, ServiceMate is complete, reliable, and ready for internship evaluation. Thank you!"*
