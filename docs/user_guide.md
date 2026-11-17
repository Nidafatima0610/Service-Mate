# ServiceMate — User & Evaluation Guide

**Arrowstack Flutter App Development Internship Evaluation**  
**Project:** ServiceMate — Service Booking App  
**Document:** User & Evaluation Guide (`user_guide.md`)  
**Date:** November 17, 2026  
**Status:** Complete & Verified  

---

## 1. How to Run the Application

### 1.1 Prerequisites
- Flutter SDK 3.x installed (Tested on Flutter 3.47.1 Stable).
- Dart SDK 3.x (Tested on Dart 3.13.1).
- Google Chrome browser (for Web) or Android device / emulator.

### 1.2 Running on Web (Instant Launch)
```bash
# 1. Navigate to the project root directory
cd service_mate

# 2. Get dependencies
flutter pub get

# 3. Launch in Chrome
flutter run -d chrome
```

### 1.3 Running on Android Device or Emulator
```bash
# Connect your Android phone via USB (with USB Debugging enabled) or start an Android Emulator:
flutter devices

# Run on the connected Android target:
flutter run -d android
```

### 1.4 Installing the Verified Production APK
The production release APK is pre-compiled and verified at:
`build/app/outputs/flutter-apk/app-release.apk`
(or inside the submission package at `release/app-release.apk`).

To install directly onto an Android device via ADB:
```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

---

## 2. How to Browse Services

1. **Explore the Home Screen:**
   - Launch ServiceMate. The **Home Screen** welcomes you with personalized greeting and displays quick category chips.
   - Scroll through **Featured Services** and **Popular Services** to view curated offerings with prices, duration, and ratings.
2. **Access the Full Catalog:**
   - Tap the **Catalog** tab on the bottom navigation bar.
3. **Filter by Category:**
   - Tap any category chip (e.g. *Home Cleaning*, *Beauty & Salon*, *Home Repair*, *Personal Training*, *Photography*, *Tutoring*) to filter the catalog instantly.
   - Tap *All* to clear category filters.
4. **Search by Keyword:**
   - Type in the search input (e.g., "Deep", "Yoga", "Math", "Portrait") to filter services in real time.
   - If no services match your query, an empty-state illustration will appear with a "Reset Filters" button.

---

## 3. How to Book a Service (Step-by-Step Wizard)

1. **Select a Service:**
   - Tap on any service card in the Home feed or Catalog (e.g., *Deep Home Cleaning*).
   - Review provider credentials, experience rating, "What's Included" checklist, and service guarantee.
   - Tap the **Book This Service** primary button at the bottom.
2. **Step 1: Select Date & Time Slot:**
   - Scroll horizontally along the 14-day date strip. Notice past dates cannot be selected.
   - Tap a future date (e.g., tomorrow).
   - Choose an available time slot from the **Morning**, **Afternoon**, or **Evening** sections.
   - Tap **Continue**.
3. **Step 2: Enter Contact & Service Location:**
   - Your contact information is automatically pre-filled from your profile!
   - Review or edit your Full Name, Email, Phone Number, and Street Address.
   - Add optional special instructions (e.g., "Please ring door chime #4B").
   - Tap **Continue**.
4. **Step 3: Review & Confirm:**
   - Verify appointment details, date, time slot, and provider name.
   - Inspect the itemized cost breakdown:
     - Base Service Price
     - 5% Platform Fee
     - 8% Estimated Taxes
     - Final Total
   - Tap **Confirm Booking**.
5. **Confirmation & Reference Code:**
   - You are greeted with a success celebration screen showing your unique booking reference (e.g., `SM-20261116-A1B2`).
   - Tap **Copy Reference** to copy it to your device clipboard.
   - Tap **View in My Bookings** to see your scheduled appointment.

---

## 4. How to View and Cancel Bookings

1. **Access Booking History:**
   - Tap the **Bookings** tab on the bottom navigation bar.
2. **Switch Tabs:**
   - **Upcoming:** Displays all confirmed future appointments.
   - **Completed:** Displays past appointments.
   - **Cancelled:** Displays previously cancelled appointments.
3. **View Full Receipt:**
   - Tap on any booking card to open the **Booking Details** modal sheet.
   - Inspect provider info, appointment date/time, client address, and complete itemized financial receipt.
4. **Cancel an Appointment:**
   - On an active booking in the **Upcoming** tab, tap **Cancel Booking**.
   - Select a reason in the cancellation dialog (e.g., *Schedule Conflict*, *Booked by Mistake*, *Other*).
   - Tap **Confirm Cancellation**.
   - The booking immediately updates to `cancelled` and moves to the **Cancelled** tab. The occupied time slot is now freed for re-booking!

---

## 5. How to Edit Profile Information

1. **Access Profile:**
   - Tap the **Profile** tab on the bottom navigation bar.
2. **Modify Details:**
   - Edit your **Full Name**, **Email Address**, **Phone Number**, or **Default Address**.
   - The avatar initials dynamically recalculate as you type your name.
3. **Save Updates:**
   - Tap **Save Changes**. Changes are immediately persisted in `SharedPreferences`.
   - Return to the **Home** tab to verify that the welcome greeting updates immediately.
4. **Restore Demo Profile:**
   - Tap **Reset Demo Profile** at any time to restore the original demonstration data ("Sarah Jenkins").
